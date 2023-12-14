
    
  -- PARA LAS AFILIACIONES HABILITADAS

  -- 1. Todos los hab. de 2018-2019

  select * 
  into #habilitados
  from v_stockhabilitado
  where periodo > 201800
  and habafil = 1  

  select * from #habilitados


  -- 2. Todos los hab_desafiliados de 2018-2019

  select * 
  into #habilitados_desaf
  from v_stockhabilitado
  where periodo > 201800
  and habdesf = 1  

  select * from #habilitados_desaf

  -- 3. Stock 

  drop table #stock
  select 
  periodo, codigo, ruc ,movimiento, producto, subproducto, comerciostemporales, limaprovincias, mccnac, agrupaciongiros, vol, txn
  into #stock
  from comercial.stock
  where periodo > 201800
  and codigo in (select codigo from #habilitados)

  select * from #stock
  
  -- 3. Agregar EstadoHabilitado y MobHabilitado

  drop table #habprueba
  select 
  isnull(c.habafil,0) as habafil, 
  -- isnull (d.HabDesf,0) as habdesf,
  isnull (c.estadohabilitado,0) as estadohabilitado, 
  (SubString(cast(cast(a.periodo as decimal(14,0)) as varchar),1,4) * 12 + 
   SubString(cast(cast(a.periodo as decimal(14,0)) as varchar),5,2) 
	- 
  (SubString(cast(cast(b.periodo as decimal(14,0)) as varchar),1,4) * 12 + 
   SubString(cast(cast(b.periodo as decimal(14,0)) as varchar),5,2))) as Mob_Habilitado, 
  b.periodo as periodohab, 
  a.*
  into #habprueba
  from #stock as a
  inner join #habilitados as b on a.codigo = b.codigo
  left join (select * from v_StockHabilitado where periodo > 201800) as c on a.codigo = c.codigo and a.periodo = c.periodo

  -- 4. Agregar Hab. Desafiliado

  drop table #yacasi
  select 
  isnull (b.HabDesf,0) as habdesf
  ,
  CASE 
  WHEN Producto ='CE' THEN(
  CASE WHEN SubProducto IN('PW : POS WEB') THEN 'PAGO_LINK'
  WHEN SubProducto IN('PT : PST','CD : DIRECTO','FP : PSP') THEN 'PAGO_WEB'
  WHEN SubProducto IN('CM : CMS') THEN 'Tu_Vitrina'
  WHEN SubProducto IN('AP : APP') THEN 'Pago_APP' 
  WHEN SubProducto IN('QE : QR ESTATICO','QR') THEN 'QR' ELSE 'OTROS' END)  
  ELSE Producto END SUB_PRODUCTO,
  CASE WHEN a.AgrupacionGiros IN ('Educacion','Hospedaje','Turismo') THEN 'GIROS ESTRELLAS'
  ELSE 'OTROS GIROS'
  END AS TIPO_GIRO,
  a.* 
  into #yacasi
  from #habprueba as a
  left join #habilitados_desaf as b on a.codigo = b.codigo and a.periodo = b.periodo
    
  -- 5. Agergar segmento y subsegmento

  drop table #habfinal
  select b.canal, b.subcanal, isnull(c.segmento, 'Independiente') as Segmento, isnull(c.subsegmento, 'Independiente') as Subsegmento,	a.* 
  into #habfinal 
  from #yacasi as a
  left join comercial.afiliaciones as b on a.codigo = b.codigo
  left join V_Segmento_Cliente as c on a.ruc = c.ruc and a.periodo = c.periodo

  select * from #habfinal

  -- Creación de tabla final
  drop table gdc..cosechas_habilitadas_vf
  select * 
  into gdc..cosechas_habilitadas_vf
  from #habfinal

  select * from gdc..cosechas_habilitadas_vf











