  
  declare @periodonuevo int
  set @periodonuevo = (select max(periodo) from gdc..tbl_retenciones_final)

  drop table #tab1
  select Periodo, Unidad_de_negocio, ClusterGrupo, causa, Agrupaciones_Motivos, Pool_Funcionario, Cuadrante, Producto, Sub_producto,
		 Herramienta, count (*) as Q
  into #tab1
  from gdc..tbl_retenciones_final
  where periodo = @periodonuevo
  and Retenido_No_Retenido = 'retenido'
  group by periodo, Unidad_de_negocio, ClusterGrupo, causa, Agrupaciones_Motivos, Pool_Funcionario, Cuadrante, Producto, Sub_producto,
		   Herramienta

  
  --select distinct Herramienta
  --from #tab1
  --order by Herramienta desc

  
  drop table #tab2
  select a.* ,	
		 
		 case when Herramienta = 'CAPACITACI�N- CONDICIONES' then 0
			  when Herramienta = 'CAPACITACI�N- CONDICIONES Y PROCESOS' then 0
			  when Herramienta = 'COMPRA DE POS EN PARQUE' then 0
			  
			  when Herramienta = 'COMPRA DE POS EN PARQUE- COSTO CERO' then 0
			  when Herramienta = 'DATEAME' then 0
			  when Herramienta = 'MIGRACION APP VENDEMAS' then 0
			  when Herramienta = 'MIGRACI�N DE PRODUCTO' then 0
			  when Herramienta = 'MIGRACI�N TECNOL�GICA' then 0

			  when Herramienta = 'MIGRACI�N VENDEM�S - EQUIPO COSTO CERO' then 0
			  when Herramienta = 'MIGRACI�N VENDEM�S - EQUIPO REACONDICIONADO' then 0

			  when Herramienta = 'NEGOCIACI�N FUNCIONARIO CORPORATIVO' then 0
			  when Herramienta = 'REEMPLAZO MISMO TECNOLOG�A' then 0
			  when Herramienta = 'SUSPENSI�N DE SERVICIO 3M' then 0
			  when Herramienta = 'SUSPENSI�N MENSUALIDAD 1M' then 0
			  when Herramienta = 'VENTA POS' then 0


			  when Herramienta = 'EXONERACI�N 2 MESES DE ALQUILER' then (Q * 60)
			  
			  when Herramienta = 'EXONERACI�N 3 MESES + CONDONACI�N DE DEUDA' then (Q * 270)
			  when Herramienta = 'EXONERACI�N 3 MESES + DATEAME' then (Q * 90)
			  when Herramienta = 'EXONERACI�N 3 MESES DE ALQUILER' then (Q * 90)
			  when Herramienta = 'EXONERACI�N 3 MESES DE ALQUILER- PW,PL Y PP' then (Q * 90)
			  when Herramienta = 'EXTORNO COBROS 3M ALQUILER + EXONERACI�N 3M ALQUILER' then ((Q * 270) + (Q * 180))
			  
			  when Herramienta = 'EXONERACI�N 4 MESES + CONDONACI�N DE DEUDA' then  (Q * 300)
			  when Herramienta = 'EXONERACI�N 4 MESES + DATEAME' then (Q * 120)
			  when Herramienta = 'EXONERACI�N 4 MESES + REDUCCI�N MENSUALIDAD PLAN 2' then (Q * 300)
			  when Herramienta = 'EXONERACI�N 4 MESES DE ALQUILER' then (Q * 120)

			  when Herramienta = 'EXONERACI�N 6 MESES + CONDONACI�N DE DEUDA' then (Q * 360)
			  when Herramienta = 'EXONERACI�N 6 MESES + DATEAME' then (Q * 180)
			  when Herramienta = 'EXONERACI�N 6 MESES + REDUCCI�N MENSUALIDAD PLAN 2' then (Q * 360)
			  when Herramienta = 'EXONERACI�N 6 MESES DE ALQUILER' then (Q * 180)
			  when Herramienta = 'EXONERACI�N 6 MESES DE ALQUILER- PW,PL, PP' then (Q * 180)
			  

			  when Herramienta = 'EXTORNO DE COBROS' then (Q * 180)
			  when Herramienta = 'CONDONACI�N DE DEUDA' then (Q * 180)

			  when Herramienta = 'REDUCCI�N MENSUALIDAD - Plan1' then (Q * 108)
			  when Herramienta = 'REDUCCI�N MENSUALIDAD - Plan2' then (Q * 180)
			  when Herramienta = 'REDUCCI�N MENSUALIDAD - Plan3' then (Q * 252)

			  when Herramienta = 'MIGRACI�N A VENDEMAS' then (Q * 268)
			  when Herramienta = 'MIGRACI�N DE TECNOLOG�A + EXONERACI�N 3M ALQUILER' then (Q * 90)
			  when Herramienta = 'MIGRACI�N VENDEM�S + CONDONACI�N DE DEUDA' then (Q * 448)



		 end as Inv_Herr
  
  into #tab2
  from #tab1 as a
	
  
  drop table #tab3
  select Periodo, Unidad_de_negocio, ClusterGrupo, causa, Agrupaciones_Motivos, Pool_Funcionario, Cuadrante, Producto, Sub_producto,
		 Herramienta, count (*) as Q, sum (MgTxn_M0) as MgTxn_M0
  into #tab3
  from gdc..tbl_margenes_retenciones_cosechas
  where periodo >= 202101
  and Herramienta in ( 'COMISI�N 0%- 15 D�AS',
	'EXONERACI�N 3 MESES + TASAS MATRIZ AUTONOMIA',
	'EXONERACI�N 4 MESES + TASAS MATRIZ AUTONOMIA',
	'EXONERACI�N 6 MESES + TASAS MATRIZ AUTONOMIA',
	'TASAS MATRIZ AUTONOM�A',
	'TASAS M�XIMAS' )
  group by periodo, Unidad_de_negocio, ClusterGrupo, causa, Agrupaciones_Motivos, Pool_Funcionario, Cuadrante, Producto, Sub_producto,
	     Herramienta


  --select distinct Herramienta
  --from #tab3

  drop table #tab4
  select a.*,

		 case when Herramienta = 'TASAS M�XIMAS' then (isnull(MgTxn_M0,0) * 0.1)
			  when Herramienta = 'TASAS MATRIZ AUTONOM�A' then (isnull(MgTxn_M0,0)* 0.1)
			  when Herramienta = 'EXONERACI�N 6 MESES + TASAS MATRIZ AUTONOMIA' then (180 + (isnull(MgTxn_M0,0) * 0.1))
			  when Herramienta = 'EXONERACI�N 4 MESES + TASAS MATRIZ AUTONOMIA' then (120 + (isnull(MgTxn_M0,0) * 0.1))
			  when Herramienta = 'EXONERACI�N 3 MESES + TASAS MATRIZ AUTONOMIA' then (90 + (isnull(MgTxn_M0,0) * 0.1))
			  when Herramienta = 'COMISI�N 0%- 15 D�AS' then (MgTxn_M0 * 0.5)

		 end as Inv_Herr

  into #tab4
  from #tab3 as a

  --select *
  --from #tab4

  alter table #tab4
  drop column MgTxn_M0;

  delete from #tab2
  where Inv_Herr is null



  
  insert into gdc..tbl_inv_herr
  select *
  from
  (

  select *
  from #tab2
  
  union all

  select *
  from #tab4
  
  ) as b;
