
-- =================================================================================================
-- Date          Author              Comment
-- ------------- ------- ---------------------------------------------------------------------------
-- 2009-08-20    ArBR               arcebrito@gmail.com 
-- =================================================================================================

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL 0

DECLARE @p_f_rsp_fecha1 datetime,
        @p_f_rsp_fecha2 datetime

SELECT @p_f_rsp_fecha1 = '20080630',
       @p_f_rsp_fecha2 = '20081231'

DECLARE
        @numberRecords int,
        @rowCounter int,
        @__tmp_folioEnlace int,        
        
        @_folioEnlace int,
        @_anio int,
        @_sector_finan char(2),
        @_id_moral char(12),
        @_noOficio varchar(25),
        @_consecutivo int,
        @_fechaRespuesta datetime,
        @_observacion varchar(200),
        
        @_tipo_informacion int,
        @_origen int,
        @_cve_area varchar(5),
        @_noControlInt varchar(25),
        @_id_siti varchar(8)
        
            
CREATE TABLE #TEMP_RESPUESTAS_RG
(
    rowId int IDENTITY UNIQUE,
    folioEnlace int,
    anio int,
    sector_finan char(2),
    id_moral char(12),
    noOficio char(25),
    consecutivo int,  
    fechaRespuesta datetime,
    observaciones varchar(200)
)
    
INSERT INTO #TEMP_RESPUESTAS_RG 
    SELECT             
        r1.folioEnlace,
        r1.anio,
        r1.sector_finan,
        r1.id_moral,
        r1.noOficio,
        r1.consecutivo,
        r1.fechaRespuesta,
        ISNULL(RTRIM(LTRIM(CONVERT(varchar(200), r1.observaciones ))),'') observaciones        
            FROM det_cge_respuestas r1
                WHERE 
                    CONVERT(datetime, r1.fechaRespuesta, 112) >= @p_f_rsp_fecha1 AND
                    CONVERT(datetime, r1.fechaRespuesta, 112) <= @p_f_rsp_fecha2 
                    AND r1.cve_tipo_respuesta <> 3  
                    AND ISNULL(RTRIM(LTRIM(CONVERT(varchar(200), observaciones ))),'') <> ''                    
                    AND NOT EXISTS (
                        SELECT 1 FROM ctr_cge_respuestas_origen o1
                            WHERE
                                o1.folioEnlace=r1.folioEnlace AND
                                o1.anio=r1.anio AND
                                o1.sector_finan=r1.sector_finan AND
                                o1.id_moral=r1.id_moral AND
                                o1.noOficio=r1.noOficio AND
                                o1.consecutivo=r1.consecutivo
                    )

SELECT @numberRecords = @@ROWCOUNT
SELECT @rowCounter = 1

CREATE NONCLUSTERED INDEX #IDX_RESP_RG
    ON #TEMP_RESPUESTAS_RG (folioEnlace, anio, sector_finan, id_moral, noOficio, consecutivo)    


WHILE (@rowCounter <= @numberRecords)
BEGIN

    SELECT @_folioEnlace = t1.folioEnlace, @_anio=t1.anio, @_sector_finan=t1.sector_finan, 
           @_id_moral=t1.id_moral, @_noOficio=t1.noOficio, @_consecutivo=t1.consecutivo, 
           @_fechaRespuesta=t1.fechaRespuesta, @_observacion=t1.observaciones
        FROM #TEMP_RESPUESTAS_RG t1
            WHERE t1.rowId = @rowCounter       
    
    SELECT @_cve_area=d1.cve_area, @_noControlInt=noControlInt
        FROM ori_cge_documentos d1 
            WHERE d1.anio = @_anio AND d1.folioEnlace = @_folioEnlace
    
    SELECT @_id_siti=id_siti
        FROM cat_cge_personas_morales m1
            WHERE m1.id_moral = @_id_moral AND m1.sector_finan = @_sector_finan
        
        SELECT @_tipo_informacion = CASE
          WHEN @_observacion LIKE '%EL BANCO NO CUENTA CON CUENTA%' THEN 2 
          ....
          ....
          ....
          ....
          ....
          ....
          WHEN @_observacion LIKE '%FISICO, NO  SE LOCALIZO CUENTA%' THEN 2 
          . . . 
          WHEN @_observacion LIKE '%SIN INF%' THEN 2 
          . . .
          WHEN @_observacion LIKE '%SITI-NEGATIVO%' THEN 2
          WHEN @_observacion LIKE '%EN EXPEDIENTE SE TIENE LA INFORMACION%'THEN 1
          ....
          ....
          ....
          ....
          ....
          ....
          ....
          ....
          ....
          ....
          ....
          ....
          ....
          ....
          ....
          ....
          ....
          ....          
          WHEN @_observacion LIKE '%SXI EXISTE INF%'THEN 1
     ELSE 0
     END      
    
    SELECT @_origen = CASE                               
                          WHEN @_tipo_informacion = 1 THEN 2
                          WHEN @_tipo_informacion = 2 THEN 1
                          ELSE 0
                      END
    
    IF ( @_tipo_informacion <> 0 AND @_origen <> 0 )
    BEGIN    
        
        SELECT @__tmp_folioEnlace = folioEnlace
            FROM ctr_cge_respuestas_origen (INDEX IDX_CTR_RESP_BASE)
                WHERE folioEnlace=@_folioEnlace AND anio=@_anio AND 
                      sector_finan=@_sector_finan AND id_moral=@_id_moral AND
                      noOficio=@_noOficio AND consecutivo=@_consecutivo            
        
        IF ( ISNULL(@__tmp_folioEnlace, 0) = 0 )
            INSERT INTO ctr_cge_respuestas_origen
                    (
                        folioEnlace, anio, sector_finan, id_moral, noOficio, 
                        consecutivo, id_origen, id_tipo_informacion, f_registro
                    )
                    VALUES
                    (
                        @_folioEnlace, @_anio, @_sector_finan, @_id_moral, 
                        @_noOficio, @_consecutivo, @_origen, @_tipo_informacion, getdate()
                    )
    
    END
    
    SELECT @rowCounter = @rowCounter + 1

END

DROP INDEX #TEMP_RESPUESTAS_RG.#IDX_RESP_RG    
DROP TABLE #TEMP_RESPUESTAS_RG

SELECT "Proceso Terminado: " + CONVERT(char(8), @p_f_rsp_fecha1, 112) + " " 
                             + CONVERT(char(8), @p_f_rsp_fecha2, 112)

IF (@@error <> 0) RAISERROR @@error

