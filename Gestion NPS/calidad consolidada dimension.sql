declare @periodo int
set @periodo = 202312

--Empezando
drop table #tab1
select  * 
into #tab1 
from gdc..tbl_ENCUESTAS_CONSOLIDADAS_final where Periodo=@periodo

update #tab1
set clustergrupo ='Masivo'
where clustergrupo is null

update #tab1
set clustergrupo ='Masivo'
where clustergrupo=''

update #tab1
set clustergrupo ='Masivo'
where clustergrupo='Sin Cluster'


drop table #tab2
select a.*,
       case when FLAG_NPS = 'Promotores' then 1
	   when FLAG_NPS = 'Detractores' then -1
	   when FLAG_NPS='Sin Respuesta' then null
	   else 0
	   end as aea,
	   case when CES in (8,9,10) then 1
	   else 0
	   end as aea2
into #tab2
from #tab1 as a


drop table #tab3
select Periodo,gestion_final_1,clustergrupo,AVG(cast(aea as float)) as nps ,avg(cast(sol as float))as sol,avg(cast(aea2 as float)) as ces,count(aea) as q_encuestas
into #tab3
from #tab2
group by Periodo,Gestion_Final_1,clustergrupo

--select * from #tab3

--Introducción manual

alter table #tab3
add universo float

update #tab3
set universo=7300
where Gestion_Final_1='bo ce'

update #tab3
set universo=7300
where Gestion_Final_1='recurrente'

update #tab3
set universo=48600
where Gestion_Final_1='nel'

update #tab3
set universo=86600
where Gestion_Final_1='dashboard vendemas'


update #tab3
set universo=1079
where Gestion_Final_1='ATENCION POOL_V'

update #tab3
set universo=1113
where Gestion_Final_1='ATENCION SMALL'

update #tab3
set universo =59
where Gestion_Final_1='ATENCION TOP_V'

update #tab3
set universo=744
where Gestion_Final_1='ATENCION TOP'

update #tab3
set universo=425
where Gestion_Final_1='ATENCION MEDIUM CALL'

update #tab3
set universo=1264
where Gestion_Final_1='Pool Online Virtual'

update #tab3
set universo=5701
where Gestion_Final_1='POS Fisico'

update #tab3
set universo=324
where Gestion_Final_1='AFILIACIONES-CALL'

update #tab3
set universo=5
where Gestion_Final_1='C2C CORPORATIVO-CALL'

update #tab3
set universo=0
where Gestion_Final_1='C2C VENDEMAS-CALL'

update #tab3
set universo=0
where Gestion_Final_1='ECOMMERCE VENDEMAS'

update #tab3
set universo=100
where Gestion_Final_1='INTEGRACIONES'



--select * from #tab3
delete from #tab3 where universo is null

-- AGREGAR DIMENSION

drop table #tab4
select *,case when gestion_final_1 in ('recurrente','bo ce','nel','dashboard vendemas') then 'Experiencia de uso'
              when Gestion_Final_1 in ('C2C CORPORATIVO-CALL','C2C VENDEMAS-CALL',
			                           'AFILIACIONES-CALL','ECOMMERCE VENDEMAS','INTEGRACIONES') then 'Propuesta de valor'
		      else 'Postventa'
			  end as Dimension
	into #tab4
	from #tab3

	--select * from #tab4 order by gestion_final_1,clustergrupo

drop table #aux
select distinct Gestion_Final_1,sum(q_encuestas) as qp
into #aux
from #tab4 group by gestion_final_1



--select * from #aux

drop table #tab5
select a.* ,cast(a.q_encuestas as float)/b.qp as prop
into #tab5
from #tab4 as a
left join #aux as b on a.Gestion_Final_1=b.Gestion_Final_1


drop table #tab6
select periodo,gestion_final_1,clustergrupo,Dimension,nps,sol,ces,universo*prop as universo_par
into #tab6
from #tab5
order by gestion_final_1,clustergrupo

--select * from #tab6

drop table #aux2
select distinct Dimension ,SUM(universo_par) as universo
into #aux2
from #tab6
group by Dimension


drop table #aux3
select distinct clustergrupo ,SUM(universo_par) as universo_c
into #aux3
from #tab6
group by clustergrupo

drop table #tab7
select distinct a.Dimension,a.clustergrupo , sum(a.nps*a.universo_par/b.universo) as nps_parcial,sum(a.nps*a.universo_par/c.universo_c) as nps_cluster,
sum(a.sol*a.universo_par/b.universo) as sol_parcial,sum(a.ces*a.universo_par/b.universo) as ces_parcial,sum(universo_par) as q_encuestas
into #tab7
from #tab6 as a
left join #aux2 as b on a.Dimension=b.Dimension
left join #aux3 as c on a.clustergrupo=c.clustergrupo
group by a.Dimension,a.clustergrupo

--select * from #tab7

alter table #tab7
add csat float

alter table #tab7
add periodo float

update #tab7
set periodo=202312
where periodo is null

update #tab7
set clustergrupo='Clúster GED'
where clustergrupo='Gobierno y Giros en Desarrollo'

update #tab7
set clustergrupo='Clúster Retail Ampliado'
where clustergrupo='Retail Ampliado'

update #tab7
set clustergrupo='Clúster Servicios de Experiencia'
where clustergrupo='Servicios de Experiencia'

update #tab7
set clustergrupo='Clúster Servicios Digitales'
where clustergrupo='Servicios Digitales'

update #tab7
set clustergrupo='UN Masivo'
where clustergrupo='Masivo'


insert into gdc..tbl_MET_EXP_final 
select periodo,clustergrupo,ces_parcial,csat,nps_parcial,sol_parcial,q_encuestas,Dimension,nps_cluster from #tab7


--Validación
select distinct dimension ,sum(nps_parcial) ,sum(sol_parcial)
from #tab7
group by Dimension
