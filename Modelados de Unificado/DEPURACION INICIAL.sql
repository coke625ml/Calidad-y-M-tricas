-- 1. DEPURACION DIARIA CALL SISCARD

		--delete from gdc..tbl_llamadas_SISCARD_inicial
		--where periodo = 202211

		--delete from gdc..tbl_llamadas_SISCARD_final
		--where periodo = 202211

		select count (*)
		from gdc..tbl_llamadas_SISCARD_inicial
		where periodo = 202211
		
		select count (*) 
		from gdc..tbl_llamadas_SISCARD_final
		where periodo = 202211

		
-- 2. DEPURACION DIARIA CP SISCARD
		
			--delete from gdc..tbl_CP_SISCARD_inicial
			--where month(Día) = 10

			--delete from gdc..tbl_CP_SISCARD_final
			--where periodo = 202210
		
						
			select count (*)
			from gdc..tbl_CP_SISCARD_inicial
			where month(Día) = 11

			select count (*) 
			from gdc..tbl_CP_SISCARD_final
			where periodo = 202211


-- 3. DEPURACION DIARIA ESTADISTICO COMDATA

		--delete from gdc..tbl_ESTADISTICO_COMDATA_inicial
		--where month(Fecha) = 11

		--delete from gdc..tbl_ESTADISTICO_COMDATA_final
		--where periodo = 202211
		

		select max(Fecha)
		from gdc..tbl_ESTADISTICO_COMDATA_inicial
		where month(Fecha) = 4
		and year(Fecha)=2023
		
		select count (*)
		from gdc..tbl_ESTADISTICO_COMDATA_inicial
		where month(Fecha) = 4
		and YEAR(fecha)=2023

		select count (*)
		from gdc..tbl_ESTADISTICO_COMDATA_final
		where periodo = 202304

		

-- 4. DEPURACION DIARIA LLAMADAS COMDATA

		--delete from gdc..tbl_llamadas_COMDATA_inicial
		--where month(Fecha) = 11

		--delete from gdc..Llamadas_In_Comdata
		--where periodo = 202211
		
		
		select max(Fecha)
		from gdc..tbl_llamadas_COMDATA_inicial
		where month(Fecha) = 3
		and YEAR(fecha)=2023

		select count (*)
		from gdc..tbl_llamadas_COMDATA_inicial
		where month(Fecha) = 3
		and YEAR(fecha)=2023

		select count (*)
		from gdc..Llamadas_In_Comdata
		where periodo = 202303


-- 5. DEPURACION DIARIA CP COMDATA


		--delete from gdc..tbl_CP_COMDATA_inicial
		--where month(Fecha) = 11

		--delete from gdc..tbl_CP_COMDATA_final
		--where periodo = 202211
			
			select max(Fecha)
			from gdc..tbl_CP_COMDATA_inicial
			where month(Fecha) =3
			and year(fecha)=2023
		
			select count (*)
			from gdc..tbl_CP_COMDATA_inicial
			where month(Fecha) = 3
			and YEAR(fecha)=2023

			select count (*)
			from gdc..tbl_CP_COMDATA_final
			where periodo = 202303

			

-- VALIDACION DE MAIL COMDATA
		
			select max(Fecha_LocalTime)
			from gdc..tbl_MAILS_COMDATA_inicial
			where month(Fecha_LocalTime) = 1
			and year(fecha_localtime)=2023
		
			select count (*)
			from gdc..tbl_MAILS_COMDATA_inicial
			where month(Fecha_LocalTime) = 1
			and year(fecha_localtime)=2023

			select count (*)
			from gdc..Mails_Comdata
			where periodo = 202301



-- 7. Depuracion de tabla consolidado de encuestas digitales


		--delete from gdc..tbl_CONSOLIDADO_DIGITALES_CP_inicial
		--where periodo = 202208

		--delete from gdc..tbl_CONSOLIDADO_DIGITALES_CP_final
		--where periodo = 202208
		
		select count (*) as q
		from gdc..tbl_CONSOLIDADO_DIGITALES_CP_inicial
		where periodo = 202212

		select count (*) as q
		from gdc..tbl_CONSOLIDADO_DIGITALES_CP_final
		where periodo = 202212



-- 8. Depuracion de encuestas vendemas

		--delete from gdc..tbl_vendemas_CP_inicial
		--where MONTH(fecha) = 8

		--delete from gdc..tbl_vendemas_CP_final
		--where MONTH(fecha) = 8


		--select count (*) as q
		--from gdc..tbl_vendemas_CP_inicial
		--where MONTH(fecha) = 8

		--select count (*) as q
		--from gdc..tbl_vendemas_CP_final
		--where MONTH(fecha) = 8



-- 9. Depuracion de encuestas wsp

		--delete from gdc..tbl_whatsapp_CP_inicial
		--where MONTH(fecha) = 8

		--delete from gdc..tbl_whatsapp_CP_final
		--where MONTH(fecha) = 8


		--select count (*) as q
		--from gdc..tbl_whatsapp_CP_inicial
		--where MONTH(fecha) = 8

		--select count (*) as q
		--from gdc..tbl_whatsapp_CP_final
		--where MONTH(fecha) = 8

		
-- 10. Depuracion de base de detractores

		--delete from gdc..tbl_GESTION_DETRACTORES_final
		--where periodo = 202208


		select count (*) as q
		from gdc..tbl_GESTION_DETRACTORES_final
		where periodo = 202212


-- 11. Depuracion de tabla final de resultados CP


		--delete from gdc..tbl_MET_EXP_final
		--where periodo = 202208

		
		select count (*) as q
		from gdc..tbl_MET_EXP_final
		where periodo = 202212
		
		select * 
		from gdc..tbl_MET_EXP_final
		where Periodo = (select max(periodo) from gdc..tbl_MET_EXP_final)


-- 12. Depuracion x-sell : corporativo

		--delete from  gdc..tbl_xsell_corporativo_final
		--where periodo = 202208

		--delete from  gdc..tbl_xsell_corporativo_final_pbi
		--where periodo = 202208

		select count (*) as q
		from gdc..tbl_xsell_corporativo_final
		where periodo = 202212

		select count (*) as q
		from  gdc..tbl_xsell_corporativo_final_pbi
		where periodo = 202212


-- 13. Depuracion x-sell : RYS

		--delete from  gdc..tbl_xsell_rys_final
		--where periodo = 202208

		--delete from  gdc..tbl_xsell_rys_final_pbi
		--where periodo = 202208

		select count (*) as q
		from gdc..tbl_xsell_rys_final
		where periodo = 202212

		select count (*) as q
		from  gdc..tbl_xsell_rys_final_pbi
		where periodo = 202212


-- 14. Depuracion x-sell : préstamos

		--delete from  gdc..tbl_xsell_prestamos_final
		--where periodo = 202208

		--delete from  gdc..tbl_xsell_prestamos_final_pbi
		--where periodo = 202208

		select count (*) as q
		from gdc..tbl_xsell_prestamos_final
		where periodo = 202212

		select count (*) as q
		from  gdc..tbl_xsell_prestamos_final_pbi
		where periodo = 202212


-- 15. Depuracion reitero niubiz : gdc..tbl_reitero_niubiz_pbi

		--delete from gdc..tbl_reitero_niubiz_pbi
		--where periodo = 202208

		select count (*) as q
		from gdc..tbl_reitero_niubiz_pbi
		where periodo = 202212


-- 16. Depuracion reitero vendemas: gdc..tbl_reitero_niubiz_pbi

		--delete from gdc..tbl_reitero_vendemas_pbi
		--where periodo = 202208

		select count (*) as q
		from gdc..tbl_reitero_vendemas_pbi
		where periodo = 202212

		
-- 17. Depuracion de afiliaciones


select top 1 *
from gdc..tbl_afiliaciones_niubiz_inicial

select top 1 *
from gdc..tbl_afiliaciones_niubiz_final