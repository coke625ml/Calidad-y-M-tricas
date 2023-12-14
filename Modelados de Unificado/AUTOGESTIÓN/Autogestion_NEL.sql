-- crear tabla inicial
declare @ano float
set @ano = 2023

declare @mes float
set @mes = 11


drop table #tab1
select *
into #tab1
from gdc..nel_noviembre
where YEAR(Fecha)=@ano
and MONTH(Fecha)=@mes


-- crear periodo

drop table #tab2
select a.*,
       case when CAST(MONTH(Fecha) as float) <= 9 then cast(YEAR(Fecha) as varchar) + '0' + CAST(MONTH(Fecha) as varchar)
	   else cast(YEAR(FECHA) as varchar) + cast(MONTH(FECHA) as varchar)
	   end as Periodo
into #tab2
from #tab1 as a

-- crear id_sesion

drop table #tab3
select a.*, LEN(hora) as Length_Hora 
into #tab3
from #tab2 as a


drop table #tab4
select a.*,
       case when Length_Hora = 8  then SUBSTRING(hora, 1, 2)
	        when Length_Hora = 11 then SUBSTRING(hora, 1, 2)
			when Length_Hora = 10 then SUBSTRING(hora, 1, 1)
	   end as Hora_1
into #tab4
from #tab3 as a


drop table #tab5
select a.*, len(hora_1) as Length_Hora_1
into #tab5
from #tab4 as a


drop table #tab6
select a.*,
      case when Length_Hora_1 = 1 then '0' + Hora_1
	  else Hora_1
	  end as Hora_2
into #tab6
from #tab5 as a


drop table #tab7
select a.*,
       SUBSTRING(CAST(Fecha as varchar),9,2) as Dia_Final,
	   SUBSTRING(CAST(Fecha as varchar),6,2) as Mes_Final,
	   SUBSTRING(CAST(Fecha as varchar),1,4) as Ano_Final
into #tab7
from #tab6 as a


drop table #tab8
select (usuario + cast(Ano_Final as varchar) + cast(Mes_Final as varchar) + cast(Dia_Final as varchar) + cast(Hora_2 as varchar)) as ID_sesion,
       Modulo, Sub_Modulo, Detalle, Concatenar, Usuario, Tipo_usuario, Periodo, Ano_Final, Mes_Final, Dia_Final, Hora_2 as Hora_Final, Fecha, RUC
into #tab8
from #tab7 as a




-- crear logicas de autogestion



	-- mis ventas

		drop table #tab_mis_ventas
		select *
		into #tab_mis_ventas
		from #tab8
		where Modulo = 'Reportes'
		and Sub_Modulo = 'Mis ventas'
		and Detalle in ('Boton Buscar', 'Buscar')
	

		drop table #tab9
		select ROW_NUMBER () over (partition by id_sesion order by id_sesion desc) orden
			   , a.*
		into #tab9
		from #tab_mis_ventas as a
		order by ID_sesion desc


		delete from #tab9
		where orden > 1


		select * from #tab9


	-- mis depositos

		drop table #tab_mis_depositos
		select *
		into #tab_mis_depositos
		from #tab8
		where Modulo in ('Inicio','Reportes')
		and Sub_Modulo = 'Mis depositos'
		and Detalle = 'Boton Buscar'

		update #tab_mis_depositos
		set Modulo ='Inicio'
		where Modulo='Reportes'

		update #tab_mis_depositos
		set sub_modulo='Reportes'
		where sub_modulo='Mis depositos'


		update #tab_mis_depositos
		set detalle='Mis depositos'
		where detalle='Boton buscar'
	

		drop table #tab10
		select ROW_NUMBER () over (partition by id_sesion order by id_sesion desc) orden
			   , a.*
		into #tab10
		from #tab_mis_depositos as a
		order by ID_sesion desc


		delete from #tab10
		where orden > 1


		select * from #tab10


	-- mis canjes

		
		drop table #tab_mis_canjes
		select *
		into #tab_mis_canjes
		from #tab8
		where Modulo = 'Reportes'
		and Sub_Modulo = 'Mis canjes'
		and Detalle in ('Boton Buscar',  'Buscar')
	

		drop table #tab11
		select ROW_NUMBER () over (partition by id_sesion order by id_sesion desc) orden
			   , a.*
		into #tab11
		from #tab_mis_canjes as a
		order by ID_sesion desc


		delete from #tab11
		where orden > 1


		select * from #tab11

	
	-- Transacciones agente

		drop table #tab_transacciones_agente
		select *
		into #tab_transacciones_agente
		from #tab8
		where Modulo = 'Reportes'
		and Sub_Modulo = 'Transacciones agente'
		and Detalle in ('Boton Buscar',  'Buscar')
	

		drop table #tab12
		select ROW_NUMBER () over (partition by id_sesion order by id_sesion desc) orden
			   , a.*
		into #tab12
		from #tab_transacciones_agente as a
		order by ID_sesion desc


		delete from #tab12
		where orden > 1


		select * from #tab12





	-- solicitudes -> devolucion

		
		select distinct modulo, Sub_Modulo, Detalle
		from #tab8
		order by Modulo, Sub_Modulo, Detalle desc
		
		
		
		drop table #tab_solicitudes_devolucion_1
		select *
		into #tab_solicitudes_devolucion_1
		from #tab8
		where Modulo = 'Solicitudes'
		and Sub_Modulo = 'Devoluciones'
		and Detalle in (
		
		'Devolucion Individual - Enviar devolucion',
		'Devolucion Masiva - Enviar devolucion',
		'Reporte de Devoluciones - Seleccionar fechas',
		'Reporte de Devoluciones - Descargar constancias',
		'Reporte de Devoluciones - Descargar constancia',
		'Reporte de Devoluciones - Descargar constancias - Descargar',
		'Reporte de Devoluciones - Boton descargar reportes'
		
		)
	
		
		drop table #tab13
		select ROW_NUMBER () over (partition by id_sesion, concatenar order by id_sesion desc) orden
			   , a.*
		into #tab13
		from #tab_solicitudes_devolucion_1 as a
		order by ID_sesion, concatenar desc


		--delete from #tab13
		--where orden > 1


		select * from #tab13 order by ID_sesion, orden asc






	-- solicitudes -> devolucion

		
		select distinct modulo, Sub_Modulo, Detalle
		from #tab8
		order by Modulo, Sub_Modulo, Detalle desc
		
		
		
		drop table #tab_solicitudes_devolucion_2
		select *
		into #tab_solicitudes_devolucion_2
		from #tab8
		where Modulo = 'Solicitudes'
		and Sub_Modulo = 'Devoluciones'
		and Detalle in (
		
		'Reporte de Devoluciones - Descargar reporte en Excel',
		'Reporte de Devoluciones - Descargar reporte en TXT'
				
		)
	
		
		drop table #tab14
		select ROW_NUMBER () over (partition by id_sesion, SUBSTRING(Concatenar,1,66) order by id_sesion desc) orden
			   , a.*
		into #tab14
		from #tab_solicitudes_devolucion_2 as a
		order by ID_sesion, concatenar desc


		delete from #tab14
		where orden > 1


		select * from #tab14 order by ID_sesion, orden asc


	
	
	
	
	-- Documentos autorizados -> Documentos autorizados

		
		select distinct modulo, Sub_Modulo, Detalle
		from #tab8
		order by Modulo, Sub_Modulo, Detalle desc
		
		
		
		drop table #tab_documentos_autorizados_dae_1
		select *
		into #tab_documentos_autorizados_dae_1
		from #tab8
		where Modulo = 'Documentos Autorizados'
		and Sub_Modulo = 'Documentos Autorizados'
		and Detalle in (
		
		'Editar correo DAE'
				
		)
	
		
		drop table #tab15
		select ROW_NUMBER () over (partition by id_sesion, concatenar order by id_sesion desc) orden
			   , a.*
		into #tab15
		from #tab_documentos_autorizados_dae_1 as a
		order by ID_sesion, concatenar desc


		--delete from #tab15
		--where orden > 1


		select * from #tab15 order by ID_sesion, orden asc





	-- Documentos autorizados -> Documentos autorizados

		
		select distinct modulo, Sub_Modulo, Detalle
		from #tab8
		order by Modulo, Sub_Modulo, Detalle desc
		
		
		
		drop table #tab_documentos_autorizados_dae_2
		select *
		into #tab_documentos_autorizados_dae_2
		from #tab8
		where Modulo = 'Documentos Autorizados'
		and Sub_Modulo = 'Documentos Autorizados'
		and Detalle in (
		
		'Descargar DAE consolidado PDF',
		'Descargar DAE consolidado XML',
		'Descargar DAE CDR XML',
		'Descargar DAE detalle Excel'
				
		)
	

		
		drop table #tab16
		select ROW_NUMBER () over (partition by id_sesion, SUBSTRING(Concatenar,45,13) order by id_sesion desc) orden
			   , a.*
		into #tab16
		from #tab_documentos_autorizados_dae_2 as a
		order by ID_sesion, concatenar desc


		delete from #tab16
		where orden > 1


		select * from #tab16 order by ID_sesion, orden asc





		-- Documentos autorizados -> Consulta deuda

		
		select distinct modulo, Sub_Modulo, Detalle
		from #tab8
		order by Modulo, Sub_Modulo, Detalle desc
		
		
		
		drop table #tab_documentos_autorizados_dae_3
		select *
		into #tab_documentos_autorizados_dae_3
		from #tab8
		where Modulo = 'Documentos Autorizados'
		and Sub_Modulo = 'Consulta deuda'
	

		
		drop table #tab160
		select ROW_NUMBER () over (partition by id_sesion, SUBSTRING(Concatenar,45,13) order by id_sesion desc) orden
			   , a.*
		into #tab160
		from #tab_documentos_autorizados_dae_3 as a
		order by ID_sesion, concatenar desc


		delete from #tab160
		where orden > 1


		select * from #tab160 order by ID_sesion, orden asc


	-- Devoluciones -> Devolucion

		
		select distinct modulo, Sub_Modulo, Detalle
		from #tab8
		order by Modulo, Sub_Modulo, Detalle desc
		
		
		
		drop table #tab_devoluciones
		select *
		into #tab_devoluciones
		from #tab8
		where Modulo = 'Devoluciones'
		and Sub_Modulo in (
		
		'Devolucion Individual', 
		'Devolucion Masiva'

		)

		and Detalle in (
		
		'Enviar Anulacion'
						
		)
	

		
		drop table #tab17
		select ROW_NUMBER () over (partition by id_sesion, Concatenar order by id_sesion desc) orden
			   , a.*
		into #tab17
		from #tab_devoluciones as a
		order by ID_sesion, concatenar desc


		--delete from #tab17
		--where orden > 1


		select * from #tab17 order by ID_sesion, orden asc






	-- Devoluciones -> Reporte de Devoluciones

		
		select distinct modulo, Sub_Modulo, Detalle
		from #tab8
		order by Modulo, Sub_Modulo, Detalle desc
		
		
		
		drop table #tab_devoluciones_1
		select *
		into #tab_devoluciones_1
		from #tab8
		where Modulo = 'Devoluciones'
		and Sub_Modulo in (
		
		'Reporte de Devoluciones'

		)

		and Detalle in (
		
		'Descargar Constancia'
						
		)
	

		
		drop table #tab18
		select ROW_NUMBER () over (partition by id_sesion, Concatenar order by id_sesion desc) orden
			   , a.*
		into #tab18
		from #tab_devoluciones_1 as a
		order by ID_sesion, concatenar desc


		--delete from #tab18
		--where orden > 1


		select * from #tab18 order by ID_sesion, orden asc






	-- Devoluciones -> Reporte de Devoluciones

		
		select distinct modulo, Sub_Modulo, Detalle
		from #tab8
		order by Modulo, Sub_Modulo, Detalle desc
		
		
		
		drop table #tab_devoluciones_2
		select *
		into #tab_devoluciones_2
		from #tab8
		where Modulo = 'Devoluciones'
		and Sub_Modulo in (
		
		'Reporte de Devoluciones'

		)

		and Detalle in (
		
		'Descargar reporte txt',
		'Descargar reporte excel'
						
		)
	

		
		drop table #tab19
		select ROW_NUMBER () over (partition by id_sesion, SUBSTRING(Concatenar,36,17) order by id_sesion desc) orden
			   , 
			   a.*
		into #tab19
		from #tab_devoluciones_2 as a
		order by ID_sesion, concatenar desc


		delete from #tab19
		where orden > 1


		select * from #tab19 order by ID_sesion, orden asc






	-- Documentos autorizados -> Notas creditos

		
		select distinct modulo, Sub_Modulo, Detalle
		from #tab8
		order by Modulo, Sub_Modulo, Detalle desc
		
		
		
		drop table #tab_documentos_autorizados_notas_2
		select *
		into #tab_documentos_autorizados_notas_2
		from #tab8
		where Modulo = 'Documentos Autorizados'
		and Sub_Modulo = 'Documentos Autorizados'
		and Detalle in (
		
		'Nota de Credito (XML)',
		'Nota de Credito (PDF)',
		'CDR Nota de Credito (XML)',
		'Detalle Nota de Credito (XLS)'
								
		)
	
			
		drop table #tab20
		select  ROW_NUMBER () over (partition by id_sesion, LEFT(RIGHT(Concatenar, 13), 7) order by id_sesion desc) orden
			    , a.*
		into #tab20
		from #tab_documentos_autorizados_notas_2 as a
		order by ID_sesion, concatenar desc


		delete from #tab20
		where orden > 1


		select * from #tab20 order by ID_sesion, orden asc







	-- Documentos autorizados -> Notas creditos 1

		
		select distinct modulo, Sub_Modulo, Detalle
		from #tab8
		order by Modulo, Sub_Modulo, Detalle desc
		
		
		
		drop table #tab_documentos_autorizados_notas_3
		select *
		into #tab_documentos_autorizados_notas_3
		from #tab8
		where Modulo = 'Documentos Autorizados'
		and Sub_Modulo = 'Documentos Autorizados'
		and Detalle in (
		
		'Documento autorizado (XML)',
		'Documento autorizado (PDF)'
										
		)
	
			
		drop table #tab21
		select  ROW_NUMBER () over (partition by id_sesion, SUBSTRING(Concatenar,1,21) order by id_sesion desc) orden
			    , a.*
		into #tab21
		from #tab_documentos_autorizados_notas_3 as a
		order by ID_sesion, concatenar desc


		delete from #tab21
		where orden > 1


		select * from #tab21 order by ID_sesion, orden asc







	-- Documentos autorizados -> Notas creditos 2

		
		select distinct modulo, Sub_Modulo, Detalle
		from #tab8
		order by Modulo, Sub_Modulo, Detalle desc
		
		
		
		drop table #tab_documentos_autorizados_notas_4
		select *
		into #tab_documentos_autorizados_notas_4
		from #tab8
		where Modulo = 'Documentos Autorizados'
		and Sub_Modulo = 'Documentos Autorizados'
		and Detalle in (
		
		'Comprobante de pago (DUA)'
				
		)
	
			
		drop table #tab22
		select  ROW_NUMBER () over (partition by id_sesion, Concatenar order by id_sesion desc) orden
			    , a.*
		into #tab22
		from #tab_documentos_autorizados_notas_4 as a
		order by ID_sesion, concatenar desc


		delete from #tab22
		where orden > 1


		select * from #tab22 order by ID_sesion, orden asc







	-- Documentos autorizados -> Cuenta Bancaria

		
		select distinct modulo, Sub_Modulo, Detalle
		from #tab8
		order by Modulo, Sub_Modulo, Detalle desc
		
		
		
		drop table #tab_documentos_autorizados_notas_5
		select *
		into #tab_documentos_autorizados_notas_5
		from #tab8
		where Modulo = 'Solicitudes'
		and Sub_Modulo = 'Cuenta Bancaria'
		and Detalle in (
		
		'Cambio de cuenta bancaria - Boton enviar'
				
		)
	
			
		drop table #tab23
		select  ROW_NUMBER () over (partition by id_sesion order by id_sesion desc) orden
			    , a.*
		into #tab23
		from #tab_documentos_autorizados_notas_5 as a
		order by ID_sesion, concatenar desc


		--delete from #tab23
		--where orden > 1


		select * from #tab23 order by ID_sesion, orden asc









		
		
		

		

		
		




-- unificación de tablas


drop table #tab24
select *
into #tab24
from
(

select * from #tab9

union all

select * from #tab10

union all

select * from #tab11

union all

select * from #tab12

union all

select * from #tab13

union all

select * from #tab14

union all

select * from #tab15

union all

select * from #tab16

union all

select * from #tab17

union all

select * from #tab18

union all

select * from #tab19

union all

select * from #tab20

union all

select * from #tab21

union all

select * from #tab22

union all

select * from #tab23

union all

select * from #tab160

) as b


-- crear tabla final

insert into gdc..tbl_AUTOGESTION_NEL_final
select *
from #tab24