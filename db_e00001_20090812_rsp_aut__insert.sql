-- =========================================================================================================
-- SCRIPT
-- Date          Author     		Comment
-- 2009-08-12    ArBR -> (IDEX8033)    Fecha de creacion. Cambio de version de plantillas por 
--                          		cambio en reglamento interno de la CNBV con fecha 12 Agosto de 2009
-- =========================================================================================================

-- **************************
-- TABLE: rpt_ori_plantillas
-- **************************

-- respuestas a la autoridad
INSERT INTO dbo.rpt_ori_plantillas 
( id_plantilla, cve_area, id_tipo_plantilla, id_status_plantilla, id_usuario, f_registro, extension, nombre_archivo ) 
		 VALUES ( 23, '1', 1, 1, 'IDEX8033', '20090812', 'dot', 'HA_RAHNTPCA.dot' ) 
INSERT INTO dbo.rpt_ori_plantillas 
( id_plantilla, cve_area, id_tipo_plantilla, id_status_plantilla, id_usuario, f_registro, extension, nombre_archivo ) 
		 VALUES ( 24, '1', 2, 1, 'IDEX8033', '20090812', 'dot', 'HA_RAHNTPSA.dot' ) 
INSERT INTO dbo.rpt_ori_plantillas 
( id_plantilla, cve_area, id_tipo_plantilla, id_status_plantilla, id_usuario, f_registro, extension, nombre_archivo ) 
		 VALUES ( 25, '1', 3, 1, 'IDEX8033', '20090812', 'dot', 'HA_RAHNTNCA.dot' ) 
. . .
. . .
. . .
go


-- bitacora
INSERT INTO dbo.rpt_ori_plantillas ( id_plantilla, cve_area, id_tipo_plantilla, id_status_plantilla, id_usuario, f_registro, extension, nombre_archivo ) 
		 VALUES ( 36, '3', 14, 1, 'IDEX8033', '20090812', 'repx', 'SANCION_BITACORA.repx' ) 
. . .
. . .
. . .		 
go

-- memorandum de sancion
INSERT INTO dbo.rpt_ori_plantillas ( id_plantilla, cve_area, id_tipo_plantilla, id_status_plantilla, id_usuario, f_registro, extension, nombre_archivo, sector_finan ) 
		 VALUES ( 37, '1', 15, 1, 'IDEX8033', '20090812', 'repx', 'HA_MEMO_SANCION_B.repx', '03' ) 
INSERT INTO dbo.rpt_ori_plantillas ( id_plantilla, cve_area, id_tipo_plantilla, id_status_plantilla, id_usuario, f_registro, extension, nombre_archivo, sector_finan ) 
		 VALUES ( 38, '1', 16, 1, 'IDEX8033', '20090812', 'repx', 'HA_MEMO_SANCION_C.repx', '18' ) 
INSERT INTO dbo.rpt_ori_plantillas ( id_plantilla, cve_area, id_tipo_plantilla, id_status_plantilla, id_usuario, f_registro, extension, nombre_archivo, sector_finan ) 
		 VALUES ( 39, '2', 15, 1, 'IDEX8033', '20090812', 'repx', 'JU_MEMO_SANCION_B.repx', '03' ) 
INSERT INTO dbo.rpt_ori_plantillas ( id_plantilla, cve_area, id_tipo_plantilla, id_status_plantilla, id_usuario, f_registro, extension, nombre_archivo, sector_finan ) 
		 VALUES ( 40, '2', 16, 1, 'IDEX8033', '20090812', 'repx', 'JU_MEMO_SANCION_C.repx', '18' ) 	 
. . .
. . .
. . .
go

-- recordatorio
INSERT INTO dbo.rpt_ori_plantillas ( id_plantilla, cve_area, id_tipo_plantilla, id_status_plantilla, id_usuario, f_registro, extension, nombre_archivo, sector_finan ) 
		 VALUES ( 41, '1', 17, 1, 'IDEX8033', '20090812', 'repx', 'HA_RECORDATORIO_B.repx', '03' ) 
INSERT INTO dbo.rpt_ori_plantillas ( id_plantilla, cve_area, id_tipo_plantilla, id_status_plantilla, id_usuario, f_registro, extension, nombre_archivo, sector_finan ) 
		 VALUES ( 42, '1', 18, 1, 'IDEX8033', '20090812', 'repx', 'HA_RECORDATORIO_C.repx', '18' ) 
INSERT INTO dbo.rpt_ori_plantillas ( id_plantilla, cve_area, id_tipo_plantilla, id_status_plantilla, id_usuario, f_registro, extension, nombre_archivo, sector_finan ) 
		 VALUES ( 43, '2', 17, 1, 'IDEX8033', '20090812', 'repx', 'JU_RECORDATORIO_B.repx', '03' ) 
INSERT INTO dbo.rpt_ori_plantillas ( id_plantilla, cve_area, id_tipo_plantilla, id_status_plantilla, id_usuario, f_registro, extension, nombre_archivo, sector_finan ) 
		 VALUES ( 44, '2', 18, 1, 'IDEX8033', '20090812', 'repx', 'JU_RECORDATORIO_C.repx', '18' ) 	 
. . .
. . .
. . .		 
go


