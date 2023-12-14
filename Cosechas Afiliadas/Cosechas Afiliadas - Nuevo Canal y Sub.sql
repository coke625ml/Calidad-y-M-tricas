Drop table #afiliacionesproa
  select a.*
  into #afiliacionesproa
  from (select a.*, row_number() over (partition by codigo order by codigo) rnk
  from Comercial..AfiliacionesProa a) a where a.rnk=1 
  

Drop table #Stock
Select a.Periodo,
       a.Ruc,
       a.Codigo,
       a.MOB,
	   a.Fechaalta,	
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
       b.Proveedor
  Into #Stock
  From [Visanet Planeamiento].Comercial.Stock as a
  Left join #afiliacionesproa as b on a.codigo = b.codigo
  Where a.Periodo > 202000
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
  
       
  Drop Table #cosechasafi; 
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
	   -- e.[33 Giros],
       a.Movimiento,
       A.Estado,
       a.Vol,
       a.Txn,
       a.ComerciosTemporales,
       a.Multicomercio,
       a.canal,
       a.subcanal,
	   a.Proveedor,
       a.fechaAlta/100 As Cosecha,	
       IsNull(b.HabAfil,0) As AfiliadoHabilitado,
       IsNull(c.HabDesf,0) As DesAfiliadoHabilitado,
       IsNull(d.Segmento,'-') As Segmento,
       IsNull(d.unidadnegocio,'-') As Unidad_de_Negocio
  Into #cosechasafi
  From #Stock a
       Left Join #TemporalHabilitadoAfiliado b On a.Codigo = b.Codigo
                                              And a.Periodo = b.Periodo
       Left Join #TemporalHabilitadoDesafiliado c On a.Codigo = c.Codigo
                                                 And a.Periodo = c.Periodo
       Left Join #Segmeantacion d On a.ruc = d.Ruc
                                 
	   -- Left join comercial.BaseComercios as e on a.codigo = e.codigo
  
  

  drop table gdc..cosechas_afi
  
  select periodo , 
  -- into gdc..cosechas_afi
  from  #cosechasafi 
  where periodo >= 202000
  
  -- select Cosecha, COUNT(Codigo) as cod from #cosechasafi where MOB = 0 group by cosecha order by cosecha desc

  