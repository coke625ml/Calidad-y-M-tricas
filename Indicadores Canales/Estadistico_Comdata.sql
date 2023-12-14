
-- 1. tabla inicial

		--select *
		--from gdc..tbl_ESTADISTICO_COMDATA_inicial



		-- select flag_proceso, count(*) as q from gdc..tbl_ESTADISTICO_COMDATA_inicial group by flag_proceso

		--alter table gdc..tbl_ESTADISTICO_COMDATA_inicial
		--add Flag_proceso varchar (5)

		--update gdc..tbl_ESTADISTICO_COMDATA_inicial
		--set Flag_proceso = 'New'
		--where Flag_proceso is null

-- 2. seleccionar solo los registros nuevos

drop table #tab0
select *
into #tab0
from gdc..tbl_ESTADISTICO_COMDATA_inicial
where Flag_proceso = 'New'

-- 3. crear columna periodo

alter table #tab0
drop column periodo

drop table #tab1
select a.*,
       year(fecha) as Año ,
	   month(fecha) as Mes 
into #tab1
from #tab0 as a


drop table #tab2
select a.*,
       case when cast(Mes as float) <= 9 then cast(Año as varchar) + '0' + cast(Mes as varchar)
	   else cast(Año as varchar) + cast(Mes as varchar)
	   end as Periodo
into #tab2
from #tab1 as a

-- 4. eliminar Flag_proceso

alter table #tab2
drop column Flag_proceso

-- 5. crear tabla final

--delete from gdc..tbl_ESTADISTICO_COMDATA_final
--where periodo = (select max(periodo) from #tab2)


insert into gdc..tbl_ESTADISTICO_COMDATA_final
select *
from #tab2

-- select * from gdc..tbl_ESTADISTICO_COMDATA_final

-- 6. cambiar en la tabla inicial el campo: FLAG_PROCESO de NEW a USED

update gdc..tbl_ESTADISTICO_COMDATA_inicial
set Flag_proceso = 'Used'
where Flag_proceso = 'New'
