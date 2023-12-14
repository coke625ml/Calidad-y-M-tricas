	
-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx para la actualización final xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

  --drop table Gdc..Afiliacionesproa
  --select a.*
  --into Gdc..Afiliacionesproa
  --from (select a.*, row_number () over (partition by codigo order by codigo) rnk
  --from Comercial..AfiliacionesProa a) a where a.rnk=1 







  ---- NOTA .... PARA EL MES NUEVO MIRA EL GRUPO DE VALOR 

   -- delete from gdc..tbl_retenciones_final where periodo = 202008
  
  -- select * from gdc..tbl_retenciones_final where periodo = 202008

  


  declare @periodo1 int
  set @periodo1 = 202009
    
-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX para la actualiación previa al cierre de planeamietno xxxxxxxxxxxxxxxxxxxxxxxxxx


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


	  --,
	  --isnull (d.canal,'Sin Canal')   Canal,
	  --isnull (d.subcanal,'Sin Subcanal')   Subcanal,
	  --isnull (d.Proveedor, 'Sin Proveedor')   Proveedor

  into #Tabla1 
  from Gdc..retenciones_input_tablero as a
  left join [Visanet Planeamiento].[Comercial].[Stock] as b on a.Codigo = b.Codigo and a.periodo = b.periodo
  left join (select distinct ruc, segmento, unidadnegocio from [Visanet Planeamiento].[DBO].[V_Segmento_Cliente]) as c on c.Ruc = b.Ruc 
  -- left join (select distinct codigo, canal, subcanal, proveedor from Gdc..Afiliacionesproa) as d on a.Codigo = d.codigo
  where a.periodo >= 201801
  and a.periodo <= 201912

  -- select * from #Tabla1

  drop table #table3
  select 
	  a.*
	  ,
      
	  isnull ( q.Movimiento , 0 )    Mov_n_3,
	  isnull ( n.Movimiento , 0 )    Mov_n_2,
	  isnull ( m.Movimiento , 0 ) as Mov_n_1,
	  
	 

	  isnull ( q.Txn , 0 )     Txn_n_3,
      isnull ( n.Txn  ,  0 )   Txn_n_2,
	  isnull ( m.Txn , 0 ) as Txn_n_1,
	  
	  
	  
	  isnull ( q.Vol , 0 )    Vol_n_3,
	  isnull ( n.Vol , 0 )    Vol_n_2,
	  isnull ( m.Vol , 0 ) as Vol_n_1,



	  isnull ( q.ComisionVisanet , 0 )   ComisionVisanet_n_3,
	  isnull ( n.ComisionVisanet , 0 )   ComisionVisanet_n_2,
	  isnull (m.ComisionVisanet , 0 )  as ComisionVisanet_n_1
	  
	
	  
	  into #tabla3
	  from #Tabla1 as a
	  
	  left join (select periodo, codigo, vol, Txn, ComisionVisanet, movimiento from [Visanet Planeamiento].[Comercial].[Stock] ) as m on a.Codigo = m.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,1,convert(date,cast(m.periodo as varchar(10))+'01',112)) -- N-1
      left join (select periodo, codigo, vol, Txn, ComisionVisanet, movimiento from [Visanet Planeamiento].[Comercial].[Stock] ) as n on a.Codigo = n.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,2,convert(date,cast(n.periodo as varchar(10))+'01',112)) -- N-2
      left join (select periodo, codigo, vol, txn, ComisionVisanet, movimiento from [Visanet Planeamiento].[Comercial].[Stock] ) as q on a.Codigo = q.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,3,convert(date,cast(q.periodo as varchar(10))+'01',112)) -- N-3
	  



drop table #table4
  select 
	  a.*
	  ,
      
	  
	  
	  isnull ( s.Movimiento , 0 ) as Mov_n1,
	  isnull ( w.Movimiento , 0 )  as Mov_n2,
	  isnull ( y.Movimiento , 0 )  as Mov_n3,

	 
	  
	  isnull ( s.Txn  ,  0 ) as Txn_n1,
	  isnull ( w.Txn  ,  0 ) as Txn_n2,
	  isnull ( y.Txn  ,  0 )  as Txn_n3,
	  
	  
	  
	  isnull ( s.Vol , 0 ) as Vol_n1,
	  isnull ( w.Vol , 0 ) as Vol_n2,
	  isnull ( y.Vol , 0 ) as Vol_n3,



	 isnull (  s.ComisionVisanet , 0 ) as ComisionVisanet_n1,
	 isnull ( w.ComisionVisanet , 0 ) as ComisionVisanet_n2,
	 isnull (  y.ComisionVisanet , 0 ) as ComisionVisanet_n3

	  


	  into #tabla4
	  from #Tabla3 as a
	  
	 
	  left join (select periodo, codigo, vol, txn, ComisionVisanet, movimiento from [Visanet Planeamiento].[Comercial].[Stock] ) as s on a.Codigo = s.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-1,convert(date,cast(s.periodo as varchar(10))+'01',112)) -- N + 1
      left join (select periodo, codigo, vol, txn, ComisionVisanet, movimiento from [Visanet Planeamiento].[Comercial].[Stock] ) as w on a.Codigo = w.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-2,convert(date,cast(w.periodo as varchar(10))+'01',112)) -- N + 2
      left join (select periodo, codigo, vol, txn, ComisionVisanet, movimiento from [Visanet Planeamiento].[Comercial].[Stock] ) as y on a.Codigo = y.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-3,convert(date,cast(y.periodo as varchar(10))+'01',112)) -- N + 3
	  	 




  drop table #table14
  select 
	  a.*
	  ,
	   
	  

	  isnull ( m.ComisionVisanet , 0 ) as ComisionVisanet_n4,
	  isnull ( n.ComisionVisanet , 0 ) as ComisionVisanet_n5,
	  isnull ( q.ComisionVisanet , 0 ) as ComisionVisanet_n6



	  into #tabla14
	  from #Tabla4 as a



	  left join (select periodo, codigo, vol, Txn, ComisionVisanet, movimiento from [Visanet Planeamiento].[Comercial].[Stock] ) as m on a.Codigo = m.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-4,convert(date,cast(m.periodo as varchar(10))+'01',112)) -- N + 4
      left join (select periodo, codigo, vol, Txn, ComisionVisanet, movimiento from [Visanet Planeamiento].[Comercial].[Stock] ) as n on a.Codigo = n.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-5,convert(date,cast(n.periodo as varchar(10))+'01',112)) -- N + 5
      left join (select periodo, codigo, vol, txn, ComisionVisanet, movimiento from [Visanet Planeamiento].[Comercial].[Stock] ) as q on a.Codigo = q.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-6,convert(date,cast(q.periodo as varchar(10))+'01',112)) -- N + 6

	  




drop table #table5
  select 
	  a.*
	  ,

	  isnull ( j.Estado_n1 , 0 ) as Estado_n1 ,
	  isnull ( k.Estado_n2,0 ) as Estado_n2,
	  isnull ( x.Estado_n3 , 0 ) as Estado_n3

	  into #tabla5
	  from #tabla14 as a
	  left join (select periodo, codigo, estado as estado_n1 from [Visanet Planeamiento].[Comercial].[Stock]  )  as j on a.Codigo = j.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-1,convert(date,cast(j.periodo as varchar(10))+'01',112))
      left join (select periodo, codigo, estado as estado_n2 from [Visanet Planeamiento].[Comercial].[Stock]  )  as k on a.Codigo = k.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-2,convert(date,cast(k.periodo as varchar(10))+'01',112))
      left join (select periodo, codigo, estado as estado_n3 from [Visanet Planeamiento].[Comercial].[Stock]  )  as x on a.Codigo = x.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-3,convert(date,cast(x.periodo as varchar(10))+'01',112))



drop table #table8
  select 
	  a.*
	  ,

	  isnull ( v.Estado_n4, 0 ) as Estado_n4,
	  isnull (ñ.estado_n5, 0 ) as estado_n5 , 
	  isnull ( f.estado_n6 ,  0 ) as estado_n6

	  into #tabla8
	  from #tabla5 as a
	  left join (select periodo, codigo, estado as estado_n4 from [Visanet Planeamiento].[Comercial].[Stock]  )  as v on a.Codigo = v.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-4,convert(date,cast(v.periodo as varchar(10))+'01',112))
      left join (select periodo, codigo, estado as estado_n5 from [Visanet Planeamiento].[Comercial].[Stock]  )  as ñ on a.Codigo = ñ.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-5,convert(date,cast(ñ.periodo as varchar(10))+'01',112))
      left join (select periodo, codigo, estado as estado_n6 from [Visanet Planeamiento].[Comercial].[Stock]  )  as f on a.Codigo = f.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-6,convert(date,cast(f.periodo as varchar(10))+'01',112))

	  



	

use [Visanet Planeamiento]
drop table #table70
  select 
	  a.*
	  ,

	  isnull ( j.margen_txn_n_1,  0 ) as margen_txn_n_1 , 
	  isnull ( k.margen_txn_n_2 , 0 ) as margen_txn_n_2 , 
	  isnull ( x.margen_txn_n_3 , 0 ) as margen_txn_n_3

	  into #tabla70
	  from #tabla8 as a
	  left join (select periodo, codigo, ruc, MargenTransaccion as margen_txn_n_1 from v_rentabilidad_margen)  as j on a.Codigo = j.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,+1,convert(date,cast(j.periodo as varchar(10))+'01',112)) -- N - 1
      left join (select periodo, codigo, ruc, MargenTransaccion as margen_txn_n_2 from v_rentabilidad_margen)  as k on a.Codigo = k.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,+2,convert(date,cast(k.periodo as varchar(10))+'01',112)) -- N - 2
      left join (select periodo, codigo, ruc, MargenTransaccion as margen_txn_n_3 from v_rentabilidad_margen)  as x on a.Codigo = x.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,+3,convert(date,cast(x.periodo as varchar(10))+'01',112)) -- N - 3

	  
drop table #table7000
  select 
	  a.*
	  ,

	  isnull ( b.margen_txn_n, 0 ) as margen_txn_n , 
	  isnull ( v.margen_txn_n1 , 0 ) as margen_txn_n1 , 
	  isnull ( ñ.margen_txn_n2 , 0 ) as margen_txn_n2 ,
	  isnull ( f.margen_txn_n3  , 0 ) as margen_txn_n3

	  into #tabla7000
	  from #tabla70 as a
	  left join (select periodo, codigo, ruc, MargenTransaccion as margen_txn_n  from v_rentabilidad_margen)  as b on a.Codigo = b.Codigo and a.periodo = b.Periodo
	  left join (select periodo, codigo, ruc, MargenTransaccion as margen_txn_n1 from v_rentabilidad_margen)  as v on a.Codigo = v.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-1,convert(date,cast(v.periodo as varchar(10))+'01',112)) -- N + 1
      left join (select periodo, codigo, ruc, MargenTransaccion as margen_txn_n2 from v_rentabilidad_margen)  as ñ on a.Codigo = ñ.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-2,convert(date,cast(ñ.periodo as varchar(10))+'01',112)) -- N + 2
      left join (select periodo, codigo, ruc, MargenTransaccion as margen_txn_n3 from v_rentabilidad_margen)  as f on a.Codigo = f.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-3,convert(date,cast(f.periodo as varchar(10))+'01',112)) -- N + 3


	  


drop table #table70000
  select 
	  a.*
	  ,

	  isnull  ( j.margen_com_n_1,  0 ) as margen_com_n_1 ,
	  isnull ( k.margen_com_n_2,  0 ) as margen_com_n_2  ,
	  isnull ( x.margen_com_n_3,  0 ) as margen_com_n_3  , 
	  isnull ( b.margen_com_n  , 0  ) as margen_com_n

	  into #tabla70000
	  from #tabla7000 as a
	  left join (select periodo, codigo, ruc, MargenTransaccion as margen_com_n from v_rentabilidad_margen)  as b on a.Codigo = b.Codigo and a.periodo = b.Periodo
	  left join (select periodo, codigo, ruc, MargenTransaccion as margen_com_n_1 from v_rentabilidad_margen)  as j on a.Codigo = j.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,+1,convert(date,cast(j.periodo as varchar(10))+'01',112)) -- N - 1
      left join (select periodo, codigo, ruc, MargenTransaccion as margen_com_n_2 from v_rentabilidad_margen)  as k on a.Codigo = k.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,+2,convert(date,cast(k.periodo as varchar(10))+'01',112)) -- N - 2
      left join (select periodo, codigo, ruc, MargenTransaccion as margen_com_n_3 from v_rentabilidad_margen)  as x on a.Codigo = x.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,+3,convert(date,cast(x.periodo as varchar(10))+'01',112)) -- N - 3

	  
drop table #table7000000
  select 
	  a.*
	  ,

	  isnull ( v.margen_com_n1, 0 ) as margen_com_n1 ,
	  isnull ( ñ.margen_com_n2,  0 ) as margen_com_n2, 
	  isnull ( f.margen_com_n3 , 0 ) as margen_com_n3

	  into #tabla7000000 
	  from #tabla70000 as a
	  left join (select periodo, codigo, ruc, MargenTransaccion as margen_com_n1 from v_rentabilidad_margen)  as v on a.Codigo = v.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-1,convert(date,cast(v.periodo as varchar(10))+'01',112)) -- N + 1
      left join (select periodo, codigo, ruc, MargenTransaccion as margen_com_n2 from v_rentabilidad_margen)  as ñ on a.Codigo = ñ.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-2,convert(date,cast(ñ.periodo as varchar(10))+'01',112)) -- N + 2
      left join (select periodo, codigo, ruc, MargenTransaccion as margen_com_n3 from v_rentabilidad_margen)  as f on a.Codigo = f.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,-3,convert(date,cast(f.periodo as varchar(10))+'01',112)) -- N + 3

	  
	  
  drop table #tabla7
  select
  a.*
  ,
  isnull ( b.valor , '' ) as valor
  
  into #tabla7
  from #tabla7000000 as a 
  left join gdc..tbl_grupo_valor as b on a.ruc = b.ruc

  
  --select valor, count ( * ) 
  --from #tabla7
  --where periodo = 202001
  --group by valor



drop table #retennueva
  select 
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
	   ELSE a.Producto END SUB_PRODUCTO,
	   CASE WHEN a.AgrupacionGiros IN ('Educacion','Hospedaje','Turismo') THEN 'GIROS ESTRELLAS'
	   ELSE 'OTROS GIROS'
	   END AS TIPO_GIRO,
	  a.*
  into #retennueva
  from #tabla7 as a
  

  -- Gdc..tbl_retenciones_final
  -- cuadrante
  -- costo de herramienta

  drop table #retennueva2
  select 
         a.* ,
		 isnull ( b.Cuadrante , '' ) as Cuadrante

  into #retennueva2
  from #retennueva as a
  left join ( select * from gdc..tbl_grupo_valor_final where periodo = 202007 ) as b on a.ruc = b.ruc
  
  --  arreglar cuandrantes null por UN

  update #retennueva2
  set Cuadrante = '[Masivo : G4]'
  where periodo >= 202001
  and Cuadrante is null
  and Segmento = 'Masivo'


  update #retennueva2
  set Cuadrante = '[Corporativo : G4]'
  where periodo >= 202001
  and Cuadrante is null
  and Segmento <> 'Masivo'


  -- select * from #retennueva2 where periodo >= 202001 and retenido_no_retenido = 'Retenido' and cuadrante is null


  drop table #herramientas
  select 
         a.periodo,
		 a.Codigo,
		 a.herramienta
		 ,
		 case when Herramienta = 'CAPACITACIÓN' then 0
		      when Herramienta = 'CAPACITACIÓN- CONDICIONES' then 0
			  when Herramienta = 'CAPACITACIÓN-VIRTUAL DE USO' then 0
			  when Herramienta = 'MIGRACIÓN TECNOLÓGICA' then 0
			  when Herramienta = 'REEMPLAZO MISMO TECNOLOGÍA' then 0
			  when Herramienta = 'REINSTALACIÓN' then 0
			  when Herramienta = 'TARIFA MENSUAL PAGO LINK' then - 20
			  when Herramienta = 'MIGRACIÓN DE PRODUCTO' then 0
			  when Herramienta = 'SEÑALIZACIÓN' then - 8
			  when Herramienta = 'MIGRACIÓN A VENDEMAS' then - 120
			  when Herramienta = 'CONDONACIÓN DE DEUDA' then - 23
			  when Herramienta = 'EXTORNO DE COBROS' then - 23
			  when Herramienta = ' EXONERACIÓN 2 MESES DE ALQUILER' then SUM ( ( ( ( j.IngresosAlquiler + k.IngresosAlquiler + x.IngresosAlquiler + y.IngresosAlquiler + w.IngresosAlquiler + z.IngresosAlquiler ) / 6 ) * 2 ) * -1 )
			  when Herramienta = 'EXONERACIÓN 2 MESES DE ALQUILER' then SUM ( ( ( ( j.IngresosAlquiler + k.IngresosAlquiler + x.IngresosAlquiler + y.IngresosAlquiler + w.IngresosAlquiler + z.IngresosAlquiler ) / 6 ) * 2 ) * -1 )
			  when Herramienta = 'EXONERACIÓN ALQUILER X 2 MESES'  then SUM ( ( ( ( j.IngresosAlquiler + k.IngresosAlquiler + x.IngresosAlquiler + y.IngresosAlquiler + w.IngresosAlquiler + z.IngresosAlquiler ) / 6 ) * 2 ) * -1 )
			  when Herramienta = 'EXONERACIÓN 6 MESES DE ALQUILER  (PROTEGER/GESTIONAR)'  then SUM ( ( ( ( j.IngresosAlquiler + k.IngresosAlquiler + x.IngresosAlquiler + y.IngresosAlquiler + w.IngresosAlquiler + z.IngresosAlquiler ) / 6 ) * 6 ) * -1 )
			  when Herramienta = 'EXONERACIÓN 6 MESES DE ALQUILER'  then SUM ( ( ( ( j.IngresosAlquiler + k.IngresosAlquiler + x.IngresosAlquiler + y.IngresosAlquiler + w.IngresosAlquiler + z.IngresosAlquiler ) / 6 ) * 6 ) * -1 )
			  when Herramienta = 'ALQUILER GRATIS 6 MESES  (PROTEGER/GESTIONAR)'  then SUM ( ( ( ( j.IngresosAlquiler + k.IngresosAlquiler + x.IngresosAlquiler + y.IngresosAlquiler + w.IngresosAlquiler + z.IngresosAlquiler ) / 6 ) * 6 ) * -1 )
			  when Herramienta = 'SUSPENSIÓN MENSUALIDAD 3M' then SUM ( ( ( ( j.IngresosAlquiler + k.IngresosAlquiler + x.IngresosAlquiler + y.IngresosAlquiler + w.IngresosAlquiler + z.IngresosAlquiler ) / 6 ) * 3 ) * -1 )
			  when Herramienta = 'SUSPENSIÓN MENSUALIDAD 1M' then SUM ( ( ( ( j.IngresosAlquiler + k.IngresosAlquiler + x.IngresosAlquiler + y.IngresosAlquiler + w.IngresosAlquiler + z.IngresosAlquiler ) / 6 ) * 1 ) * -1 )
			  -- when Herramienta = '0% COMISIÓN X 1 MES PL'  then SUM ( ( ( ( j.Com_Visanet + k.Com_Visanet + x.Com_Visanet + y.Com_Visanet + w.Com_Visanet + z.Com_Visanet ) / 6 ) * 1 ) * -1 )
			  -- when Herramienta = '0% COMISIÓN X 2 MESES'  then SUM ( ( ( ( j.Com_Visanet + k.Com_Visanet + x.Com_Visanet + y.Com_Visanet + w.Com_Visanet + z.Com_Visanet ) / 6 ) * 2 ) * -1 )
			  -- when Herramienta = 'COMPRA DE POS EN PARQUE'  then  SUM ( ( j.IngresosAlquiler + k.IngresosAlquiler + x.IngresosAlquiler + y.IngresosAlquiler + w.IngresosAlquiler + z.IngresosAlquiler ) / 6 ) +  ( -8 ) +  ( SUM ( j.Com_Visanet + k.Com_Visanet + x.Com_Visanet + y.Com_Visanet + w.Com_Visanet + z.Com_Visanet ) / 6 ) 
			  -- when Herramienta = 'TASAS MÁXIMAS' then SUM ( ( ( ( j.Volumen + k.Volumen + x.Volumen + y.Volumen + w.Volumen + z.Volumen ) / 6 ) *  (-0.0004) ) * 11 )

			  
			  -- ( SUM ( ( j.Com_Total + k.Com_Total + x.Com_Total+ y.Com_Total + w.Com_Total + z.Com_Total ) / 6 ) )  / ( SUM ( ( j.Volumen + k.Volumen + x.Volumen + y.Volumen + w.Volumen + z.Volumen ) / 6 ) )
			   
			  
			  
			  else 0
			  end as 'Inversión_Herramientas'

  into #herramientas
  from #retennueva2 as a
  -- left join (select * from RentabilidadCompletaTotal2v)  as b on a.Codigo = b.Codigo and a.periodo = b.Periodo
  left join (select * from v_rentabilidad_margen)  as j on a.Codigo = j.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,+4,convert(date,cast(j.periodo as varchar(10))+'01',112)) -- N - 4
  left join (select * from v_rentabilidad_margen)  as k on a.Codigo = k.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,+5,convert(date,cast(k.periodo as varchar(10))+'01',112)) -- N - 5
  left join (select * from v_rentabilidad_margen)  as x on a.Codigo = x.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,+6,convert(date,cast(x.periodo as varchar(10))+'01',112)) -- N - 6
  left join (select * from v_rentabilidad_margen)  as y on a.Codigo = y.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,+7,convert(date,cast(y.periodo as varchar(10))+'01',112)) -- N - 7
  left join (select *  from v_rentabilidad_margen) as w on a.Codigo = w.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,+8,convert(date,cast(w.periodo as varchar(10))+'01',112)) -- N - 8
  left join (select * from v_rentabilidad_margen)  as z on a.Codigo = z.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,+9,convert(date,cast(z.periodo as varchar(10))+'01',112)) -- N - 9
  where Herramienta < > '#'
  and a.periodo >= 202001
  group by a.periodo, a.Codigo, a.Herramienta
  


  -- insert into gdc..tbl_retenciones_final
  select
         a.*
		 ,
		 isnull ( b.Inversión_Herramientas, 0 ) as Inversión_Herramientas,
		 isnull ( l.Margen_Txn_Prom_Aislado , 0 ) Margen_Txn_Prom_Aislado
  
  into #retenfi
  from #retennueva2 as a
  left join #herramientas as b on a.Codigo = b.Codigo and a.periodo = b.periodo
  left join ( select * from Gdc..Tbl_Final_Aislado_Codigo where periodo = 202007 ) as l on a.Codigo = l.Codigo_s
  where a.Periodo =  @periodo1
  
   insert into gdc..tbl_retenciones_final
   select * from #retenfi
   
     -- VALIDACION HERRAMIENTAS --

	 -- select Cuadrante, Herramienta, Inversión_Herramientas
	 -- from gdc..tbl_retenciones_final
	 -- where periodo = 202006
	 -- and Flg_retenido = 1


	 -- select Herramienta, SUM ( Inversión_Herramientas ) , count ( * ) 
	 -- from gdc..tbl_retenciones_final
	 -- where periodo = 202007
	 -- and Retenido_No_Retenido = 'Retenido'
	 -- group by herramienta

	 -- select periodo , sum ( inversión_herramientas ) , count ( * ) 
	 -- from gdc..tbl_retenciones_final
	 -- where periodo >= 202005
	 -- and Retenido_No_Retenido = 'Retenido'
	 -- group by periodo


	 --select periodo , sum ( margen_txn_n ) margen_n , sum ( margen_txn_n1 ) as margen_n1 , sum ( margen_txn_n2 ) as margen_n2 , sum ( margen_txn_n3 ) as margen_n3
	 --from gdc..tbl_retenciones_final
	 --where periodo >= 202004
	 --group by periodo