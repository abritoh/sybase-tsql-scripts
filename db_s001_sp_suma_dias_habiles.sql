IF OBJECT_ID('sp_suma_dias_habiles') IS NOT NULL
BEGIN
    DROP PROCEDURE sp_suma_dias_habiles
    IF OBJECT_ID('sp_suma_dias_habiles') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE sp_suma_dias_habiles >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE sp_suma_dias_habiles >>>'
END
go
-- ========================================================================================
-- Date          Author     Comment
-- 2010-01-08    ArBR        Se corrige el SP [sp_suma_dias_inhabiles] para sumar
--                           correctamente los dias habiles a la fecha indicada
-- 2010-01-10    ArBR        Se agrega funcionalidad para restar dias a @fecha_base
-- ========================================================================================
CREATE PROC sp_suma_dias_habiles (@fecha_base datetime, 
                                  @dias_sumar int, 
                                  @fecha_final datetime output)
AS
BEGIN
    DECLARE @dias_habiles int, @incremento int
    
    SELECT @dias_habiles = 0, @incremento = 1, @fecha_final = @fecha_base
    
    IF @dias_sumar < 0 SELECT @incremento = -1
    
    WHILE @dias_habiles <> @dias_sumar
    BEGIN   
        SELECT @fecha_final = DATEADD(dd, @incremento, @fecha_final)
        
        IF DATENAME(WEEKDAY, @fecha_final) IN ('Saturday', 'Sunday') CONTINUE
        
        IF EXISTS(SELECT 1 FROM cat_cgi_dias_inhabiles 
                    WHERE fecha = convert(char(8), @fecha_final, 112)) CONTINUE
        
        SELECT @dias_habiles = @dias_habiles + @incremento       
    END
    
    SELECT @fecha_final
    
END
go

EXEC sp_procxmode 'sp_suma_dias_habiles','unchained'
go

IF OBJECT_ID('sp_suma_dias_habiles') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE sp_suma_dias_habiles >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE sp_suma_dias_habiles >>>'
go
