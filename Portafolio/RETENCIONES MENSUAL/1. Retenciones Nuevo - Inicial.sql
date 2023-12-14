 		
------ INSTRUCCIONES
        
 -- 1. S�LO ACTUALIZAR 2020
 -- 2. ACTUALIZAR POR GRUPOS DE TRES MESES
 -- 3. PERIODO_FINAL <= 202004 -> PERIODO_DE_VALOR = 202004
 -- 4. PERIODO_FINAL >= 202005 y PERIODO_FINAL <= 202010 -> PERIODO_DE_VALOR = 202007
 -- 5. PERIODO_FINAL >= 202011 -> PERIODO_DE_VALOR = 202010
 
  
  
     -- select periodo , count (* )  from gdc..tbl_retenciones_final group by periodo order by periodo desc
  
     -- select * from gdc..tbl_retenciones_final

    -- VARIABLES: 

	  -- Periodo Inicial :
	  
		  declare @periodo_inicial int
		  set @periodo_inicial = 202304
       
  
      -- Periodo final :
	  
		  declare @periodo_final int
		  set @periodo_final = 202304


	  -- Periodo de valor :
	  
		  declare @periodogrupovalor int
		  set @periodogrupovalor = 202204
		  

   




		-- 1. Creacion de tabla inicial 

		  drop table #tabla1
		  select 
			  a.*
			  ,
			  isnull (c.Segmento,'Masivo') as Segmento,
			  isnull (c.unidadnegocio,'Masivo') as Unidad_de_negocio,
			  b.fechaalta,
			  b.Ruc, 
			  b.Estado as Estado_N,
			  b.Movimiento as Mov_n, 
			  b.Txn as Txn_n,
			  b.Vol as Vol_n, 
			  b.ComisionVisanet as ComisionVisanet_n,
			  b.MCCINTER, 
			  b.MCCNAC,
			  b.MOI, 
			  b.MOB, 
			  b.AgrupacionGiros,
			  b.ComerciosTemporales,
			  b.LimaProvincias,
			  b.Producto,
			  b.subproducto
	  
			 


		  into #Tabla1 
		  from Gdc..retenciones_input_tablero as a
		  left join [Visanet Planeamiento].[Comercial].[Stock] as b on a.Codigo = b.Codigo and a.periodo = b.periodo
		  left join (select * from [Visanet Planeamiento].[DBO].[V_Segmento_Cliente]) as c on c.Ruc = b.Ruc 
		  	 
			  
		  
		  where a.periodo >= @periodo_inicial
		  and a.periodo <= @periodo_final
		  and a.causa not in ('CAMBIO RAZ�N SOCIAL Y RUC/CAMBIO DE GIRO', 'TIENE OTRO PRODUCTO NIUBIZ', 'TIENE OTRO PRODUCTO VENDEMAS')


		  -- select * from #Tabla1
  
		  -- 2. Agregar movimiento pos - retenci�n y volumen pos - retenci�n :

			 drop table #tab3
			 select 
			  a.*
			  ,
      
			  isnull ( d.Movimiento , 0 )    Mov_n5,
			  isnull ( r.Movimiento , 0 )    Mov_n4,
			  isnull ( q.Movimiento , 0 )    Mov_n3,
			  isnull ( n.Movimiento , 0 )    Mov_n2,
			  isnull ( m.Movimiento , 0 ) as Mov_n1
	  
			  
			  into #tab3

			  from #Tabla1 as a
			  left join (select periodo, codigo, vol, Txn, ComisionVisanet, movimiento from [Visanet Planeamiento].[Comercial].[Stock] ) as m on a.Codigo = m.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-1,convert(date,cast(m.periodo as varchar(10))+'01',112)) -- N+1
			  left join (select periodo, codigo, vol, Txn, ComisionVisanet, movimiento from [Visanet Planeamiento].[Comercial].[Stock] ) as n on a.Codigo = n.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-2,convert(date,cast(n.periodo as varchar(10))+'01',112)) -- N+2
			  left join (select periodo, codigo, vol, txn, ComisionVisanet, movimiento from [Visanet Planeamiento].[Comercial].[Stock] ) as q on a.Codigo = q.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-3,convert(date,cast(q.periodo as varchar(10))+'01',112)) -- N+3
			  left join (select periodo, codigo, vol, txn, ComisionVisanet, movimiento from [Visanet Planeamiento].[Comercial].[Stock] ) as r on a.Codigo = r.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-4,convert(date,cast(r.periodo as varchar(10))+'01',112)) -- N+4
			  left join (select periodo, codigo, vol, txn, ComisionVisanet, movimiento from [Visanet Planeamiento].[Comercial].[Stock] ) as d on a.Codigo = d.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-5,convert(date,cast(d.periodo as varchar(10))+'01',112)) -- N+5


			  -- select * from #tab3
			  
		-- 3. Agregar movimiento pos - retenci�n y volumen pos - retenci�n :
  
			  drop table #tab4
			  select 
			  a.*
			  ,
      
			  isnull ( s.Movimiento , 0 ) as Mov_n_1,
			  isnull ( w.Movimiento , 0 )  as Mov_n_2
	  
		
			  into #tab4

			  from #tab3 as a	 
			  left join (select periodo, codigo, vol, txn, ComisionVisanet, movimiento from [Visanet Planeamiento].[Comercial].[Stock]) as s on a.Codigo = s.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,+1,convert(date,cast(s.periodo as varchar(10))+'01',112)) -- N - 1
			  left join (select periodo, codigo, vol, txn, ComisionVisanet, movimiento from [Visanet Planeamiento].[Comercial].[Stock]) as w on a.Codigo = w.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,+2,convert(date,cast(w.periodo as varchar(10))+'01',112)) -- N - 2
      
			  
			  -- select * from #tab4
	  	 
				
		-- 4. Agregar datos de rentabilidad

			  use [Visanet Planeamiento]

			  --drop table #table70
			  --select 
			  --a.*
			  --,

			  --isnull ( l.margen_txn_n_1,  0 ) as margen_txn_n ,
			  --isnull ( j.margen_txn_n_1,  0 ) as margen_txn_n1 , 
			  --isnull ( k.margen_txn_n_2 , 0 ) as margen_txn_n2 
	  

			  --into #tabla70

			  --from #tabla4 as a
			  --left join (select periodo, codigo, ruc, MargenTransaccion as margen_txn_n_1 from v_rentabilidad_margen)  as l on a.Codigo = l.Codigo and a.periodo = l.periodo 
			  --left join (select periodo, codigo, ruc, MargenTransaccion as margen_txn_n_1 from v_rentabilidad_margen)  as j on a.Codigo = j.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-1,convert(date,cast(j.periodo as varchar(10))+'01',112)) -- N + 1
			  --left join (select periodo, codigo, ruc, MargenTransaccion as margen_txn_n_2 from v_rentabilidad_margen)  as k on a.Codigo = k.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-2,convert(date,cast(k.periodo as varchar(10))+'01',112)) -- N + 2
      


	  
	  
			  --drop table #table7700
			  --select 
			  --a.*
			  --,

			  --isnull ( j.margen_txn_n_1,  0 ) as margen_txn_n3 , 
			  --isnull ( k.margen_txn_n_2 , 0 ) as margen_txn_n4 , 
			  --isnull ( x.margen_txn_n_3 , 0 ) as margen_txn_n5

	  
			  --into #tabla7700

			  --from #tabla70 as a
			  --left join (select periodo, codigo, ruc, MargenTransaccion as margen_txn_n_1 from v_rentabilidad_margen)  as j on a.Codigo = j.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-3,convert(date,cast(j.periodo as varchar(10))+'01',112)) -- N + 3
			  --left join (select periodo, codigo, ruc, MargenTransaccion as margen_txn_n_2 from v_rentabilidad_margen)  as k on a.Codigo = k.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-4,convert(date,cast(k.periodo as varchar(10))+'01',112)) -- N + 4
			  --left join (select periodo, codigo, ruc, MargenTransaccion as margen_txn_n_3 from v_rentabilidad_margen)  as x on a.Codigo = x.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-5,convert(date,cast(x.periodo as varchar(10))+'01',112)) -- N + 5


			  


			  --drop table #table770
			  --select 
			  --a.*
			  --,

			  --isnull ( j.margen_txn_n_1,  0 ) as margen_txn_n6 , 
			  --isnull ( k.margen_txn_n_2 , 0 ) as margen_txn_n7 , 
			  --isnull ( x.margen_txn_n_3 , 0 ) as margen_txn_n8

	  
			  --into #tabla770

			  --from #tabla7700 as a
			  --left join (select periodo, codigo, ruc, MargenTransaccion as margen_txn_n_1 from v_rentabilidad_margen)  as j on a.Codigo = j.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-6,convert(date,cast(j.periodo as varchar(10))+'01',112)) -- N + 6
			  --left join (select periodo, codigo, ruc, MargenTransaccion as margen_txn_n_2 from v_rentabilidad_margen)  as k on a.Codigo = k.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-7,convert(date,cast(k.periodo as varchar(10))+'01',112)) -- N + 7
			  --left join (select periodo, codigo, ruc, MargenTransaccion as margen_txn_n_3 from v_rentabilidad_margen)  as x on a.Codigo = x.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-8,convert(date,cast(x.periodo as varchar(10))+'01',112)) -- N + 8


			  


			  --drop table #table77
			  --select 
			  --a.*
			  --,

			  --isnull ( j.margen_txn_n_1,  0 ) as margen_txn_n9 , 
			  --isnull ( k.margen_txn_n_2 , 0 ) as margen_txn_n10 , 
			  --isnull ( x.margen_txn_n_3 , 0 ) as margen_txn_n11

	  
			  --into #tabla77

			  --from #tabla770 as a
			  --left join (select periodo, codigo, ruc, MargenTransaccion as margen_txn_n_1 from v_rentabilidad_margen)  as j on a.Codigo = j.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-9,convert(date,cast(j.periodo as varchar(10))+'01',112)) -- N + 9
			  --left join (select periodo, codigo, ruc, MargenTransaccion as margen_txn_n_2 from v_rentabilidad_margen)  as k on a.Codigo = k.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-10,convert(date,cast(k.periodo as varchar(10))+'01',112)) -- N + 10
			  --left join (select periodo, codigo, ruc, MargenTransaccion as margen_txn_n_3 from v_rentabilidad_margen)  as x on a.Codigo = x.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-11,convert(date,cast(x.periodo as varchar(10))+'01',112)) -- N + 11


		-- 4. Agregar grupos 


			 drop table #retennueva2
		     select *  

			 into #retennueva2

			 from #tab4
	    
		update #retennueva2
		set Unidad_de_negocio ='Corporativo'
		where Cuadrante like '%Corporativo%'

		update #retennueva2
		set Unidad_de_negocio ='Masivo'
		where Cuadrante like '%Masivo%'


		update #retennueva2
		set cuadrante='[Corporativo : G1]'
		where cuadrante='GRUPO G1'
		and Unidad_de_negocio='Corporativo'

		update #retennueva2
		set cuadrante='[Corporativo : G2]'
		where cuadrante='GRUPO G2'
		and Unidad_de_negocio='Corporativo'

		update #retennueva2
		set cuadrante='[Corporativo : G3]'
		where cuadrante='GRUPO G3'
		and Unidad_de_negocio='Corporativo'

		update #retennueva2
		set cuadrante='[Corporativo : G4]'
		where cuadrante='GRUPO G4'
		and Unidad_de_negocio='Corporativo'

		update #retennueva2
		set cuadrante='[Masivo : G1]'
		where cuadrante='GRUPO G1'
		and Unidad_de_negocio='Masivo'

		update #retennueva2
		set cuadrante='[Masivo : G2]'
		where cuadrante='GRUPO G2'
		and Unidad_de_negocio='Masivo'

		update #retennueva2
		set cuadrante='[Masivo : G3]'
		where cuadrante='GRUPO G3'
		and Unidad_de_negocio='Masivo'

		update #retennueva2
		set cuadrante='[Masivo : G4]'
		where cuadrante='GRUPO G4'
		and Unidad_de_negocio='Masivo'


		     
			 -- select * from #retennueva2

			
			 update #retennueva2
			 set Cuadrante = '[Masivo : G4]'
			 where periodo >= 202001
			 and Cuadrante = 'Sin asignar'
			 and Segmento = 'Masivo'




			 update #retennueva2
			 set Cuadrante = '[Corporativo : G4]'
			 where periodo >= 202001
			 and Cuadrante = 'Sin asignar'
			 and Segmento <> 'Masivo'



			-- Agregar margen asilado de cod.

			
			drop table #retennueva4
			select a.*
			       ,
				   b.MgCom_Aislado as Margen_Txn_Prom_Aislado

			into #retennueva4
			from #retennueva2 as a
			left join gdc..tbl_rentabilidad_codigo as b on a.Codigo = b.Codigo

			
			--select * from #retennueva2
			--select * from #retennueva4
				
		-- 5. Agregar producto y subproducto eq.
		
		drop table #retennueva7
		  
		  select 
		      a.*
			  ,
			  
			  case when a.flg_retenido = 1 then 'Retenido'
			  else 'No Retenido' 
			  end as Retenido_No_Retenido,
			  
			  case when a.MccNac=5555 then 'PLAN SOCIOS'
				   when a.MccNac=7777 then 'PLAN BASICO'
			  else 'OTROS PLANES' end Tipo_Plan,
			  
			  CASE 
				   WHEN a.Producto ='CE' THEN(
			   CASE WHEN a.SubProducto IN('PW : POS WEB') THEN 'PAGO_LINK'
				   WHEN a.SubProducto IN('PT : PST','CD : DIRECTO','FP : PSP') THEN 'PAGO_WEB'
				   WHEN a.SubProducto IN('CM : CMS') THEN 'Tu_Vitrina'
				   WHEN a.SubProducto IN('AP : APP') THEN 'Pago_APP' 
				   WHEN a.SubProducto IN('QE : QR ESTATICO','QR') THEN 'QR' ELSE 'OTROS' END)  
			   
			   else a.Producto end Sub_producto,
			   
			   case when a.AgrupacionGiros IN ('Educacion','Hospedaje','Turismo') THEN 'GIROS ESTRELLAS'
			   else 'OTROS GIROS'
			   end as Tipo_giro
			  
		  
		  into #retennueva7
		  from #retennueva4 as a

  
		  -- select * from #retennueva7


		 -- 7. Agregar habilitados : perm
		 
		  

		  drop table #nuevo1
		  select a.*
				 ,
				 b.EstadoHabilitado as Estadohabilitado_n

		  into #nuevo1
		  from #retennueva7 as a
		  left join v_StockHabilitado as b on a.codigo = b.Codigo and a.periodo = b.Periodo

		  
		  drop table #nuevo2
		  select a.*
				 ,
				 isnull(b.EstadoHabilitado,0) as Estadohabilitado_n1,
				 isnull(D.EstadoHabilitado,0) as Estadohabilitado_n2,
				 isnull(F.EstadoHabilitado,0) as Estadohabilitado_n3
  
		  into #nuevo2
		  from #nuevo1 as a
		  left join v_StockHabilitado as b on a.Codigo = b.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-1,convert(date,cast(b.periodo as varchar(10))+'01',112)) -- N+1
		  left join v_StockHabilitado as D on a.Codigo = D.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-2,convert(date,cast(D.periodo as varchar(10))+'01',112)) -- N+2
		  left join v_StockHabilitado as F on a.Codigo = F.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-3,convert(date,cast(F.periodo as varchar(10))+'01',112)) -- N+3



		  drop table #nuevo3
		  select a.*
				 ,
				 isnull(b.EstadoHabilitado,0) as Estadohabilitado_n4,
				 isnull(D.EstadoHabilitado,0) as Estadohabilitado_n5,
				 isnull(F.EstadoHabilitado,0) as Estadohabilitado_n6
  
		  into #nuevo3
		  from #nuevo2 as a
		  left join v_StockHabilitado as b on a.Codigo = b.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-4,convert(date,cast(b.periodo as varchar(10))+'01',112)) -- N+4
		  left join v_StockHabilitado as D on a.Codigo = D.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-5,convert(date,cast(D.periodo as varchar(10))+'01',112)) -- N+5
		  left join v_StockHabilitado as F on a.Codigo = F.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-6,convert(date,cast(F.periodo as varchar(10))+'01',112)) -- N+6




		  drop table #nuevo4
		  select a.*
				 ,
				 isnull(b.EstadoHabilitado,0) as Estadohabilitado_n7,
				 isnull(D.EstadoHabilitado,0) as Estadohabilitado_n8,
				 isnull(F.EstadoHabilitado,0) as Estadohabilitado_n9
  
		  into #nuevo4
		  from #nuevo3 as a
		  left join v_StockHabilitado as b on a.Codigo = b.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-7,convert(date,cast(b.periodo as varchar(10))+'01',112)) -- N+7
		  left join v_StockHabilitado as D on a.Codigo = D.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-8,convert(date,cast(D.periodo as varchar(10))+'01',112)) -- N+8
		  left join v_StockHabilitado as F on a.Codigo = F.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-9,convert(date,cast(F.periodo as varchar(10))+'01',112)) -- N+9



		  drop table #nuevo7
		  select a.*
				 ,
				 isnull(b.EstadoHabilitado,0) as Estadohabilitado_n10,
				 isnull(D.EstadoHabilitado,0) as Estadohabilitado_n11

  
		  into #nuevo7
		  from #nuevo4 as a
		  left join v_StockHabilitado as b on a.Codigo = b.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-10,convert(date,cast(b.periodo as varchar(10))+'01',112)) -- N+10
		  left join v_StockHabilitado as D on a.Codigo = D.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-11,convert(date,cast(D.periodo as varchar(10))+'01',112)) -- N+11

		  
		  -- select * from #nuevo7

		 -- 9.9 Agregar agrupacion de motivos 

		drop table #nn7

		select a.*
				,
				case when 

				causa in ( 'TIENE OTRO PRODUCTO IZIPAY' , 'TIENE OTRO PRODUCTO (COMPETENCIA)' , 'TIENE OTRO PRODUCTO ( NO VISANET)' ,
				           'TIENE OTRO PRODUCTO VENDEMAS' , 'EN NEGOCIACION CON IZIPAY' , 'SOLICITA MULTIMARCA') 
						    then 'Competencia'


				when causa in ( 'TIENE OTRO PRODUCTO NIUBIZ' , 'CIERRE DE LOCAL TEMPORAL' , 'CIERRE DE LOCAL PERMANENTE' ,
				                'CIERRE DE LOCAL' , 'POCA DEMANDA DE PAGOS CON TARJETA' , 'TIENE OTRO PRODUCTO' ,
								'CIERRE DE LOCAL TEMPORAL SIN RETIRO POS' , 'BAJA/CIERRE DE RUC' , 'TIENE OTRO POS' , 
								'REINVENTA NEGOCIO' ) 
								then 'Coyuntural'

				when causa in ( '#' ) 
								then 'Otros'

				when causa in ( 'CAMBIO RAZ�N SOCIAL Y RUC/CAMBIO DE GIRO' , 'CONDICIONES TECNICAS' , 'DESAFILIAC�N MASIVA' ,
				                'EXPERIENCIA NEGATIVA CON SERVICIO' , 'CAMBIO DE RAZ�N SOCIAL Y RUC' , 'CAMBIA DE LOCAL / MUDA DE LOCAL' , 
								'EXPERIENCIA NEGATIVA CON SERV. COMERCIAL' , 'TRASPASO DE NEGOCIO' , 'VIAJE' , 'NECESITA EFECTIVO / LIQUIDEZ' ,
								'MALA VENTA' , 'MALAS PRACTICAS' , 'EXPERIENCIA NEGATIVA CON SERV. TECNICO' , 'PROBLEMAS CON SUNAT' ,
								'GESTI�N MULTICOMERCIO' , 'PRUEBA' , 'COMPRA DE POS(VENTA)' , 'FRAUDE' , 'ERROR EN LA CREACI�N DEL C�DIGO' ,
								'NO SE CONCRETO AFILIACION' , 'VIAJE DE REPRENSENTANTE LEGAL' , 'REMODELACI�N' , 'RIESGOS Y CUMPLIMIENTO' , 
								'COMERCIO POR TEMPORADAS (SIN MCC FERIA)' , 'LIMPIEZA FERIAS Y EVENTOS' , 'ERROR EN AFILIACI�N DIRECTA' ,
								'CONCRETO AFILIACION' , 'CONCRETO AFILIACION' , 'LIMPIEZA DE CARTERA' , 'Sin asignar' ) then 'Otros'

				when causa in ( 'NO DESEA POR COSTOS (FIJOS Y VARIABLES)' , 'NO DESEA POR COSTOS FIJOS (ALQUILER)' , 'NO DESEA POR COSTOS VARIABLES' , 
				                'CIERRE OPERATIVA (NUEVO PRICING)' ) 
								then 'Pricing'

				else 'Otros'
				
				end as Agrupaciones_Motivos
	
				into #nn7
				from #nuevo7 as a


		-- select * from #nn7
		 
		 -- Agregar Cluster
		 
		 drop table #new7
		 select a.* , isnull ( b.ClusterGrupo , 'Sin Cluster' ) as ClusterGrupo
		 into #new7
		 from #nn7 as a
		 left join V_Segmento_Cliente as b on a.ruc = b.Ruc

		 drop table #new8
		  select periodo,Codigo,Flg_retenido,cast(substring(Herramienta,1,255) as varchar(255)) as Herramienta,cast(substring(causa,1,255) as varchar(255)) as causa
		  ,cast(Pool_Funcionario as varchar(20)) as Pool_Funcionario,cast(Tipo_Funcionario as varchar(20)) as Tipo_Funcionario,Segmento,Unidad_de_negocio,FechaAlta,Ruc
		  ,Estado_N,Mov_n,Txn_n,Vol_n,ComisionVisanet_n,MCCINTER,MCCNAC,MOI,MOB,cast(AgrupacionGiros as varchar(255)) as AgrupacionGiros,ComerciosTemporales,
		  cast(LimaProvincias as varchar(255)) as LimaProvincias,cast(Producto as varchar(255)) as Producto,
		  cast(substring(SubProducto ,1,255) as varchar(255)) as subproducto,Mov_n5,Mov_n4,Mov_n3,Mov_n2,Mov_n1,Mov_n_1,Mov_n_2,cast(Cuadrante as varchar(27)) as Cuadrante
		  ,Margen_Txn_Prom_Aislado,Retenido_No_Retenido,Tipo_Plan,cast(substring(Sub_producto,1,255)as varchar(255)) as sub_prodcuto,Tipo_giro,
		  Estadohabilitado_n,Estadohabilitado_n1,Estadohabilitado_n2,Estadohabilitado_n3,Estadohabilitado_n4,Estadohabilitado_n5,
		  Estadohabilitado_n6,Estadohabilitado_n7,Estadohabilitado_n8,Estadohabilitado_n9,Estadohabilitado_n10,Estadohabilitado_n11,Agrupaciones_Motivos,
		  ClusterGrupo
		  into #new8
		  from #new7


		 -- Final
		 --EXEC tempdb..sp_help #new8
		 -- select * from #new8
		 --select top 1 * from gdc..tbl_retenciones_final

		 insert into gdc..tbl_retenciones_final
		 select *
		 from #new8

		 
		 