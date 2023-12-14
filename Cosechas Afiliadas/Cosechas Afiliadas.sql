Drop Table #Afiliaciones;
Select Codigo,
       Canal,
       SubCanal,
       FechaAlta
  Into #Afiliaciones       
  From [Visanet Planeamiento].Comercial.Afiliaciones
      ;

Drop table #Stock
Select a.Periodo,
       a.Ruc,
       a.Codigo,
       a.MOB,
       a.producto,
       a.SubProducto,
       a.AgrupacionGiros,
       a.Movimiento,
       A.Estado,
       a.Vol,
       a.Txn,
       a.ComerciosTemporales,
       a.Multicomercio,
	   a.LimaProvincias, 
       b.canal,
       b.subcanal,
       b.fechaAlta
	     Into #Stock
  From [Visanet Planeamiento].Comercial.Stock as a
  Left join #Afiliaciones as b on a.codigo = b.codigo
  Where a.Periodo > 201800
      ;

  Drop Table #TemporalHabilitadoAfiliado
Select Periodo,
       Codigo,
       HabAfil
  Into #TemporalHabilitadoAfiliado
  From [Visanet Planeamiento].[DBO].v_StockHabilitado
Where HabAfil = 1
      ;

Drop Table #TemporalHabilitadoDesafiliado
Select Periodo,
       Codigo,
       HabDesf
  Into #TemporalHabilitadoDesafiliado
  From [Visanet Planeamiento].[DBO].v_StockHabilitado
Where HabDesf = 1
      ; 

  Drop Table #Segmeantacion 
	  Select *
	  Into #Segmeantacion
	  From [Visanet Planeamiento].[DBO].V_Segmento_Cliente
  
       
  Drop Table gdc..cosechas_afi; 
Select a.Periodo,
       a.Ruc,
       a.Codigo,
       a.MOB,
       a.producto,
       a.SubProducto,
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
       a.AgrupacionGiros,
	   a.LimaProvincias,
	   e.[33 Giros],
       a.Movimiento,
       A.Estado,
       a.Vol,
       a.Txn,
       a.ComerciosTemporales,
       a.Multicomercio,
       a.canal,
       a.subcanal,
       a.fechaAlta/100 As Cosecha,
       IsNull(b.HabAfil,0) As AfiliadoHabilitado,
       IsNull(c.HabDesf,0) As DesAfiliadoHabilitado,
       IsNull(d.Segmento,'Independiente') As Segmento,
       IsNull(d.SubSegmento,'Independiente') As SubSegmento
  Into gdc..cosechas_afi
  From #Stock a
       Left Join #TemporalHabilitadoAfiliado b On a.Codigo = b.Codigo
                                              And a.Periodo = b.Periodo
       Left Join #TemporalHabilitadoDesafiliado c On a.Codigo = c.Codigo
                                                 And a.Periodo = c.Periodo
       Left Join #Segmeantacion d On a.ruc = d.Ruc
                                 And a.Periodo = d.periodo
	   Left join comercial.BaseComercios as e on a.codigo = e.codigo
  


  -- drop table gdc..cosechas_afi

  select * 
  from gdc..cosechas_afi
  










