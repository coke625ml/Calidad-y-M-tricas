
drop table #tab1
select a.*,
       a.[Valor código de comercio] as Codigo_Comercio,
	   cast(Mes as int) as Mes_Nuevo
into #tab1
from gdc..tbl_consolidado_metricas_experiencia as a


drop table #tab2
select a.*,
       case when a.Mes_Nuevo <= 9 then cast(Año as varchar) + '0' + cast(Mes_Nuevo as varchar)
	   else cast(Año as varchar) + cast(Mes_Nuevo as varchar)
	   end as Periodo,
	   case when cast([R SAT] as float) in (4,5) then 1
	   else 0
	   end as FLAG_SAT,
	   case when cast([R CES] as float) in (4,5) then 1
	   else 0
	   end as FLAG_CES
into #tab2
from #tab1 as a


drop table gdc..tbl_consolidado_metricas_experiencia_final
select a.*,
       b.unidadnegocio,
	   b.Segmento as Segmento_N,
	   b.ClusterGrupo
       
into gdc..tbl_consolidado_metricas_experiencia_final
from #tab2 as a
left join V_Segmento_Cliente as b on a.ruc = b.ruc


select [R SOL], COUNT (*) AS Q from gdc..tbl_consolidado_metricas_experiencia_final GROUP BY [R SOL]

select 
       count (UN) as UN,
	   count (unidadnegocio) as unidadnegocio,
	   count (Segmento) as Segmento,
	   count (Segmento_N) as Segmento_N,
	   count (cluster) as Cluster,
	   count (ClusterGrupo) as ClusterGrupo
from #tab3

-- select * from #tab1