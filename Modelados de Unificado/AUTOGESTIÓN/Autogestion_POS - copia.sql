
-- crear tabla temporal

drop table #tab1
select *
into #tab1
from gdc..tbl_AUTOGESTION_POS_inicial

-- eliminar RUC niubiz
delete from #tab1
where ruc = 20341198217

-- eliminar lo que no esta aprobado
delete from #tab1
where Descripción_Estado <> 'APROBADO'

-- eliminar columna RUC para reemplazarla
alter table #tab1
drop column RUC



-- agregar RUC y UN, segmentos, Cluster

drop table #tab2
select a.*, b.RUC
into #tab2
from #tab1 as a
left join comercial.BaseComercios as b on a.Código = b.CODIGO


drop table #tab3
select a.*, b.unidadnegocio, b.Segmento, isnull(b.ClusterGrupo, 'Sin Cluster') as ClusterGrupo
into #tab3
from #tab2 as a
left join V_Segmento_Cliente as b on a.ruc = b.ruc


alter table #tab3
drop column Mes


drop table #tab4
select a.*,
       SUBSTRING(CAST(Fecha_Hora as varchar),1,4) as Ano,
	   SUBSTRING(CAST(Fecha_Hora as varchar),6,2) as Mes
into #tab4
from #tab3 as a



drop table #tab5
select a.*,
       (cast(Ano as varchar) + cast(Mes as varchar)) as Periodo
into #tab5
from #tab4 as a

-- crear tabla final

drop table gdc..tbl_AUTOGESTION_POS_final
select *
into gdc..tbl_AUTOGESTION_POS_final
from #tab5