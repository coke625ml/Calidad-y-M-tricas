  

  -- ///////////////////// INSTRUCCIONES /////////////////////

  -- 1) Revisar cada validacion que aparece abajo antes de procesar la data


			-- Validaciones:


							 --    1) validar que el stock del mes anterior cuadre
								--	 ejectur ambos queries al mismo tiempo y comprar numeros
								
								select sum ( estadohabilitado_ant ) as q_stock_ant
							    from gdc..tbl_desafiliaciones_2021
							    where periodo = 202306
								
								select sum ( EstadoHabilitado ) as q_stock
								from v_StockHabilitado_v1
								where periodo = 202307
								
								

								-- 2) Validar que la UN Corporativo, tenga cuadrante corporativo

								select periodo , codigo , unidadnegocio , cuadrante 
							    from gdc..tbl_desafiliaciones_2021
							    where periodo = 202307
								and unidadnegocio = 'corporativo'
								and cuadrante like '%masivo%'
															    

							    update gdc..tbl_desafiliaciones_2021
							    set cuadrante = '[Corporativo : G4]'
							    where periodo = 202307
								and unidadnegocio = 'corporativo'
								and cuadrante like '%masivo%'


								---- 3) Validar que la UN Masivo, tenga cuadrante masivo

								select *
							    from gdc..tbl_desafiliaciones_2021
							    where periodo = 202307
								and unidadnegocio = 'masivo'
								and cuadrante like '%corporativo%'
															    

							    update gdc..tbl_desafiliaciones_2021
							    set cuadrante = '[Masivo : G4]'
							    where periodo = 202307
								and unidadnegocio = 'masivo'
								and cuadrante like '%corporativo%'


								---- 3) Validar que ambas UN , no tengan cuadrante Nulo

								select *
							    from gdc..tbl_desafiliaciones_2021
							    where periodo = 202307
								and cuadrante is null
								and codigo_desafiliado is not null
							    and unidadnegocio = 'masivo'
								

								update gdc..tbl_desafiliaciones_2021
							    set cuadrante = '[Masivo : G4]'
							    where periodo = 202307
								and cuadrante is null
								and codigo_desafiliado is not null
							    and unidadnegocio = 'masivo'


								select *
							    from gdc..tbl_desafiliaciones_2021
							    where periodo = 202307
								and cuadrante is null
								and codigo_desafiliado is not null
							    and unidadnegocio = 'corporativo'
								

								update gdc..tbl_desafiliaciones_2021
							    set cuadrante = '[Corporativo : G4]'
							    where periodo = 202307
								and cuadrante is null
								and codigo_desafiliado is not null
							    and unidadnegocio = 'corporativo'


							 ---- 3) Validar que no hayan desafiliaciones con UN o CUADRANTE Nulo


								select *
							    from gdc..tbl_desafiliaciones_2021
							    where periodo = 202307
								and unidadnegocio is null
								and codigo_desafiliado is not null
								


								update gdc..tbl_desafiliaciones_2021
							    set unidadnegocio = 'Masivo'
							    where periodo = 202307
								and unidadnegocio is null
								and codigo_desafiliado is not null


								select *
							    from gdc..tbl_desafiliaciones_2021
							    where periodo = 202307
								and cuadrante is null
								and codigo_desafiliado is not null

								
								update gdc..tbl_desafiliaciones_2021
							    set cuadrante = '[Procesamiento : G4]'
							    where periodo = 202307
								and cuadrante is null
								and codigo_desafiliado is not null
							    
								
								
								---- 4) Validar que la UN Masivo, no tenga cluster

								select *
								from gdc..tbl_desafiliaciones_2021
								where unidadnegocio = 'Masivo'
								and ClusterGrupo <> 'Sin Asignar' 

														
								update gdc..tbl_desafiliaciones_2021
								set ClusterGrupo = 'Sin Asignar'
								where unidadnegocio = 'Masivo'
								and ClusterGrupo <> 'Sin Asignar'

								
								---- 5) Validar que la UN Corporativo, no tenga cluster Nulo o Sin Asignar

								select *
								from gdc..tbl_desafiliaciones_2021
								where periodo = 202307
								and unidadnegocio = 'Corporativo'
								and ClusterGrupo = 'Sin Asignar'

								update gdc..tbl_desafiliaciones_2021
								set ClusterGrupo = 'Sin Asignar'
								where periodo = 202307
								and unidadnegocio = 'Corporativo'
								and ClusterGrupo = 'Sin Asignar'

								select *
								from gdc..tbl_desafiliaciones_2021
								where periodo = 202307
								and unidadnegocio = 'Corporativo'
								and ClusterGrupo = ''

								update gdc..tbl_desafiliaciones_2021
								set ClusterGrupo = 'Sin Asignar'
								where periodo = 202307
								and unidadnegocio = 'Corporativo'
								and ClusterGrupo = ''
								

							    select *
								from gdc..tbl_desafiliaciones_2021
								where periodo = 202307
								and unidadnegocio = 'Corporativo'
								and ClusterGrupo is null

								update gdc..tbl_desafiliaciones_2021
								set ClusterGrupo = 'Sin Asignar'
								where periodo = 202307
								and unidadnegocio = 'Corporativo'
								and ClusterGrupo is null




								---- 5) Validar que los segmentos estén bien
								
								select *
								from gdc..tbl_desafiliaciones_2021
								where Codigo_desafiliado is not null
								and unidadnegocio = 'Masivo'
								and Segmento is null

								
								update gdc..tbl_desafiliaciones_2021
								set Segmento = 'Masivo'
								where Codigo_desafiliado is not null
								and unidadnegocio = 'Masivo'
								and Segmento is null

								select *
								from gdc..tbl_desafiliaciones_2021
								where Codigo_desafiliado is not null
								and unidadnegocio = 'Masivo'
								and Segmento <> 'Masivo'

								update gdc..tbl_desafiliaciones_2021
								set Segmento = 'Masivo'
								where Codigo_desafiliado is not null
								and unidadnegocio = 'Masivo'
								and Segmento <> 'Masivo'

																	


								select *
								from gdc..tbl_desafiliaciones_2021
								where Codigo_desafiliado is not null
								and unidadnegocio = 'corporativo'
								and Segmento is null

								update gdc..tbl_desafiliaciones_2021
								set Segmento = 'Tradicional'
								where Codigo_desafiliado is not null
								and unidadnegocio = 'corporativo'
								and Segmento is null

								select *
								from gdc..tbl_desafiliaciones_2021
								where Codigo_desafiliado is not null
								and unidadnegocio = 'corporativo'
								and Segmento not in ( 'Ligero Top' , 'Tradicional' , 'Top' , 'Gran Cadena' , 'Gobierno')

								update gdc..tbl_desafiliaciones_2021
								set Segmento = 'Tradicional'
								where Codigo_desafiliado is not null
								and unidadnegocio = 'corporativo'
								and Segmento not in ( 'Ligero Top' , 'Tradicional' , 'Top' , 'Gran Cadena' , 'Gobierno')
								

  
  -- ///////////////////// INICIO DE PROCESAMIENTO /////////////////////

  -- instrucciones: 
	-- 0. CAMBIAR EL PERIODO
	-- 1. EJECUTAR PARTE UNO PRIMERO
	-- 2. EJECUTAR PARTE REALIZAR VALIDACION
	-- 3. EN LA PARTE DOS, COLOCADR EL PERIODO RESPECTIVO


  -- XXXXXXXXXXXXXXXXXX PARTE 1 XXXXXXXXXXXXXXXXXXXXXXXXX
  

  declare @periodo1 as float
  set @periodo1 = (select max(periodo) from gdc..tbl_desafiliaciones_2021)

  
   
  -- 1) Agrupaciones de Desafiliaciones sin RUC

   insert into gdc..tbl_desafiliaciones_2021_agrupado
   select periodo , 
         AgrupacionGiros, 
		 Producto, 
		 SUB_PRODUCTOS, 
		 unidadnegocio , 
		 Segmento , 
		 isnull (ClusterGrupo,'Sin Asignar') as ClusterGrupo , 
		 cuadrante , 
		 isnull ( subtipo , '-' ) as Subtipo ,
		 limaprovincias ,
		 comerciostemporales ,

		 count ( Codigo_desafiliado ) as q_desafiliaciones_generado , 
		 sum ( isnull ( habdesf , 0 )) as q_desafiliaciones_habilitado , 
		 sum ( isnull ( estadohabilitado_ant , 0 ) ) as q_stock_mes_anterior ,
		 sum ( isnull ( Vol , 0 ) ) as vol
		 

  from gdc..tbl_desafiliaciones_2021
  where periodo = @periodo1

  group by 

         periodo , 
         AgrupacionGiros, 
		 Producto, 
		 SUB_PRODUCTOS, 
		 unidadnegocio , 
		 Segmento , 
		 ClusterGrupo , 
		 cuadrante ,
		 subtipo ,
		 limaprovincias ,
		 comerciostemporales



  -- XXXXXXXXXXXXXXXXXX VALIDACION XXXXXXXXXXXXXXXXXXXXXXXXX

	  select sum (q_desafiliaciones_generado) as q_desafiliaciones_generado , 
	         sum ( q_desafiliaciones_habilitado ) as q_desafiliaciones_habilitado , 
			 sum ( q_stock_mes_anterior ) as q_stock_mes_anterior
	  from gdc..tbl_desafiliaciones_2021_agrupado 
	  where periodo = (select max(periodo) from gdc..tbl_desafiliaciones_2021)


	  select count (*) from Comercial.Desafiliacion where periodo = (select max(periodo) from gdc..tbl_desafiliaciones_2021)
	  select count(*)  from v_StockHabilitado_v1 where periodo = (select max(periodo) from gdc..tbl_desafiliaciones_2021) and HabDesf = 1
	  select count (*) from v_StockHabilitado_v1 where periodo = (cast((select max(periodo) from gdc..tbl_desafiliaciones_2021) as bigint)-1) and EstadoHabilitado = 1
	  
  


  -- XXXXXXXXXXXXXXXXXX PARTE DOS XXXXXXXXXXXXXXXXXXXXXXXXX

  drop table #tab0
  select periodo , 
         ruc , 
		 razonsocia , 
		 		 
		 unidadnegocio , 
		 isnull (ClusterGrupo,'Sin Asignar') as ClusterGrupo , 
		 cuadrante , 
		 		 		 
		 count ( Codigo_desafiliado ) as q_desafiliaciones_generado

  into #tab0
  from gdc..tbl_desafiliaciones_2021
  where Codigo_desafiliado is not null
  and periodo = (select max(periodo) from gdc..tbl_desafiliaciones_2021) -- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -- colocar el periodo 
  group by
         periodo , 
         ruc , 
		 RAZONSOCIA ,

		 unidadnegocio , 
		 ClusterGrupo , 
		 cuadrante

		 -- select * from #tab0
  
  -- 3) Agrupaciones de Stock por RUC

  
  drop table #tab00
  select periodo , 
         ruc , 
		 
		 
		 sum ( Estado_generado_mes_anterior ) as Estado_generado_mes_anterior

  into #tab00
  from gdc..tbl_desafiliaciones_2021
  where ruc in ( select ruc from #tab0 )
  and periodo = (select max(periodo) from gdc..tbl_desafiliaciones_2021) -- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -- colocar el periodo 
  group by
         periodo , 
         ruc

		 -- select * from #tab00
		 

  -- 4) Agrupaciones de Desafiliaciones & Stock por RUC


  drop table #tab000
  select a.* , b.Estado_generado_mes_anterior
  into #tab000
  from #tab0 as a
  left join #tab00 as b on a.Ruc = b.Ruc and a.periodo = b.periodo
                                         
        -- select * from #tab000

  
  update #tab000
  set Estado_generado_mes_anterior = q_desafiliaciones_generado
  where Estado_generado_mes_anterior < q_desafiliaciones_generado

  
  -- 5) Agregar porcentaje desafiliado
  

  drop table #tab0000
  select a.* , ( a.q_desafiliaciones_generado / a.Estado_generado_mes_anterior ) as porcentaje_desafiliado
  into #tab0000
  from #tab000 as a
  
   -- select * from #tab0000

  insert into gdc..tbl_desafiliaciones_2021_ruc
  select *
  from #tab0000
 

 --select max(periodo) from gdc..tbl_desafiliaciones_2021_ruc



  -- select periodo , 
  --       AgrupacionGiros, 
		-- Producto, 
		-- SUB_PRODUCTOS, 
		-- unidadnegocio , 
		--  isnull (ClusterGrupo,'Sin Asignar') as ClusterGrupo , 
		-- isnull ( subtipo , '-' ) as Subtipo ,
		-- limaprovincias ,
		-- comerciostemporales ,

		-- count ( Codigo_desafiliado ) as q_desafiliaciones_generado , 
		-- sum ( isnull ( habdesf , 0 )) as q_desafiliaciones_habilitado , 
		-- sum ( isnull ( estadohabilitado_ant , 0 ) ) as q_stock_mes_anterior ,
		-- sum ( isnull ( Vol , 0 ) ) as vol
		 

  --from gdc..tbl_desafiliaciones_2021
  --where periodo = @periodo1

  --group by 

  --       periodo , 
  --       AgrupacionGiros, 
		-- Producto, 
		-- SUB_PRODUCTOS, 
		-- unidadnegocio , 
		-- ClusterGrupo , 
		-- subtipo ,
		-- limaprovincias ,
		-- comerciostemporales