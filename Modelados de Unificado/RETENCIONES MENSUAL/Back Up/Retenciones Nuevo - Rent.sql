

-- GDC..TBL_RETENCION_FINAL_RENT


-- RETENCIONES CON ANALISIS POR CUADRANTES 

  drop table #rent1
  select 
         periodo, 
		 cc as Codigo, 
		 Ruc, 
		 Movimiento, 
		 [MARGEN POR TXS S/.] as Margen_por_Comercio

  into #rent1
  from gdc..Rano_Caida__R as a
  
  
  -- select sum (margen_por_comercio) as margen_por_comercio from #rent1 where periodo = 201912 

	  drop table #rent2
	  select 
	  isnull (b.Margen_por_Comercio,0) as Margen_Comercio_n,
	  isnull (s.Margen_por_Comercio,0) as Margen_Comercio_n1,
	  isnull (w.Margen_por_Comercio,0) as Margen_Comercio_n2,
	  isnull (y.Margen_por_Comercio,0) as Margen_Comercio_n3,
	  isnull (m.Margen_por_Comercio,0) as Margen_Comercio_n4,
	  isnull (n.Margen_por_Comercio,0) as Margen_Comercio_n5,
	  isnull (q.Margen_por_Comercio,0) as Margen_Comercio_n6,
	  a.* 
	  into #rent2
	  from gdc..tbl_retenciones_final as a
	  inner join #rent1 as b on a.codigo = b.codigo and a.periodo = b.periodo
	  left join (select * from #rent1 ) as s on a.Codigo = s.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-1,convert(date,cast(s.periodo as varchar(10))+'01',112)) -- N + 1
	  left join (select * from #rent1 ) as w on a.Codigo = w.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-2,convert(date,cast(w.periodo as varchar(10))+'01',112)) -- N + 2
	  left join (select * from #rent1 ) as y on a.Codigo = y.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-3,convert(date,cast(y.periodo as varchar(10))+'01',112)) -- N + 3
	  left join (select * from #rent1 ) as m on a.Codigo = m.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-4,convert(date,cast(m.periodo as varchar(10))+'01',112)) -- N + 4
	  left join (select * from #rent1 ) as n on a.Codigo = n.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-5,convert(date,cast(n.periodo as varchar(10))+'01',112)) -- N + 5
	  left join (select * from #rent1 ) as q on a.Codigo = q.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-6,convert(date,cast(q.periodo as varchar(10))+'01',112)) -- N + 6



  drop table gdc..tbl_retenciones_final_rent
  select 
  ( (Margen_Comercio_n 
  +  Margen_Comercio_n1
  +  Margen_Comercio_n2
  +  Margen_Comercio_n3
  +  Margen_Comercio_n4
  +  Margen_Comercio_n5
  +  Margen_Comercio_n6) / 7) as Promedio_Margen_7M ,
  ( (vol_n 
  +  vol_n1
  +  vol_n2
  +  vol_n3) / 4 ) as Promedio_Vol_4M , 
  a.*
  into gdc..tbl_retenciones_final_rent
  from #rent2 as a
  select * from #rent2
  

  SELECT * FROM Gdc..tbl_retenciones_final_rent