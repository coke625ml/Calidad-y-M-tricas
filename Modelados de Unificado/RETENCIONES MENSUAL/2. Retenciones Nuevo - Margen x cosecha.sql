

  select periodo , ruc, codigo , Retenido_No_Retenido , Herramienta , Agrupaciones_Motivos , causa ,
         Pool_Funcionario , Unidad_de_negocio , Segmento , ClusterGrupo , AgrupacionGiros , Producto , Sub_producto ,
		 Cuadrante
  into #tab0
  from gdc..tbl_retenciones_final
  where periodo >= 202101
  

  drop table #tab00
  select a.* , b.MargenTransaccion as MgTxn_M0 , b.MargenTransaccion as MgCom_M0
  into #tab00
  from #tab0 as a
  left join v_Rentabilidad_Margen_v2 as b on a.Codigo = b.Codigo and a.periodo = b.periodo

  

  drop table #tab000
  select a.* , 
         b.MargenTransaccion as MgTxn_M1 , b.MargenComercio as MgCom_M1 ,
		 d.MargenTransaccion as MgTxn_M2 , d.MargenComercio as MgCom_M2

  into #tab000
  from #tab00 as a
  left join v_Rentabilidad_Margen_v2 as b on a.Codigo = b.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-1,convert(date,cast(b.periodo as varchar(10))+'01',112)) -- N+1
  left join v_Rentabilidad_Margen_v2 as d on a.Codigo = d.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-2,convert(date,cast(d.periodo as varchar(10))+'01',112)) -- N+2




  
  drop table #tab0000
  select a.* , 
         b.MargenTransaccion as MgTxn_M3 , b.MargenComercio as MgCom_M3 ,
		 d.MargenTransaccion as MgTxn_M4 , d.MargenComercio as MgCom_M4

  into #tab0000
  from #tab000 as a
  left join v_Rentabilidad_Margen_v2 as b on a.Codigo = b.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-3,convert(date,cast(b.periodo as varchar(10))+'01',112)) -- N+3
  left join v_Rentabilidad_Margen_v2 as d on a.Codigo = d.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-4,convert(date,cast(d.periodo as varchar(10))+'01',112)) -- N+4





  
  drop table #tab00000
  select a.* , 
         b.MargenTransaccion as MgTxn_M5 , b.MargenComercio as MgCom_M5 ,
		 d.MargenTransaccion as MgTxn_M6 , d.MargenComercio as MgCom_M6

  into #tab00000
  from #tab0000 as a
  left join v_Rentabilidad_Margen_v2 as b on a.Codigo = b.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-5,convert(date,cast(b.periodo as varchar(10))+'01',112)) -- N+5
  left join v_Rentabilidad_Margen_v2 as d on a.Codigo = d.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-6,convert(date,cast(d.periodo as varchar(10))+'01',112)) -- N+6





  drop table #tab0000000
  select a.* , 
         b.MargenTransaccion as MgTxn_M7 , b.MargenComercio as MgCom_M7 ,
		 d.MargenTransaccion as MgTxn_M8 , d.MargenComercio as MgCom_M8

  into #tab0000000
  from #tab00000 as a
  left join v_Rentabilidad_Margen_v2 as b on a.Codigo = b.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-7,convert(date,cast(b.periodo as varchar(10))+'01',112)) -- N+7
  left join v_Rentabilidad_Margen_v2 as d on a.Codigo = d.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-8,convert(date,cast(d.periodo as varchar(10))+'01',112)) -- N+8



  
  drop table #tab00000000
  select a.* , 
         b.MargenTransaccion as MgTxn_M9 , b.MargenComercio as MgCom_M9 ,
		 d.MargenTransaccion  MgTxn_M10 , d.MargenComercio as MgCom_M10

  into #tab00000000
  from #tab0000000 as a
  left join v_Rentabilidad_Margen_v2 as b on a.Codigo = b.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-9,convert(date,cast(b.periodo as varchar(10))+'01',112)) -- N+9
  left join v_Rentabilidad_Margen_v2 as d on a.Codigo = d.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-10,convert(date,cast(d.periodo as varchar(10))+'01',112)) -- N+10




  drop table #tab000000000
  select a.* , 
         b.MargenTransaccion as MgTxn_M11 , b.MargenComercio as MgCom_M11

  into #tab000000000
  from #tab00000000 as a
  left join v_Rentabilidad_Margen_v2 as b on a.Codigo = b.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-11,convert(date,cast(b.periodo as varchar(10))+'01',112)) -- N+11


  
  
  drop table gdc..tbl_margenes_retenciones_cosechas
  select *
  into gdc..tbl_margenes_retenciones_cosechas
  from #tab000000000


  select *
  from gdc..tbl_margenes_retenciones_cosechas