	
-- 1. COMDATA: agregar tramo final

drop table #tab7
select a.*, SUBSTRING(Tramo_LocalTime,1,5) as Tramo_LocalTime_F
into #tab7
from gdc..mails_comdata as a



drop table #tab_comdata_recibidos
select Periodo, Campana, Cola as Triada, count(distinct MediaID) as Q_Mails_Recibidas
into #tab_comdata_recibidos
from #tab7
--where Tramo_LocalTime_F in ('08:00', '08:30', '09:00', '09:30', '10:00', '10:30', 
--					  '11:00', '11:30', '12:00','12:30' ,'13:00', '13:30', 
--					  '14:00', '14:30', '15:00', '15:30', '16:00', '16:30', 
--					  '17:00', '17:30', '18:00', '18:30', '19:00', '19:30')
group by Periodo, Campana, Cola



drop table #tab_comdata_gestionados
select Periodo, Campana, Cola as Triada, count(distinct MediaID) as Q_Mails_Gestionados
into #tab_comdata_gestionados
from #tab7
where AgentID is not null
--and Tramo_LocalTime_F in ('08:00', '08:30', '09:00', '09:30', '10:00', '10:30', 
--					  '11:00', '11:30', '12:00','12:30' ,'13:00', '13:30', 
--					  '14:00', '14:30', '15:00', '15:30', '16:00', '16:30', 
--					  '17:00', '17:30', '18:00', '18:30', '19:00', '19:30')
group by Periodo, Campana, Cola




--select * from #tab_comdata_gestionados
--select AgentID, SLA_CLIENTE_TOTAL_24H from #tab7 where AgentID is null





drop table #tab_comdata_gestionados_u
select Periodo, Campana, Cola as Triada, sum(SLA_INT_TOTAL_24H) as Q_Mails_Gestionados_U
into #tab_comdata_gestionados_u
from #tab7
-- where AgentID is not null
-- and SLA_CLIENTE_TOTAL_24H <> 0
--and Tramo_LocalTime_F in ('08:00', '08:30', '09:00', '09:30', '10:00', '10:30', 
--					  '11:00', '11:30', '12:00','12:30' ,'13:00', '13:30', 
--					  '14:00', '14:30', '15:00', '15:30', '16:00', '16:30', 
--					  '17:00', '17:30', '18:00', '18:30', '19:00', '19:30')
group by Periodo, Campana, Cola



drop table #tab_comdata_q_sla
select Periodo, Campana, Cola as Triada, SUM(cast(Q_SLA as bigint)) as Q_SLA
into #tab_comdata_q_sla
from #tab7
--where Tramo_LocalTime_F in ('08:00', '08:30', '09:00', '09:30', '10:00', '10:30', 
--					  '11:00', '11:30', '12:00','12:30' ,'13:00', '13:30', 
--					  '14:00', '14:30', '15:00', '15:30', '16:00', '16:30', 
--					  '17:00', '17:30', '18:00', '18:30', '19:00', '19:30')
group by Periodo, Campana, Cola



		--select top 1 * from #tab_comdata_recibidos

		--select top 1 * from #tab_comdata_gestionados

		--select top 1 * from #tab_comdata_gestionados_u

		--select top 1 * from #tab_comdata_q_sla


drop table #tab_comdata_final
select a.*, b.Q_Mails_Gestionados, d.Q_Mails_Gestionados_U, f.Q_SLA
into #tab_comdata_final
from #tab_comdata_recibidos as a
left join #tab_comdata_gestionados as b on a.Periodo = b.Periodo and a.Campana = b.Campana and a.Triada = b.Triada
left join #tab_comdata_gestionados_u as d on a.Periodo = d.Periodo and a.Campana = d.Campana and a.Triada = d.Triada
left join #tab_comdata_q_sla as f on a.Periodo = f.Periodo and a.Campana = f.Campana and a.Triada = f.Triada


		select * from #tab_comdata_final


-- COMDATA: agregar Proveedor

alter table #tab_comdata_final
add Proveedor varchar(10)

update #tab_comdata_final
set Proveedor = 'COMDATA'
where Proveedor is null


-- NECOMPLUS:


-- 1. crear copia de tabla

drop table #ncp_inicial
select * 
into #ncp_inicial
from gdc..ncp_mails 
where cast(Verify as varchar)='Valido'
and cast([Verify reab] as varchar)='Valido'

-- select distinct cast(Segmento as varchar) from #ncp_inicial where Periodo = 202206

alter table #ncp_inicial
add Triada varchar(50)


drop table #tab_ncp_recibidos
select cast(periodo as varchar) as Periodo, cast(segmento as varchar) as Programa, Triada, count(*) as Q_Mails_Recibidos 
into #tab_ncp_recibidos
from #ncp_inicial
where cast([tipo rpta]as varchar) = 'Entrante' 
group by cast(periodo as varchar), cast(segmento as varchar), Triada


drop table #tab_ncp_gestionados
select cast(periodo as varchar)as Periodo, cast(segmento as varchar) as Programa, Triada, count(*) as Q_Mails_Gestionados 
into #tab_ncp_gestionados
from #ncp_inicial
where cast([tipo rpta]as varchar)<>'Entrante' 
group by cast(periodo as varchar) ,cast(segmento as varchar), Triada


		--select top 1 * from #tab_ncp_recibidos
		--select top 1 * from #tab_ncp_gestionados


drop table #tab_ncp_gestionados_U
select cast(periodo as varchar)as Periodo, cast(segmento as varchar) as Programa, Triada, count(*) as Q_Mails_Gestionados_U
into #tab_ncp_gestionados_U
from #ncp_inicial
where cast([tipo rpta]as varchar)<>'Entrante' 
and [SLA bin %] = 1
group by cast(periodo as varchar) ,cast(segmento as varchar), Triada


		
		--select top 1 * from #tab_ncp_recibidos
		--select top 1 * from #tab_ncp_gestionados
		--select top 1 * from #tab_ncp_gestionados_U



drop table #tab_ncp_final
select a.*, b.Q_Mails_Gestionados, d.Q_Mails_Gestionados_U
into #tab_ncp_final
from #tab_ncp_recibidos as a
left join #tab_ncp_gestionados as b on a.Periodo = b.Periodo and a.Programa = b.Programa
left join #tab_ncp_gestionados_U as d on a.Periodo = d.Periodo and a.Programa = d.Programa



alter table #tab_ncp_final
add Q_SLA varchar (30)

update #tab_ncp_final
set Q_SLA = Q_Mails_Gestionados

alter table #tab_ncp_final
add Proveedor varchar (30)

update #tab_ncp_final
set Proveedor = 'NECOMPLUS'
where Proveedor is null


update #tab_ncp_final
set Triada = '-'
where Triada is null



-- crear tabla final

--select top 5 * from #tab_ncp_final
--select top 5 * from #tab_comdata_final


drop table gdc..tbl_CONSOLIDADO_MAILS_UNIFICADO
select *
into gdc..tbl_CONSOLIDADO_MAILS_UNIFICADO
from
(
select * from #tab_ncp_final

union all

select * from #tab_comdata_final
) as subquery


	--select *
	--from gdc..tbl_CONSOLIDADO_MAILS_UNIFICADO
	--where periodo = 202206

	