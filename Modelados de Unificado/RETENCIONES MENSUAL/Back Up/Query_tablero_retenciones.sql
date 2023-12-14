
 --XXXXXXXXXXXXXXXXXXXXxxxxxxxxxxxx TABLERO DE RETENCIONES xxxxxxxxxxxxXXXXXXXXXXXXXXXXXXXXX--
 --Reporte de retenciones--
drop table #txns
select codigo,
MAX(CASE when a.Periodo=201701 then Txn else 0 END) [ENE 17],
MAX(CASE when a.Periodo=201702 then txn else 0 END) [FEB 17],
MAX(CASE when a.Periodo=201703 then txn else 0 END) [MAR 17],
MAX(CASE when a.Periodo=201704 then txn else 0 END) [ABR 17],
MAX(CASE when a.Periodo=201705 then txn else 0 END) [MAY 17],
MAX(CASE when a.Periodo=201706 then txn else 0 END) [JUN 17],
MAX(CASE when a.Periodo=201707 then Txn else 0 END) [JUL 17],
MAX(CASE when a.Periodo=201708 then Txn else 0 END) [AGO 17],
MAX(CASE when a.Periodo=201709 then Txn else 0 END) [SEP 17],
MAX(CASE when a.Periodo=201710 then Txn else 0 END) [OCT 17],
MAX(CASE when a.Periodo=201711 then Txn else 0 END) [NOV 17],
MAX(CASE when a.Periodo=201712 then Txn else 0 END) [DIC 17],
MAX(CASE when a.Periodo=201801 then Txn else 0 END) [ENE 18],
MAX(CASE when a.Periodo=201802 then txn else 0 END) [FEB 18],
MAX(CASE when a.Periodo=201803 then Txn else 0 END) [MAR 18],
MAX(CASE when a.Periodo=201804 then Txn else 0 END) [ABR 18],
MAX(CASE when a.Periodo=201805 then Txn else 0 END) [MAY 18],
MAX(CASE when a.Periodo=201806 then Txn else 0 END) [JUN 18],
MAX(CASE when a.Periodo=201807 then Txn else 0 END) [JUL 18],
MAX(CASE when a.Periodo=201808 then Txn else 0 END) [AGO 18],
MAX(CASE when a.Periodo=201809 then Txn else 0 END) [SEP 18],
MAX(CASE when a.Periodo=201810 then Txn else 0 END) [OCT 18],
MAX(CASE when a.Periodo=201811 then txn else 0 END) [NOV 18],
MAX(CASE when a.Periodo=201812 then txn else 0 END) [DIC 18],
MAX(CASE when a.Periodo=201901 then txn else 0 END) [ENE 19],
MAX(CASE when a.Periodo=201902 then txn else 0 END) [FEB 19],
MAX(CASE when a.Periodo=201903 then Txn else 0 END) [MAR 19],
MAX(CASE when a.Periodo=201904 then Txn else 0 END) [ABR 19],
MAX(CASE when a.Periodo=201905 then Txn else 0 END) [MAY 19],
MAX(CASE when a.Periodo=201906 then Txn else 0 END) [JUN 19],
MAX(CASE when a.Periodo=201907 then Txn else 0 END) [JUL 19],
MAX(CASE when a.Periodo=201908 then Txn else 0 END) [AGO 19],
MAX(CASE when a.Periodo=201909 then Txn else 0 END) [SET 19],
MAX(CASE when a.Periodo=201910 then Txn else 0 END) [OCT 19],
MAX(CASE when a.Periodo=201911 then Txn else 0 END) [NOV 19],
MAX(CASE when a.Periodo=201912 then Txn else 0 END) [DIC 19]
into #txns
from Comercial.Stock a
GROUP BY CODIGO


DROP TABLE #vol
select codigo,
MAX(CASE when a.Periodo=201701 then Vol else 0 END) [ENE 17],
MAX(CASE when a.Periodo=201702 then Vol else 0 END) [FEB 17],
MAX(CASE when a.Periodo=201703 then vol else 0 END) [MAR 17],
MAX(CASE when a.Periodo=201704 then vol else 0 END) [ABR 17],
MAX(CASE when a.Periodo=201705 then vol else 0 END) [MAY 17],
MAX(CASE when a.Periodo=201706 then vol else 0 END) [JUN 17],
MAX(CASE when a.Periodo=201707 then vol else 0 END) [JUL 17],
MAX(CASE when a.Periodo=201708 then vol else 0 END) [AGO 17],
MAX(CASE when a.Periodo=201709 then vol else 0 END) [SEP 17],
MAX(CASE when a.Periodo=201710 then vol else 0 END) [OCT 17],
MAX(CASE when a.Periodo=201711 then vol else 0 END) [NOV 17],
MAX(CASE when a.Periodo=201712 then vol else 0 END) [DIC 17],
MAX(CASE when a.Periodo=201801 then vol else 0 END) [ENE 18],
MAX(CASE when a.Periodo=201802 then vol else 0 END) [FEB 18],
MAX(CASE when a.Periodo=201803 then vol else 0 END) [MAR 18],
MAX(CASE when a.Periodo=201804 then vol else 0 END) [ABR 18],
MAX(CASE when a.Periodo=201805 then vol else 0 END) [MAY 18],
MAX(CASE when a.Periodo=201806 then vol else 0 END) [JUN 18],
MAX(CASE when a.Periodo=201807 then vol else 0 END) [JUL 18],
MAX(CASE when a.Periodo=201808 then vol else 0 END) [AGO 18],
MAX(CASE when a.Periodo=201809 then vol else 0 END) [SEP 18],
MAX(CASE when a.Periodo=201810 then vol else 0 END) [OCT 18],
MAX(CASE when a.Periodo=201811 then vol else 0 END) [NOV 18],
MAX(CASE when a.Periodo=201812 then vol else 0 END) [DIC 18],
MAX(CASE when a.Periodo=201901 then Vol else 0 END) [ENE 19],
MAX(CASE when a.Periodo=201902 then Vol else 0 END) [FEB 19],
MAX(CASE when a.Periodo=201903 then Vol else 0 END) [MAR 19],
MAX(CASE when a.Periodo=201904 then Vol else 0 END) [ABR 19],
MAX(CASE when a.Periodo=201905 then Vol else 0 END) [MAY 19],
MAX(CASE when a.Periodo=201906 then Vol else 0 END) [JUN 19],
MAX(CASE when a.Periodo=201907 then Vol else 0 END) [JUL 19],
MAX(CASE when a.Periodo=201908 then Vol else 0 END) [AGO 19],
MAX(CASE when a.Periodo=201909 then Vol else 0 END) [SET 19], 
MAX(CASE when a.Periodo=201910 then Vol else 0 END) [OCT 19],
MAX(CASE when a.Periodo=201911 then Vol else 0 END) [NOV 19],
MAX(CASE when a.Periodo=201912 then Vol else 0 END) [DIC 19]
into #vol
from Comercial.Stock a
GROUP BY CODIGO

drop table #estados
select codigo,
MAX(CASE when a.Periodo=201701 then estado else 0 END) [ENE 17],
MAX(CASE when a.Periodo=201702 then estado else 0 END) [FEB 17],
MAX(CASE when a.Periodo=201703 then estado else 0 END) [MAR 17],
MAX(CASE when a.Periodo=201704 then estado else 0 END) [ABR 17],
MAX(CASE when a.Periodo=201705 then estado else 0 END) [MAY 17],
MAX(CASE when a.Periodo=201706 then estado else 0 END) [JUN 17],
MAX(CASE when a.Periodo=201707 then estado else 0 END) [JUL 17],
MAX(CASE when a.Periodo=201708 then estado else 0 END) [AGO 17],
MAX(CASE when a.Periodo=201709 then estado else 0 END) [SEP 17],
MAX(CASE when a.Periodo=201710 then estado else 0 END) [OCT 17],
MAX(CASE when a.Periodo=201711 then estado else 0 END) [NOV 17],
MAX(CASE when a.Periodo=201712 then estado else 0 END) [DIC 17],
MAX(CASE when a.Periodo=201801 then estado else 0 END) [ENE 18],
MAX(CASE when a.Periodo=201802 then estado else 0 END) [FEB 18],
MAX(CASE when a.Periodo=201803 then estado else 0 END) [MAR 18],
MAX(CASE when a.Periodo=201804 then estado else 0 END) [ABR 18],
MAX(CASE when a.Periodo=201805 then estado else 0 END) [MAY 18],
MAX(CASE when a.Periodo=201806 then estado else 0 END) [JUN 18],
MAX(CASE when a.Periodo=201807 then estado else 0 END) [JUL 18],
MAX(CASE when a.Periodo=201808 then estado else 0 END) [AGO 18],
MAX(CASE when a.Periodo=201809 then estado else 0 END) [SEP 18],
MAX(CASE when a.Periodo=201810 then estado else 0 END) [OCT 18],
MAX(CASE when a.Periodo=201811 then estado else 0 END) [NOV 18],
MAX(CASE when a.Periodo=201812 then estado else 0 END) [DIC 18],
MAX(CASE when a.Periodo=201901 then Estado else 0 END) [ENE 19],
MAX(CASE when a.Periodo=201902 then Estado else 0 END) [FEB 19],
MAX(CASE when a.Periodo=201903 then Estado else 0 END) [MAR 19],
MAX(CASE when a.Periodo=201904 then Estado else 0 END) [ABR 19],
MAX(CASE when a.Periodo=201905 then Estado else 0 END) [MAY 19],
MAX(CASE when a.Periodo=201906 then Estado else 0 END) [JUN 19],
MAX(CASE when a.Periodo=201907 then Estado else 0 END) [JUL 19],
MAX(CASE when a.Periodo=201908 then Estado else 0 END) [AGO 19],
MAX(CASE when a.Periodo=201909 then Estado else 0 END) [SET 19],
MAX(CASE when a.Periodo=201910 then Estado else 0 END) [OCT 19],
MAX(CASE when a.Periodo=201911 then Estado else 0 END) [NOV 19],
MAX(CASE when a.Periodo=201912 then Estado else 0 END) [DIC 19]
into #estados
from Comercial.Stock a
GROUP BY CODIGO

--control de tabla acumulada--
drop table #Base_retenciones
select
a.periodo,
a.Comercio,
a.causa,
a.herramienta_retencion,
case when Herramienta_retencion <> '#' then 1 else 0 end FLG_RETENIDO
into #Base_retenciones
from 
[Gdc].[dbo].[DC_ACU_RETENCIONES] a
where [APLICA SI NO]='SI'

-- select * from #Base_retenciones where Periodo = 201912 and FLG_RETENIDO = 1

insert into [Gdc].[dbo].[DC_TABLERO_RETENCIONES_VF]
select
f.*,
g.MOB,
g.MOI,
case when g.MOB is null then '[0]'
when g.MOB>=0 and g.MOB<=2 then '[1-3]'
when g.MOB>2 and g.MOB<=5 then '<3-6]'
when g.MOB>5 and g.MOB<=11 then '<6-12]'
when g.MOB>11 and g.MOB<=23 then '<12-24]'
when g.MOB>23 and g.MOB<=35 then '<24-36]'
when g.MOB>35 then '<36-mas]'
else null end R_Mesesdevida,
case when g.MOI is null then '[0]'
when g.MOI>=0 and g.MOI<=2 then '[1-3]'
when g.MOI>2 and g.MOI<=5 then '<3-6]'
when g.MOI>5 and g.MOI<=11 then '<6-12]'
when g.MOI>11 and g.MOI<=23 then '<12-24]'
when g.MOI>23 and g.MOI<=35 then '<24-36]'
when g.MOI>35 then '<36-mas]'
else null end R_MesesSinMovimiento,
g.Producto,
g.MccNac,
case when g.MccNac=5555 then 'PLAN SOCIOS'
when g.MccNac=7777 then 'PLAN BASICO'
else 'OTROS PLANES' end MccNac_res,
g.AgrupacionGiros,
g.LimaProvincias,
g.Departamento,
g.Segmento,
g.SubSegmento,
l.Canal,
l.SubCanal,
z.[SET 19] as TRX_N_3,
z.[OCT 19] as TRX_N_2,
z.[NOV 19] as TRX_N_1,
z.[DIC 19] as TRX_N0,
'' as TRX_N1,
'' as TRX_N2,
'' as TRX_N3,
x.[SET 19] as VOL_N_3,
x.[OCT 19] as VOL_N_2,
x.[NOV 19] as VOL_N_1,
x.[DIC 19] as VOL_N0,
'' as VOL_N1,
'' as VOL_N2,
'' as VOL_N3,
case when z.[SET 19]>0 then 1 else 0 end FLG_MOVIO_N_3,
case when z.[OCT 19]>0 then 1 else 0 end FLG_MOVIO_N_2,
case when z.[NOV 19]>0 then 1 else 0 end FLG_MOVIO_N_1,
case when z.[DIC 19]>0 then 1 else 0 end FLG_MOVIO_N0,
'' as FLG_MOVIO_N1,
'' as FLG_MOVIO_N2,
'' as FLG_MOVIO_N3,
G.SubProducto
from 
(select * from #Base_retenciones where periodo = 201912) f -- cambiar periodo  
left join (select * from comercial.Stock where Periodo = 201912) g on f.comercio = g.codigo -- cambiar periodo 
left join #txns z on f.Comercio=z.codigo 
left join #vol x on f.comercio=x.codigo 
left join [Comercial].[Afiliaciones] l on f.comercio=l.codigo

  
  select * 
  from gdc..DC_TABLERO_RETENCIONES_VF
  where periodo = 201912

