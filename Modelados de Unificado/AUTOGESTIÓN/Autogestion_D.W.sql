


-- crear tabla temporal

drop table #tab1
select *
into #tab1
from gdc..tbl_AUTOGESTION_DEVOLUCIONES_WEB_inicial


-- eliminar registros que contengan: usuario generico

delete from #tab1
where Usuario_Registro like '%USUARIO%GENERICO%'


-- eliminar estados que no sean: exitosa, rechazada, eliminada

delete from #tab1
where Estado not in ('Exitosa','Rechazada')



-- crear llave: comercio + fecha_registro + usuario_registro

drop table #tab2
select (cast(Comercio as varchar) + cast(Fecha_Registro as varchar) + cast(Usuario_Registro as varchar)) as Llave, 
       a.*
into #tab2
from #tab1 as a


drop table #tab3
select * 
into #tab3
from #tab2 
order by llave desc



-- crear rank_number

	-- select top 1000 * from #tab4

drop table #tab4
select ROW_NUMBER () over (partition by Llave order by Llave desc) orden
       , a.*
into #tab4
from #tab3 as a	
order by llave desc


delete from #tab4
where orden > 1



drop table #tab5
select a.*,
       SUBSTRING(cast(FECHA as varchar),1,4) as Ano,
	   SUBSTRING(cast(FECHA as varchar),6,2) as Mes
into #tab5
from #tab4 as a



drop table #tab6
select a.*,
       (cast(Ano as varchar) + cast(Mes as varchar)) as Periodo
into #tab6
from #tab5 as a



-- crear tabla final


drop table gdc..tbl_AUTOGESTION_DEVOLUCIONES_WEB_final
select *
into gdc..tbl_AUTOGESTION_DEVOLUCIONES_WEB_final
from #tab6


	-- select * from gdc..tbl_AUTOGESTION_DEVOLUCIONES_WEB_final