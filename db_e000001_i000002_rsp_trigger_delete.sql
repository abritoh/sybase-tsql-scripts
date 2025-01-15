-- =========================================================================================================
-- Date          Author     Comment
-- 2009-08-11    ArBR       arcebrito@gmail.com
-- =========================================================================================================
IF object_id('td_det_cge_respuestas') IS NOT NULL
BEGIN
    DROP TRIGGER td_det_cge_respuestas
    IF object_id('td_det_cge_respuestas') is not null
        print '<<< FAILED DROPPING TRIGGER [td_det_cge_respuestas] >>>'
    ELSE
        print '<<< DROPPED TRIGGER [td_det_cge_respuestas] >>>'
END
go

CREATE trigger td_det_cge_respuestas
       on det_cge_respuestas for DELETE AS
BEGIN
    DELETE ctr_cge_respuestas_origen
        FROM ctr_cge_respuestas_origen t2, deleted t1
        WHERE  t2.folioEnlace = t1.folioEnlace
             and t2.anio = t1.anio
             and t2.sector_finan = t1.sector_finan
             and t2.id_moral = t1.id_moral
             and t2.noOficio = t1.noOficio
             and t2.consecutivo = t1.consecutivo
    
    IF (@@error <> 0)       
        SELECT "Error end trigger delete: " + Convert(char(10),@@error)       
    ELSE    
        SELECT "Ok trigger delete"
END
go


