-- 1. base de llamadas in

-- select top 10 * from gdc..tbl_MAILS_COMDATA_inicial

--select month(Fecha_LocalTime) ,count (*) as q from gdc..tbl_MAILS_COMDATA_inicial group by month(Fecha_LocalTime)
--select count (*) as q from gdc..tbl_MAILS_COMDATA_inicial

-- select max(Fecha_LocalTime) from gdc..tbl_MAILS_COMDATA_inicial

-- select YEAR(Fecha_LocalTime), MONTH(Fecha_LocalTime), COUNT (*) AS Q from gdc..tbl_MAILS_COMDATA_inicial GROUP BY YEAR(Fecha_LocalTime), MONTH(Fecha_LocalTime)

-- select Flag_Proceso, count(*) as q from gdc..tbl_llamadas_COMDATA_inicial group by Flag_Proceso


		--alter table gdc..base_llamadas_enero_marzo
		--add Flag_Proceso varchar (5)

		--update gdc..base_llamadas_enero_marzo
		--set flag_proceso = 'Used'
		--where flag_proceso is null


-- 1.1. Se procesará siempre toda la tabla inicial

use [Visanet Planeamiento]

drop table #tab0
select *
into #tab0
from gdc..tbl_MAILS_COMDATA_inicial
-- where Flag_Proceso = 'New'



-- 1.2. Crear fecha_hora_LocalTime_F


drop table #tab1
select a.*, cast(substring(cast(Fecha_LocalTime as varchar),1,10) + ' ' + Hora_LocalTime as varchar) Fecha_Hora_LocalTime
into #tab1
from #tab0 as a

drop table #tab2
select a.* ,convert(varchar, Fecha_Hora_LocalTime , 121) as Fecha_Hora_LocalTime_F 
into #tab2
from #tab1 as a



-- 1.2. crear columna de Casos_Final para identificar la ultima persona que atendió un caso
		
drop table #tab3
select a.*, 
		ROW_NUMBER() over(partition by Caso_Id order by Fecha_Hora_LocalTime_F desc) as Orden_Casos_Final
into #tab3
from #tab2 as a

			
			-- Validacion: 

				--select CASO_ID, Fecha_LocalTime, Hora_LocalTime, Fecha_Hora_LocalTime_F,Orden_Casos_Final
				--from #tab3
				--order by CASO_ID desc



-- 1.3. crear modificaciones en fechas para no contar domingos
		
		
drop table #tab4
select a.*, 
		a.Fecha_Hora_LocalTime_F as Fecha_Hora_LocalTime_F1,
		DATEDIFF(week,Fecha_Hora_LocalTime_F, getdate()) as DateDiff_Week,
		DATEDIFF(day,Fecha_Hora_LocalTime_F, getdate()) as DateDiff_Day
into #tab4
from #tab3 as a



drop table #tab5
select a.*, 
		(cast(DateDiff_Day as float) - cast(DateDiff_Week as float)) as DateDiff_Day_Mod
into #tab5
from #tab4 as a


		-- Validacion:

			--select Fecha_Hora_LocalTime_F, DateDiff_Week, DateDiff_Day ,DateDiff_Day_Mod
			--from #tab5



-- 1.4. crear columnas de SLA INT. y SLA Cliente con total a 24h


		drop table #tab6
		select a.*,
		       
			   (cast(SLA_Rpta_Interno_3H_2 as int)) as SLA_INT_TOTAL_3H,
			   
			   (cast(SLA_Rpta_Interno_3H_2 as int) + cast(SLA_Rpta_Interno_6H_2 as int)) as SLA_INT_TOTAL_6H,
			   
			   (cast(SLA_Rpta_Interno_3H_2 as int) + cast(SLA_Rpta_Interno_6H_2 as int) +
			   cast(SLA_Rpta_Interno_12H_2 as int)) as SLA_INT_TOTAL_12H,
			   			   
			   (cast(SLA_Rpta_Interno_3H_2 as int) + cast(SLA_Rpta_Interno_6H_2 as int) +
			   cast(SLA_Rpta_Interno_12H_2 as int) + cast(SLA_Rpta_Interno_24H_2 as int)) as SLA_INT_TOTAL_24H,
			   
			   (cast(SLA_Rpta_Cliente_3H as int) + cast(SLA_Rpta_Cliente_6H as int) +
			   cast(SLA_Rpta_Cliente_12H as int) + cast(SLA_Rpta_Cliente_24H as int)) as SLA_CLIENTE_TOTAL_24H

		into #tab6
		from #tab5 as a



-- 1.5. agregar RUCs que se obtienen por el codigo


drop table #tab7
select a.*,
       b.RUC as RUC_C
into #tab7
from #tab6 as a
left join Comercial.BaseComercios as b on a.CODIGO_COMERCIO = b.CODIGO




drop table #tab8
select a.*, cast(RUC as float) as RUC_1
into #tab8
from #tab7 as a



drop table #tab9
select a.*, LEN(RTRIM(LTRIM(RUC))) as RUC_LEN
into #tab9
from #tab8 as a


drop table #tab10
select a.*, 
       case when RUC_1 is null then (isnull(RUC_1,'') + isnull(RUC_C,''))
			
			when RUC_1 = 0 then (isnull(RUC_1,'') + isnull(RUC_C,''))
	   else RUC_1
	   end as RUC_F
into #tab10
from #tab9 as a


-- 1.6. agregar UN, segmento, cluster

drop table #tab11
select a.*, b.unidadnegocio, b.Segmento, b.ClusterGrupo
into #tab11
from #tab10 as a
left join V_Segmento_Cliente as b on a.ruc_f = b.ruc


-- 1.7. agregar gv

drop table #tab12
select a.*, b.Cuadrante_No_Aislado as GrupoValor
into #tab12
from #tab11 as a
left join gdc..tbl_GV as b on a.RUC_F = b.ruc


-- 1.8. cruzar con estado final

drop table #tab13
select a.*, b.Tipificacion as Tipificacion_Final
into #tab13
from #tab12 as a 
left join gdc..tbl_MAILS_ID_COMDATA_final as b on a.CASO_ID = b.caso_id


drop table #tab14
select a.*,
       case when Tipificacion_Final is null then (isnull(Tipificacion,'') + isnull(Tipificacion_Final,''))
	   else Tipificacion_Final
	   end as Tipificacion_Final_1
into #tab14
from #tab13 as a 


-- 1.9. agregar campo periodo

drop table #tab15
select a.*,
       MONTH(Fecha_LocalTime) as Mes,
	   YEAR(Fecha_LocalTime) as Año
into #tab15
from #tab14 as a


drop table #tab16
select a.*,
       case when cast(Mes as float) <= 9 then cast(Año as varchar) + '0' + cast(Mes as varchar)
	   else cast(Año as varchar) + cast(Mes as varchar)
	   end as Periodo
into #tab16
from #tab15 as a




-- 1.9. ingregar en tabla final

drop table gdc..Mails_Comdata
select *
into gdc..Mails_Comdata
from #tab16
