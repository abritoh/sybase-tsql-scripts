-- =================================================================================================
-- Date          Author  Comment
-- ------------- ------- ---------------------------------------------------------------------------
-- 2009-11-04    ArBR    ....... 
-- =================================================================================================


DECLARE @fecha datetime
DECLARE @calificacion_H REAL, @calificacion_J REAL, @calificacion_A REAL

SELECT @fecha = CONVERT(CHAR(10), GETDATE(), 112)

SELECT @calificacion_H = AVG(i.calificacion) 
    FROM db_e000001..ori_cge_indicadores i 
        WHERE i.cve_area = '1' AND i.fecha = @fecha

SELECT @calificacion_J = AVG(i.calificacion) 
   FROM db_e000001..ori_cge_indicadores i 
        WHERE i.cve_area = '2' AND i.fecha = @fecha

SELECT @calificacion_A = AVG(i.calificacion) 
   FROM db_i000002..ori_cge_indicadores i 
        WHERE i.cve_area = '1' AND i.fecha = @fecha

SELECT @fecha
SELECT @calificacion_H
SELECT @calificacion_J
SELECT @calificacion_A

SELECT CONVERT(INT, i.id_moral + i.sector_finan) id_moral_int,
       i.id_moral, i.sector_finan, 'H' AS area, i.calificacion 
   INTO #tmp_califica_institu 
        FROM db_e000001..ori_cge_indicadores i 
            WHERE i.fecha = @fecha AND i.cve_area = '1'

INSERT INTO #tmp_califica_institu 
   SELECT CONVERT(INT, i.id_moral + i.sector_finan) id_moral_int,
      i.id_moral, i.sector_finan, 'J' AS area, i.calificacion 
      FROM db_e000001..ori_cge_indicadores i 
         WHERE i.fecha = @fecha AND i.cve_area = '2'

INSERT INTO #tmp_califica_institu 
   SELECT CONVERT(INT, i.id_moral + i.sector_finan) id_moral_int,
      i.id_moral, i.sector_finan, 'A' AS area, i.calificacion 
      FROM db_i000002..ori_cge_indicadores i 
        WHERE i.fecha = @fecha AND i.cve_area = '1'      

DECLARE @fecha datetime  
SELECT @fecha = CONVERT(CHAR(10), GETDATE(), 112)

INSERT 
    INTO db_e000001..ori_cge_indicadores_per
    SELECT i.id_moral,
          i.sector_finan,
          CONVERT(CHAR(10), @fecha, 112),
          DATEPART(YEAR, @fecha),
          DATEPART(MONTH, @fecha),
          NULL,
          NULL,
          NULL,
          NULL,
          AVG(i.calificacion) 
      FROM #tmp_califica_institu i 
        GROUP BY i.id_moral, i.sector_finan

DECLARE @fecha datetime  
SELECT @fecha = CONVERT(CHAR(10), GETDATE(), 112)

--
DECLARE @var INT, @id_moral CHAR(6), @sector_finan CHAR(2)
SELECT @var = MIN(id_moral_int) FROM #tmp_califica_institu i
SELECT @var

WHILE @var IS NOT NULL 
   BEGIN
        SELECT @id_moral = id_moral, @sector_finan = sector_finan 
             FROM #tmp_califica_institu 
                WHERE id_moral_int = @var 
         
        UPDATE db_e000001..ori_cge_indicadores_per 
             SET calificacion_H = 
                (
                    SELECT calificacion 
                        FROM #tmp_califica_institu 
                        WHERE id_moral_int = @var AND area = 'H'
                )
            WHERE id_moral = @id_moral AND sector_finan = @sector_finan AND fecha = @fecha         
        
        UPDATE db_e000001..ori_cge_indicadores_per 
            SET calificacion_J = 
            (
                SELECT calificacion 
                    FROM #tmp_califica_institu 
                    WHERE id_moral_int = @var AND area = 'J'
            )             
            WHERE id_moral = @id_moral AND sector_finan = @sector_finan AND fecha =@fecha 
        
        UPDATE db_e000001..ori_cge_indicadores_per 
            SET calificacion_A = 
            (
                SELECT calificacion 
                    FROM #tmp_califica_institu 
                    WHERE id_moral_int = @var AND area = 'A'
            ) 
            WHERE id_moral = @id_moral AND sector_finan = @sector_finan AND fecha = @fecha 
      
    SELECT @var = MIN(id_moral_int) 
        FROM #tmp_califica_institu 
            WHERE id_moral_int > @var
   END
