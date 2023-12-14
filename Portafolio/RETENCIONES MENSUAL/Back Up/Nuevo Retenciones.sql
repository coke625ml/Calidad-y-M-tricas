 
  --select *
  --from Gdc..DC_TABLERO_RETENCIONES_VF
  --where FLG_RETENIDO = 1

  declare @periodo1 int
  set @periodo1 = 201911   

  -- Crear stock

  drop table #stock
  select 
  a.Periodo,
  a.fechaalta,
  a.Estado,
  a.Codigo, 
  a.Ruc, 
  a.Movimiento, 
  a.Txn, 
  a.Vol, 
  a.MCCINTER, 
  a.MCCNAC,
  a.MOI, 
  a.MOB, 
  a.AgrupacionGiros,
  a.ComerciosTemporales,
  a.LimaProvincias,
  a.Producto,
  a.subproducto
  into #stock
  from Comercial.stock as a
  where Periodo = @periodo1


	

  -- Crear segmentacion

  drop table #segmentos
  select *
  into #segmentos
  from V_Segmento_Cliente
  where periodo = @periodo1



  -- Agregar planes

  drop table #planes
  select 
  a.*
  ,
  isnull(b.FLG_RETENIDO,0) as Flag_Retenido,
  isnull(b.causa,0) as Causa, 
  isnull(b.herramienta_retencion,0) as Herramienta, 
  case when a.MccNac=5555 then 'PLAN SOCIOS'
       when a.MccNac=7777 then 'PLAN BASICO'
       else 'OTROS PLANES' end Tipo_Plan
  into #planes
  from #stock as a
  left join (select * from Gdc..DC_TABLERO_RETENCIONES_VF where periodo = @periodo1) as b on a.Codigo = b.Comercio 
  
  
  -- Agregar rango mob, rango moi y sub_productos 

  drop table #rangos
  select 
  case when a.MOB is null then '[0]'
       when a.MOB>=0 and a.MOB<=2 then '[1-3]'
	   when a.MOB>2 and  a.MOB<=5 then '<3-6]'
	   when a.MOB>5 and  a.MOB<=11 then '<6-12]'
	   when a.MOB>11 and a.MOB<=23 then '<12-24]'
	   when a.MOB>23 and a.MOB<=35 then '<24-36]'
	   when a.MOB>35 then '<36-mas]'
	   else null end RANGO_MOB,
	   case when a.MOI is null then '[0]'
	   when a.MOI>=0 and a.MOI<=2 then '[1-3]'
	   when a.MOI>2 and  a.MOI<=5 then '<3-6]'
	   when a.MOI>5 and  a.MOI<=11 then '<6-12]'
  	   when a.MOI>11 and a.MOI<=23 then '<12-24]'
 	   when a.MOI>23 and a.MOI<=35 then '<24-36]'
	   when a.MOI>35 then '<36-mas]'
	   else null end RANGO_MOI,
	   CASE 
	   WHEN a.Producto ='CE' THEN(
	   CASE WHEN a.SubProducto IN('PW : POS WEB') THEN 'PAGO_LINK'
	   WHEN a.SubProducto IN('PT : PST','CD : DIRECTO','FP : PSP') THEN 'PAGO_WEB'
	   WHEN a.SubProducto IN('CM : CMS') THEN 'Tu_Vitrina'
	   WHEN a.SubProducto IN('AP : APP') THEN 'Pago_APP' 
	   WHEN a.SubProducto IN('QE : QR ESTATICO','QR') THEN 'QR' ELSE 'OTROS' END)  
	   ELSE a.Producto END SUB_PRODUCTO,
	   CASE WHEN a.AgrupacionGiros IN ('Educacion','Hospedaje','Turismo') THEN 'GIROS ESTRELLAS'
	   ELSE 'OTROS GIROS'
	   END AS TIPO_GIRO,
	   a.*
  into #rangos
  from (select * from #planes where herramienta <> '0') as a


    

  -- Agregar canal, subcanal, proveedor, segmento y subsegmento 

  drop table #flags
  select 
  a.*
  ,
  isnull (c.segmento, 'Independiente') as Segmento,
  isnull (c.subsegmento, 'Independiente') as Subsegmento
  into #flags
  from #rangos as a
  left join #segmentos as c on a.ruc = c.ruc



  
  -- Agregar vol, txn y movimiento con N final para atras

  drop table #para_atras
  select 
  a.*,
  b.Vol as vol_n_1,
  b.Txn as txn_n_1,
  b.Movimiento as movimiento_n_1,
  c.Vol as vol_n_2,
  c.txn as txn_n_2,
  c.Movimiento as movimiento_n_2,
  d.Vol as vol_n_3,
  d.Txn as txn_n_3,
  d.Movimiento as movimiento_n_3
  into #para_atras
  from #flags as a -- N
  left join (select periodo, codigo, vol, Txn, movimiento from Comercial.stock ) as b on a.Codigo = b.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,1,convert(date,cast(b.periodo as varchar(10))+'01',112)) -- N-1
  left join (select periodo, codigo, vol, Txn, movimiento from Comercial.stock ) as c on a.Codigo = c.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,2,convert(date,cast(c.periodo as varchar(10))+'01',112)) -- N-2
  left join (select periodo, codigo, vol, txn, movimiento from Comercial.stock ) as d on a.Codigo = d.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,3,convert(date,cast(d.periodo as varchar(10))+'01',112)) -- N-3
  
  
  
  
  -- Agregar vol, txn y movimiento con N para adelante

  drop table #para_adelante
  select 
  a.*
  ,
  m.Vol as vol__n1,
  m.Txn as txn__n1,
  m.Movimiento as movimiento__n1, 
  z.Vol as vol__n2,
  z.txn as txn__n2,
  z.Movimiento as movimiento__n2,
  y.Vol as vol__n3,
  y.Txn as txn__n3, 
  y.Movimiento as movimiento__n3
  into #para_adelante
  from #para_atras as a -- N
  left join (select periodo, codigo, vol, txn, movimiento from Comercial.stock ) as m on a.Codigo = m.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-1,convert(date,cast(m.periodo as varchar(10))+'01',112)) -- N + 1
  left join (select periodo, codigo, vol, txn, movimiento from Comercial.stock ) as z on a.Codigo = z.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-2,convert(date,cast(z.periodo as varchar(10))+'01',112)) -- N + 2
  left join (select periodo, codigo, vol, txn, movimiento from Comercial.stock ) as y on a.Codigo = y.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-3,convert(date,cast(y.periodo as varchar(10))+'01',112)) -- N + 3


   
  -- Crear tabla con estado N + ...


  drop table #final
  select 
  a.*,
  a.estado as estado_n,
  d.estado_n1,
  e.estado_n2,
  f.estado_n3,
  g.estado_n4,
  h.estado_n5,
  t.estado_n6
  into #final
  from #para_adelante as a 
  left join (select periodo, codigo, estado as estado_n1 from Comercial.stock  )  as d on a.Codigo = d.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-1,convert(date,cast(d.periodo as varchar(10))+'01',112))
  left join (select periodo, codigo, estado as estado_n2 from Comercial.stock  )  as e on a.Codigo = e.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-2,convert(date,cast(e.periodo as varchar(10))+'01',112))
  left join (select periodo, codigo, estado as estado_n3 from Comercial.stock  )  as f on a.Codigo = f.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-3,convert(date,cast(f.periodo as varchar(10))+'01',112))
  left join (select periodo, codigo, estado as estado_n4 from Comercial.stock  )  as g on a.Codigo = g.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-4,convert(date,cast(g.periodo as varchar(10))+'01',112))
  left join (select periodo, codigo, estado as estado_n5 from Comercial.stock  )  as h on a.Codigo = h.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-5,convert(date,cast(h.periodo as varchar(10))+'01',112))
  left join (select periodo, codigo, estado as estado_n6 from Comercial.stock  )  as t on a.Codigo = t.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-6,convert(date,cast(t.periodo as varchar(10))+'01',112))


  -- select * from #final

  -- insert into Gdc..tbl_retenciones_tablero select * from #final
 
  -- drop table gdc..tbl_retenciones_tablero
  
 