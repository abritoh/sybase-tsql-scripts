
IF EXISTS(SELECT 1 FROM sysobjects WHERE id=OBJECT_ID('sp_c00_get_1000000_000_exp') AND type='P')
    DROP PROCEDURE sp_c00_get_1000000_000_exp
go    

CREATE PROCEDURE dbo.sp_c00_get_1000000_000_exp
( 
    @p_f_rsp_cierre1 datetime, 
    @p_f_rsp_cierre2 datetime,
    @p_f_registro1 datetime,    
    @p_f_registro2 datetime,
    @p_tipo_con int,
    @p_filtro varchar(200)
)
AS
-- =================================================================================================
-- Date          Author             Comment
-- ------------- ------- ---------------------------------------------------------------------------
-- 2009-08-18    ArBR               arcebrito@gmail.com
-- =================================================================================================
BEGIN

    SET NOCOUNT OFF
    SET TRANSACTION ISOLATION LEVEL 0    
    DECLARE @sql varchar(500)    
            
    IF( ISNULL(@p_f_rsp_cierre1,"") = "" )
    BEGIN
        RAISERROR 99991 "Falta parametro: Fecha de Cierre 1." 
        RETURN -1
    END       
    
    IF( ISNULL(@p_f_rsp_cierre2,"") = "" )
    BEGIN
        RAISERROR 99992 "Falta parametro: Fecha de Cierre 2." 
        RETURN -1
    END    
    
    SELECT @p_tipo_con = ISNULL(@p_tipo_con,0)
    
    
    IF( ISNULL(@p_f_registro1,"") = "" )
        SELECT @p_f_registro1 = CONVERT(datetime, "20061001", 112)
    
    IF( ISNULL(@p_f_registro2,"") = "" )
        SELECT @p_f_registro2 = GETDATE()    


    SELECT
        A.anio, A.folioEnlace, A.n_oficios, A.n_respuestas, A.p_respuestas, 
        C.noControlInt, C.fecha_registro, C.cve_estatus,  C.cve_area, C.referenciaAsunto,
        K.cveInstitu, K.nomInstitu,
        L.usuario, L.nombre, L.prefijo_ofi
        INTO #TMP_EXP_100PCT        
            FROM res_cge_expsiti A, 
                 ori_cge_documentos C, aut_cge_expedientes D,
                 cat_cge_autoridad_solicitante K, cat_cge_usuarios L 
                WHERE 
                (
                     C.anio = A.anio AND C.folioEnlace = A.folioEnlace AND
                     D.anio = A.anio AND D.folioEnlace = A.folioEnlace AND         
                     K.cveInstitu = C.cveInstitu AND
                     L.usuario = D.u_autorizaD AND
                     A.p_respuestas=1234567890 AND
                     C.cve_estatus <> 3 AND
                     C.archivado NOT IN (1,2) AND
                     CONVERT(datetime, C.fecha_registro, 112) >= @p_f_registro1 AND
                     CONVERT(datetime, C.fecha_registro, 112) <= @p_f_registro2
                )           
        
    CREATE NONCLUSTERED INDEX #IDX_EXP_100PCT  ON #TMP_EXP_100PCT (anio, folioEnlace)    
    
    IF ( @p_tipo_con = 1)
    BEGIN
        SELECT r1.folioEnlace, r1.anio, 'fechaRespuesta'=MAX(r1.fechaRespuesta), 'n_respuestas'=COUNT(*)
            INTO #TMP_EXP_RESP_NO_NEG
                FROM det_cge_respuestas r1, ctr_cge_respuestas_origen r2
                    WHERE
                    (
                        r2.anio = r1.anio AND r2.folioEnlace = r1.folioEnlace
                        AND r2.id_moral = r1.id_moral AND r2.sector_finan = r1.sector_finan
                        AND r2.noOficio = r1.noOficio AND r2.consecutivo = r1.consecutivo                        
                        AND r2.id_tipo_informacion IN (-1,-2,-0)
                        AND CONVERT(datetime, r1.fechaRespuesta, 112) >=  @p_f_registro1
                    )
        GROUP BY r1.folioEnlace, r1.anio
        
        SELECT A.*
            INTO #TMP_EXP_100PCT_NEG
                FROM #TMP_EXP_100PCT A (INDEX #IDX_EXP_100PCT)
                    WHERE
                        NOT EXISTS
                        (
                            SELECT 1 FROM #TMP_EXP_RESP_NO_NEG P 
                                WHERE P.folioEnlace = A.folioEnlace AND P.anio = A.anio
                        )
                        
        CREATE NONCLUSTERED INDEX #IDX_EXP_100PCT_NEG ON #TMP_EXP_100PCT_NEG (anio, folioEnlace)
        
        SELECT A.*, 'fechaRespuesta' = MAX(B.fechaRespuesta)
            INTO #TMP_EXP_100PCT_NEG_1
                FROM #TMP_EXP_100PCT_NEG A, det_cge_respuestas B
                    WHERE  B.anio = A.anio AND B.folioEnlace = A.folioEnlace
        GROUP BY A.folioEnlace, B.anio
        
        SELECT *
            INTO #IDX_EXP_100PCT_NEG_FIN        
                FROM #TMP_EXP_100PCT_NEG_1 A                
                    WHERE             
                        CONVERT(datetime, A.fechaRespuesta, 112) >= @p_f_rsp_cierre1
                        AND CONVERT(datetime, A.fechaRespuesta, 112) <= @p_f_rsp_cierre2
    
        
        CREATE NONCLUSTERED INDEX #IDX_EXP_100PCT_NEG_FIN ON #TMP_EXP_100PCT_NEG (anio, folioEnlace)        
        
        SELECT * FROM #TMP_EXP_100PCT_NEG_FINAL

        RETURN       
                
        IF (ISNULL(@p_filtro, "") <> "")    
            SELECT @sql = 'SELECT * FROM #TMP_EXP_100PCT_NEG_FINAL (INDEX #IDX_EXP_100PCT_NEG_FIN) WHERE (' + @p_filtro + ')'
        ELSE    
            SELECT @sql = 'SELECT * FROM #TMP_EXP_100PCT_NEG_FINAL (INDEX #IDX_EXP_100PCT_NEG_FIN)'
        
        EXECUTE (@sql)
    
        DROP TABLE #TMP_EXP_100PCT_NEG
        DROP TABLE #TMP_EXP_RESP_NO_NEG        
    END
    
    IF ( @p_tipo_con = 0)    
    BEGIN
        SELECT r1.folioEnlace, r1.anio, 'fechaRespuesta'=MAX(r1.fechaRespuesta), 'n_respuestas'=COUNT(*)
            INTO #TMP_EXP_RESP_100
            FROM det_cge_respuestas r1, ctr_cge_respuestas_origen r2
                WHERE
                (
                        r2.anio = r1.anio AND r2.folioEnlace = r1.folioEnlace
                    AND r2.id_moral = r1.id_moral AND r2.sector_finan = r1.sector_finan
                    AND r2.noOficio = r1.noOficio AND r2.consecutivo = r1.consecutivo                    
                    AND r2.id_tipo_informacion IN (1,2)
                    AND CONVERT(datetime, r1.fechaRespuesta, 112) >=  @p_f_registro1
                )
        GROUP BY r1.folioEnlace, r1.anio    
        
        SELECT A.*, P.fechaRespuesta
            INTO #TMP_EXP_100PCT_POSNEG
                FROM #TMP_EXP_100PCT A (INDEX #IDX_EXP_100PCT), #TMP_EXP_RESP_100 P 
                    WHERE P.folioEnlace = A.folioEnlace AND P.anio = A.anio
                        AND CONVERT(datetime, P.fechaRespuesta, 112) >= @p_f_rsp_cierre1
                        AND CONVERT(datetime, P.fechaRespuesta, 112) <= @p_f_rsp_cierre2
               
        
        CREATE NONCLUSTERED INDEX #IDX_EXP_100PCT_POSNEG ON #TMP_EXP_100PCT_POSNEG (anio, folioEnlace)     

        IF (ISNULL(@p_filtro, "") <> "")    
            SELECT @sql = 'SELECT * FROM #TMP_EXP_100PCT_POSNEG (INDEX #IDX_EXP_100PCT_POSNEG) WHERE (' + @p_filtro + ')'
        ELSE    
            SELECT @sql = 'SELECT * FROM #TMP_EXP_100PCT_POSNEG (INDEX #IDX_EXP_100PCT_POSNEG)'
        
        EXECUTE (@sql)
        
        DROP TABLE #TMP_EXP_100PCT_POSNEG
        DROP TABLE #TMP_EXP_RESP_100
        
    END         
    
    DROP INDEX #TMP_EXP_100PCT.#IDX_EXP_100PCT
    DROP TABLE #TMP_EXP_100PCT
    
    IF (@@error <> 0) 
    BEGIN
        RAISERROR @@error    
        RETURN -1
    END

END
go

