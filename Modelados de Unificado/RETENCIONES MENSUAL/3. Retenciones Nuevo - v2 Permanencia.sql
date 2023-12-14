use [Visanet Planeamiento]

  drop table #tab0
  select a.periodo , a.Codigo , a.Retenido_No_Retenido , a.Unidad_de_negocio , a.Herramienta , a.Segmento , a.Agrupaciones_Motivos , a.AgrupacionGiros , a.causa , a.ClusterGrupo ,
         a.ComerciosTemporales , a.Cuadrante , a.Margen_Txn_Prom_Aislado , a.Tipo_Funcionario , a.Sub_producto , a.Producto , 
		 a.Pool_Funcionario , isnull(b.EstadoHabilitado,0) as M0
  into #tab0
  from gdc..tbl_retenciones_final as a
  left join v_StockHabilitado as b on a.Codigo = b.Codigo and a.periodo = b.Periodo
  where a.periodo >= 202101



  drop table #tab1
  select a.* , isnull (b.EstadoHabilitado , 0 ) as M1 , isnull ( n.EstadoHabilitado , 0 ) as M2
  into #tab1
  from #tab0 as a
  left join v_StockHabilitado as b on a.Codigo = b.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-1,convert(date,cast(b.periodo as varchar(10))+'01',112)) -- N+1
  left join v_StockHabilitado as n on a.Codigo = n.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-2,convert(date,cast(n.periodo as varchar(10))+'01',112)) -- N+2



  drop table #tab2
  select a.* , isnull (b.EstadoHabilitado , 0 ) as M3 , isnull ( n.EstadoHabilitado , 0 ) as M4
  into #tab2
  from #tab1 as a
  left join v_StockHabilitado as b on a.Codigo = b.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-3,convert(date,cast(b.periodo as varchar(10))+'01',112)) -- N+3
  left join v_StockHabilitado as n on a.Codigo = n.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-4,convert(date,cast(n.periodo as varchar(10))+'01',112)) -- N+4




  drop table #tab3
  select a.* , isnull (b.EstadoHabilitado , 0 ) as M5 , isnull ( n.EstadoHabilitado , 0 ) as M6
  into #tab3
  from #tab2 as a
  left join v_StockHabilitado as b on a.Codigo = b.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-5,convert(date,cast(b.periodo as varchar(10))+'01',112)) -- N+5
  left join v_StockHabilitado as n on a.Codigo = n.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-6,convert(date,cast(n.periodo as varchar(10))+'01',112)) -- N+6




  drop table #tab4
  select a.* , isnull (b.EstadoHabilitado , 0 ) as M7 , isnull ( n.EstadoHabilitado , 0 ) as M8
  into #tab4
  from #tab3 as a
  left join v_StockHabilitado as b on a.Codigo = b.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-7,convert(date,cast(b.periodo as varchar(10))+'01',112)) -- N+7
  left join v_StockHabilitado as n on a.Codigo = n.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-8,convert(date,cast(n.periodo as varchar(10))+'01',112)) -- N+8




  drop table #tab5
  select a.* , isnull (b.EstadoHabilitado , 0 ) as M9 , isnull ( n.EstadoHabilitado , 0 ) as M10
  into #tab5
  from #tab4 as a
  left join v_StockHabilitado as b on a.Codigo = b.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-9,convert(date,cast(b.periodo as varchar(10))+'01',112))  -- N+9
  left join v_StockHabilitado as n on a.Codigo = n.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-10,convert(date,cast(n.periodo as varchar(10))+'01',112)) -- N+10




  drop table #tab7
  select a.* , isnull (b.EstadoHabilitado , 0 ) as M11 , isnull ( n.EstadoHabilitado , 0 ) as M12
  into #tab7
  from #tab5 as a
  left join v_StockHabilitado as b on a.Codigo = b.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-11,convert(date,cast(b.periodo as varchar(10))+'01',112)) -- N+11
  left join v_StockHabilitado as n on a.Codigo = n.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-12,convert(date,cast(n.periodo as varchar(10))+'01',112)) -- N+12



  drop table gdc..tbl_retenciones_final_permanencia
  select *
  into gdc..tbl_retenciones_final_permanencia
  from #tab7

  -- select * from gdc..tbl_retenciones_final_permanencia where periodo=(Select max(periodo) from gdc..tbl_retenciones_final_permanencia)