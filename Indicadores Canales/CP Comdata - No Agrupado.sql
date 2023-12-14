-- 1. base de calidad percibida

-- select top 10 * from gdc..tbl_CP_COMDATA_inicial

-- select Flag_Proceso, count(*) as q from gdc..tbl_CP_COMDATA_inicial group by Flag_Proceso


		--alter table gdc..tbl_CP_COMDATA_inicial
		--add Flag_Proceso varchar (5)

		--update gdc..tbl_CP_COMDATA_inicial
		--set Flag_Proceso = 'New'
		--where Flag_Proceso is null


-- 1.1. Definir registros que deben procesarse

drop table #tab0
select *
into #tab0
from gdc..tbl_CP_COMDATA_inicial
where Flag_Proceso = 'New'

-- 2. separar en dos columnas diferentes a codigos y RUCs

drop table #tab1
select a.*,
	   SUBSTRING(Datosingresados,1,3) RUC_Codigo,
       case when SUBSTRING(Datosingresados,1,3)='RUC'
				 then cast(SUBSTRING(Datosingresados,6,11) as float)
       else NULL end as RUC, 
       
	   case when SUBSTRING(Datosingresados,1,3)='COD'
				 then cast(SUBSTRING(Datosingresados,18,9) as float)
       else NULL end as Codigo
	   
into #tab1
from #tab0 as a
 

-- 3. agregar el RUC a los registros que sólo tienen codigo pero no tienen RUC

use [Visanet Planeamiento]

drop table #tab2
select a.*,
       b.RUC as RUC_C
into #tab2
from #tab1 as a
left join comercial.basecomercios as b on a.codigo = b.codigo


-- 4. unificar en una sola columna: RUC & RUC_C -> RUC_F

drop table #tab3
select a.*,
       (isnull(RUC,'') + isnull(RUC_C,'')) as RUC_F
into #tab3
from #tab2 as a


-- 5. cruzar RUC_F con RUC para agregar UN, Segmento, Cluster y Grupo_Valor

drop table #tab4
select a.*,
       b.unidadnegocio,
	   b.segmento,
	   b.clustergrupo,
	   d.Cuadrante_No_Aislado as Grupo_Valor
into #tab4
from #tab3 as a
left join v_segmento_cliente as b on a.RUC_F = b.ruc
left join gdc..tbl_GV as d on a.RUC_F = d.ruc


drop table #tab5
select a.*,
       case when Grupo_Valor is null and unidadnegocio = 'Masivo' then '[Masivo : G4]'
	        when Grupo_Valor is null and segmento in ('Gran Cadena', 'Gobierno', 'Top') then '[Corporativo : G1]'
			when Grupo_Valor is null and segmento in ('Tradicional', 'Ligero Top') then '[Corporativo : G4]'
	   else NULL end as Grupo_Valor1
into #tab5
from #tab4 as a


drop table #tab6
select a.*,
       (isnull(Grupo_Valor,'') + isnull(Grupo_Valor1,'')) as Grupo_Valor_F
into #tab6
from #tab5 as a

alter table #tab6
drop column Flag_Proceso

-- 6. crear campo periodo

drop table #tab7
select a.*,
       year(fecha) as Año,
	   month(fecha) as Mes
into #tab7
from #tab6 as a


drop table #tab8
select a.*,
       case when cast(Mes as float) <= 9 then cast(Año as varchar)+'0'+cast(Mes as varchar)
	   else cast(Año as varchar)+cast(Mes as varchar)
	   end as Periodo
into #tab8
from #tab7 as a

-- select * from #tab8



-- 7. insertar en la tabla final los nuevos registros de llamadas entrantes

--delete from gdc..tbl_CP_COMDATA_final
--where periodo = (select max(periodo) from #tab8)

insert into gdc..tbl_CP_COMDATA_final
select *
from #tab8


-- 8. actualizar en la tabla inicial de llamadas los nuevos registros para que en el campo: FLAG_PROCESO, aparezcan como USED

update gdc..tbl_CP_COMDATA_inicial
set Flag_Proceso = 'Used'
where Flag_Proceso = 'New'


-- select count(*) as q from gdc..tbl_CP_COMDATA_inicial
-- select * from gdc..tbl_CP_COMDATA_final