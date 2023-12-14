


--select *
--from gdc..tbl_consolidado_metricas_experiencia_final


drop table #tab1
select a.* , SUBSTRING(tramo,1,5) as Tramo_Nuevo
into #tab1
from gdc..Llamadas_In_Comdata as a


--select distinct Tramo_Nuevo
--from #tab1
--order by Tramo_Nuevo desc


drop table #tab_call_comdata
select Periodo, unidadnegocio, segmento, clustergrupo,
       Gestion as Atendida_Abandonada, Programa as Pool,LastCampaign as Triada, Aten_20s, count (*) as Q_Recibidas
into #tab_call_comdata
from #tab1
where Tramo_Nuevo in ('08:00', '08:30', '09:00', '09:30', '10:00', '10:30', 
					  '11:00', '11:30', '12:00','12:30' ,'13:00', '13:30', 
					  '14:00', '14:30', '15:00', '15:30', '16:00', '16:30', 
					  '17:00', '17:30', '18:00', '18:30', '19:00', '19:30')
group by Periodo, unidadnegocio, segmento, clustergrupo,
       Gestion, Programa, LastCampaign , Aten_20s


delete from #tab_call_comdata
where pool = 'vendemas'

alter table #tab_call_comdata
add Proveedor varchar(10)

update #tab_call_comdata
set Proveedor = 'COMDATA'
where Proveedor is null

			
			
			--select periodo, sum(Q_Recibidas) as Q_Recibidas
			--into #tab2
			--from #tab_call_comdata
			--group by periodo
			--order by periodo asc

			--select periodo, sum(Q_Recibidas) as Q_Atendidas
			--INTO #tab4
			--from #tab_call_comdata
			--where Atendida_Abadonada = 'Atendidas'
			--group by periodo
			--order by periodo asc

			--select periodo, sum(Q_Recibidas) as Q_Abandonadas
			--from #tab_call_comdata
			--where Atendida_Abadonada = 'Abandonadas'
			--group by periodo
			--order by periodo asc

			--select periodo, sum(Q_Recibidas) as Q_Atendidas_20s
			--into #tab3
			--from #tab_call_comdata
			--where Atendida_Abadonada = 'Atendidas'
			--and Aten_20s = 1
			--group by periodo
			--order by periodo asc

	

			--select * from #tab2
			---- select * from #tab3
			--select * from #tab4

			--select a.Periodo, (cast(a.Q_Atendidas_20s as float)/cast(b.Q_Recibidas as float)) * 100 as NDS
			--from #tab3 as a
			--left join #tab2 as b on a.periodo = b.Periodo

			--select a.Periodo, (cast(a.Q_Atendidas as float)/cast(b.Q_Recibidas as float)) * 100 as NDA
			--from #tab4 as a
			--left join #tab2 as b on a.periodo = b.Periodo


			

			--select top 4 * from #tab_call_comdata
			--select top 4 * from #tab_call_siscard

	


drop table #tab_call_siscard
select Periodo, UN as unidadnegocio, segmento, clustergrupo, Resultado as Atendida_Abandonada, 
	   Resultado as Pool, Resultado as Triada, Umbral as Aten_20s, count (*) as Q_Recibidas
into #tab_call_siscard
from gdc..tbl_llamadas_SISCARD_final as a
group by Periodo, UN, segmento, clustergrupo, Resultado, Resultado, Resultado, Umbral


alter table #tab_call_siscard
add Proveedor varchar(10)

update #tab_call_siscard
set Proveedor = 'SISCARD'
where Proveedor is null

			
update #tab_call_siscard
set Pool = '-'
where Pool is not null

update #tab_call_siscard
set Triada = '-'
where Triada is not null

update #tab_call_siscard
set Atendida_Abandonada = 'Atendidas'
where Atendida_Abandonada = 'Completado'

update #tab_call_siscard
set Atendida_Abandonada = 'Abandonadas'
where Atendida_Abandonada = 'Abandonado'
			

		
		
		-- select top 4 * from gdc..tbl_llamadas_SISCARD_final

	
					--drop table #tab2
					--select periodo, sum(Q_Recibidas) as Q_Recibidas
					--into #tab2
					--from #tab_call_siscard
					--group by periodo
					--order by periodo asc

					--drop table #tab4
					--select periodo, sum(Q_Recibidas) as Q_Atendidas
					--INTO #tab4
					--from #tab_call_siscard
					--where Atendida_Abandonada = 'Atendidas'
					--group by periodo
					--order by periodo asc

					--select periodo, sum(Q_Recibidas) as Q_Abandonadas
					--from #tab_call_siscard
					--where Atendida_Abadonada = 'Abandonadas'
					--group by periodo
					--order by periodo asc

					--drop table #tab3
					--select periodo, sum(Q_Recibidas) as Q_Atendidas_20s
					--into #tab3
					--from #tab_call_siscard
					--where Atendida_Abandonada = 'Atendidas'
					--and Aten_20s = 1
					--group by periodo
					--order by periodo asc

	

					--select * from #tab2
					--select * from #tab3
					--select * from #tab4

					--select a.Periodo, (cast(a.Q_Atendidas_20s as float)/cast(b.Q_Recibidas as float)) * 100 as NDS
					--from #tab3 as a
					--left join #tab2 as b on a.periodo = b.Periodo

					--select a.Periodo, (cast(a.Q_Atendidas as float)/cast(b.Q_Recibidas as float)) * 100 as NDA
					--from #tab4 as a
					--left join #tab2 as b on a.periodo = b.Periodo
			
			

			

drop table #tab_call_necomplus
select Periodo, UN as unidadnegocio, Segmento as segmento, Cluster as clustergrupo, cast(LL_Atendida as varchar) as Atendida_Abandonada,
       Campaña as Pool, Descripción as Triada, LL_AtendidaU as Aten_20s, SUM(LL_recibida) as Q_Recibidas
into #tab_call_necomplus
from gdc..Ncp_llamadas_unif
group by Periodo, UN, Segmento, Cluster, LL_Atendida, Campaña, Descripción, LL_AtendidaU


alter table #tab_call_necomplus
add Proveedor varchar(10)

update #tab_call_necomplus
set Proveedor = 'NECOMPLUS'
where Proveedor is null


update #tab_call_necomplus
set Triada = '-'
where Triada is not null

update #tab_call_necomplus
set Atendida_Abandonada = 'Atendidas'
where Atendida_Abandonada = '1'

update #tab_call_necomplus
set Atendida_Abandonada = 'Abandonadas'
where Atendida_Abandonada = '0'


				

					--drop table #tab2
					--select periodo, sum(Q_Recibidas) as Q_Recibidas
					--into #tab2
					--from #tab_call_necomplus
					--group by periodo
					--order by periodo asc

					--drop table #tab4
					--select periodo, sum(Q_Recibidas) as Q_Atendidas
					--INTO #tab4
					--from #tab_call_necomplus
					--where Atendida_Abandonada = 'Atendidas'
					--group by periodo
					--order by periodo asc

					--select periodo, sum(Q_Recibidas) as Q_Abandonadas
					--from #tab_call_necomplus
					--where Atendida_Abadonada = 'Abandonadas'
					--group by periodo
					--order by periodo asc

					--drop table #tab3
					--select periodo, sum(Q_Recibidas) as Q_Atendidas_20s
					--into #tab3
					--from #tab_call_necomplus
					--where Atendida_Abandonada = 'Atendidas'
					--and Aten_20s = 1
					--group by periodo
					--order by periodo asc

	

					--select * from #tab2
					--select * from #tab3
					--select * from #tab4

					--select a.Periodo, (cast(a.Q_Atendidas_20s as float)/cast(b.Q_Recibidas as float)) * 100 as NDS
					--from #tab3 as a
					--left join #tab2 as b on a.periodo = b.Periodo

					--select a.Periodo, (cast(a.Q_Atendidas as float)/cast(b.Q_Recibidas as float)) * 100 as NDA
					--from #tab4 as a
					--left join #tab2 as b on a.periodo = b.Periodo

select top 4 *
from gdc..tbl_ESTADISTICO_COMDATA_final


drop table #tab_call_vendemas_inicial
select Periodo, Programa as unidadnegocio, Programa as segmento, Programa as clustergrupo,
       Programa as Atendida_Abandonada, Programa as Pool, Programa as Triada, SUM(Transferidas) as Aten_20s,
	   SUM(Recibidas) as Q_Recibidas
into #tab_call_vendemas_inicial
from gdc..tbl_ESTADISTICO_COMDATA_final
where Programa = 'Vendemas'
group by Periodo, Programa, Programa, Programa, Programa, Programa, Programa




update #tab_call_vendemas_inicial
set unidadnegocio = 'Masivo'
where unidadnegocio is not null

update #tab_call_vendemas_inicial
set segmento = 'Masivo'
where segmento is not null

update #tab_call_vendemas_inicial
set clustergrupo = 'Sin Cluster'
where clustergrupo is not null

update #tab_call_vendemas_inicial
set Atendida_Abandonada = '-'
where Atendida_Abandonada is not null

update #tab_call_vendemas_inicial
set Triada = '-'
where Triada is not null

update #tab_call_vendemas_inicial
set Aten_20s = 0
where Aten_20s <> 0


alter table	#tab_call_vendemas_inicial
add Proveedor varchar(10)

update #tab_call_vendemas_inicial
set Proveedor = 'COMDATA'
where Proveedor is null


		select * from #tab_call_vendemas_inicial

drop table #tab_call_vendemas_atendidas_20s
select Periodo, Programa, SUM(Aten_20s) as Aten_20s_1, SUM(Atendidas) as Q_Atendidas_1
into #tab_call_vendemas_atendidas_20s
from gdc..tbl_ESTADISTICO_COMDATA_final
where Programa = 'Vendemas'
group by Periodo, Programa

		select * from #tab_call_vendemas_atendidas_20s

drop table #tab_call_vendemas_final
select a.*, b.Aten_20s_1, b.Q_Atendidas_1
into #tab_call_vendemas_final
from #tab_call_vendemas_inicial as a
left join #tab_call_vendemas_atendidas_20s as b on a.periodo = b.periodo and a.Pool = b.Programa

		select * from #tab_call_vendemas_final

alter table #tab_call_siscard
add Aten_20s_1 int

alter table #tab_call_necomplus
add Aten_20s_1 int

alter table #tab_call_comdata
add Aten_20s_1 int



alter table #tab_call_siscard
add Q_Atendidas_1 int

alter table #tab_call_necomplus
add Q_Atendidas_1 int

alter table #tab_call_comdata
add Q_Atendidas_1 int





select top 4 * from #tab_call_siscard

select top 4 * from #tab_call_necomplus

select top 4 * from #tab_call_comdata

select top 4 * from #tab_call_vendemas_final


-- FINAL : consolidar tablas

	drop table gdc..tbl_CONSOLIDADO_LLAMADAS_UNIFICADO
	select *
	into gdc..tbl_CONSOLIDADO_LLAMADAS_UNIFICADO
	from (

		select * from #tab_call_comdata

		union all

		select * from #tab_call_siscard

		union all

		select * from #tab_call_necomplus

		union all

		select * from #tab_call_vendemas_final

		) as subquery



-- select * from gdc..tbl_CONSOLIDADO_LLAMADAS_UNIFICADO where pool = 'vendemas'