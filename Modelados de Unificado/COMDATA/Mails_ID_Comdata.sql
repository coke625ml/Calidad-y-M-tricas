

	--select fecha, count (*) as q
	--from gdc..tbl_MAILS_ID_COMDATA_inicial
	--group by fecha
	--order by fecha desc

	-- select * from gdc..tbl_MAILS_ID_COMDATA_inicial

	-- select count (*) as q from gdc..tbl_MAILS_ID_COMDATA_inicial
	   -- select count (distinct caso_id) from gdc..tbl_MAILS_ID_COMDATA_final



-- 1. eliminar duplicados y quedarnos con la fecha mayor

drop table #tab1
select a.*, ROW_NUMBER() over(partition by CASO_ID order by Fecha desc) as Orden_Casos
into #tab1
from gdc..tbl_MAILS_ID_COMDATA_inicial as a


		 --select distinct fecha from #tab1 where month(fecha) = 7
		 -- select * from #tab1 where month(fecha) = 7 order by caso_id desc 
		 --select count(*) from #tab1 where Orden_casos = 1
		 --select count(distinct CASO_ID) from #tab1 where Orden_casos = 1


delete from #tab1
where Orden_Casos <> 1


drop table gdc..tbl_MAILS_ID_COMDATA_final
select *
into gdc..tbl_MAILS_ID_COMDATA_final
from #tab1



drop table gdc..tbl_MAILS_ID_COMDATA_inicial
select *
into gdc..tbl_MAILS_ID_COMDATA_inicial
from #tab1


alter table gdc..tbl_MAILS_ID_COMDATA_inicial drop column orden_casos