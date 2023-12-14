      
	  
	  
	  -- TIENEN QUE HABERSE GENERADOS LAS TABLAS DE DEASF. & RETEN.
	  
	  
	  drop table #tab1
      select periodo , Unidad_de_negocio , ruc , count ( Codigo ) as q_desaf
      into #tab1
      from gdc..tbl_retenciones_final
      where periodo = (select max(periodo) from gdc..tbl_retenciones_final)
      and Retenido_No_Retenido = 'no retenido'
      group by periodo , Unidad_de_negocio , Ruc
	  
	  select *
	  from gdc..tbl_desafiliaciones_2021_ruc
	  where periodo = (select max(periodo) from gdc..tbl_desafiliaciones_2021_ruc)
	  and porcentaje_desafiliado = 1
	  and ruc in ( select ruc from #tab1 )

