-- =================================================================================================
----------------------------------------------------------------------------------------------------
-- Date          Author     Comment
-- ------------- -------    ---------------------------------------------------------------------------
-- 2010-11-24    ArBR       arcebrito@gmail.com
-- =================================================================================================
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL 1

DECLARE @anio int, @dateMin datetime, @dateMax datetime

SELECT @dateMin = min(fecha) FROM db_e00001..ori_cge_indicadores_per
SELECT @dateMax = max(fecha) FROM db_e00001..ori_cge_indicadores_per
SELECT @anio = datepart(year, @dateMin)

while (@anio <= year(@dateMax))
BEGIN 
       
    -- area_H
    SELECT t2.id_institucion, t2.id_sector,
        8 as id_calculo,             
        substring(convert(char(8), fecha, 112), 1, 6) as periodo_calculo,
        t.fecha as fecha_proceso, calificacion_H as valor, 
        1 as id_area
    INTO #T1 FROM db_e00001..ori_cge_indicadores_per t, db_e00001..cat_cge_personas_morales t2  
     WHERE t.id_moral = t2.id_moral and t.sector_finan = t2.sector_finan and year(fecha) = @anio
    
    -- area_J
    SELECT t2.id_institucion, t2.id_sector,
        8 as id_calculo, 
        substring(convert(char(8), fecha, 112), 1, 6) as periodo_calculo,
            t.fecha as fecha_proceso, calificacion_J as valor, 
        2 as id_area
    INTO #T2 FROM db_e00001..ori_cge_indicadores_per t, db_e00001..cat_cge_personas_morales t2  
     WHERE t.id_moral = t2.id_moral and t.sector_finan = t2.sector_finan and year(fecha) = @anio

    -- area_A
    SELECT t2.id_institucion, t2.id_sector,
        8 as id_calculo,         
        substring(convert(char(8), fecha, 112), 1, 6) as periodo_calculo,
            t.fecha as fecha_proceso, calificacion_A as valor, 
        3 as id_area
    INTO #T3 FROM db_e00001..ori_cge_indicadores_per t, db_e00001..cat_cge_personas_morales t2  
     WHERE t.id_moral = t2.id_moral and t.sector_finan = t2.sector_finan and year(fecha) = @anio
    
    -- area_O
    SELECT t2.id_institucion, t2.id_sector,
        8 as id_calculo,
        substring(convert(char(8), fecha, 112), 1, 6) as periodo_calculo, 
            t.fecha as fecha_proceso, calificacion_O as valor, 
        4 as id_area
    INTO #T4 FROM db_e00001..ori_cge_indicadores_per t, db_e00001..cat_cge_personas_morales t2  
     WHERE t.id_moral = t2.id_moral and t.sector_finan = t2.sector_finan and year(fecha) = @anio
    
    -- avg
    SELECT t2.id_institucion, t2.id_sector,
        8 as id_calculo, 
        substring(convert(char(8), fecha, 112), 1, 6) as periodo_calculo,
            t.fecha as fecha_proceso, promedio as valor, 
        0 as id_area
    INTO #T5 FROM db_e00001..ori_cge_indicadores_per t, db_e00001..cat_cge_personas_morales t2  
     WHERE t.id_moral = t2.id_moral and t.sector_finan = t2.sector_finan and year(fecha) = @anio


    -- -----------------------
    -- data-insertion
    -- ----------------------- 
    BEGIN TRANSACTION
    
    INSERT INTO db_a0005..indicador_ori_calculo_periodo
    (id_institucion, id_sector, id_area, id_calculo, periodo_calculo, fecha_proceso, valor)
        select id_institucion, id_sector, id_area, id_calculo, periodo_calculo, fecha_proceso, valor from #T1
    
    INSERT INTO db_a0005..indicador_ori_calculo_periodo
    (id_institucion, id_sector, id_area, id_calculo, periodo_calculo, fecha_proceso, valor)
        select id_institucion, id_sector, id_area, id_calculo, periodo_calculo, fecha_proceso, valor from #T2
    
    INSERT INTO db_a0005..indicador_ori_calculo_periodo
    (id_institucion, id_sector, id_area, id_calculo, periodo_calculo, fecha_proceso, valor)
        select id_institucion, id_sector, id_area, id_calculo, periodo_calculo, fecha_proceso, valor from #T3
    
    INSERT INTO db_a0005..indicador_ori_calculo_periodo
    (id_institucion, id_sector, id_area, id_calculo, periodo_calculo, fecha_proceso, valor)
       select id_institucion, id_sector, id_area, id_calculo, periodo_calculo, fecha_proceso, valor from #T4
    
    INSERT INTO db_a0005..indicador_ori_calculo_periodo
    (id_institucion, id_sector, id_area, id_calculo, periodo_calculo, fecha_proceso, valor)
        select id_institucion, id_sector, id_area, id_calculo, periodo_calculo, fecha_proceso, valor from #T5    
    
    -- exec-transaction
    if (@@ERROR = 0) COMMIT TRANSACTION  else ROLLBACK TRANSACTION     
    
    -- drop temps
    DROP TABLE #T1
    DROP TABLE #T2
    DROP TABLE #T3
    DROP TABLE #T4
    DROP TABLE #T5
    
    SELECT @anio = @anio + 1

END-- WHILE (process)  
