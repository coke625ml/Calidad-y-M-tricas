USE [Gdc]
GO

/****** Object:  View [dbo].[vw_indicadores_habilitados_desaf]    Script Date: 9/05/2020 19:16:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






ALTER view [dbo].[vw_indicadores_habilitados_desaf]
as 
select
	isnull(c.segmento_nuevo,'-') as Nuevo_Segmento,
	isnull(c.unidadnegocio,'-') as Unidad_de_Negocio,
	case when mob>=0 and mob<=2 then '[0-2]'
	when mob > 2 and mob<=7 then '<2-7]'
	when mob = 8 then '[8]'
	when mob = 9 then '[9]'
	when mob = 10 then '[10]'
	when mob = 11 then '[11]'
	when mob = 12 then '[12]'
	when mob > 12 and MOB<=17 then '<12-17]'
	when mob = 18 then '[18]'
	when mob > 18 and MOB<=24 then '<18-24]'
	when mob > 24 then '<24-mas]'
	else null end R_MOB,
	case when substring(FechaAlta,1,4) = 2020 then '2020'
	when substring(FechaAlta,1,4) = 2019 then '2019'
	when substring (FechaAlta,1,4) = 2018 then '2018'
	else '<2018' end as año_alta,
	case when moi = 1 then '[1]'
	when moi = 2 then '[2]'
	when moi = 3 then '[3]'
	when moi = 4 then '[4]'
	when moi = 5 then '[5]'
	when moi = 6 then '[6]'
	when moi = 7 then '[7]'
	when moi = 8 then '[8]'
	when moi > 8 then '<8-mas>'
	else '' end R_MOI,
	case when producto = 'CE' then (
	case when subProducto in ('PW : POS WEB') then 'PAGO_LINK'
	when subProducto in ('PT : PST','CD : DIRECTO','FP : PSP') THEN 'PAGO_WEB'
	when subProducto in ('CM : CMS') THEN 'Tu_Vitrina'
	when subProducto in ('QE : QR ESTATICO', 'QR') THEN 'QR'
	when subProducto in ('AP : APP') THEN 'Pago_APP' ELSE 'OTROS' END) 
	else producto end SUB_PRODUCTOS,
	e.codigo as Codigo_Desaf,
	e.SubTipo,
	b.periodo_s, 
	b.Ruc, 
	b.codigo_s, 
	b.FechaAlta, 
	b.MOB, 
	b.MOI, 
	b.Movimiento, 
	b.Estado,
	b.Vol, 
	b.Txn, 
	b.ComisionVisanet, 
	b.MCCNAC, 
	b.AgrupacionGiros, 
	b.Producto, 
	b.SubProducto, 
	b.ComerciosTemporales, 
	b.LimaProvincias, 
	isnull(a.HabAfil,0) as HabAfil, 
	isnull(a.HabDesf,0) as HabDesf,
	isnull(a.EstadoHabilitado,0) as EstadoHabilitado, 
	isnull(d.estadohabilitado_ant,0) as estadohabilitado_ant,
	
	isnull(y.margen_txn_prom_aislado,0) as Margen_Txn_Prom_Aislado,
	isnull(y.vol_prom_aislado,0) as Vol_prom_Aislado,
	z.cuadrante,
	w.Margen_TransaccionSoles,
	w.Margen_ComercioSoles

from 
	(select periodo as periodo_s, ruc, codigo as codigo_s, fechaalta, mob, moi, movimiento, estado, vol, txn, comisionvisanet, mccnac, 
	        agrupaciongiros, producto, subproducto, comerciostemporales, LimaProvincias 
	 from [Visanet Planeamiento].[Comercial].[Stock] where Periodo >= 201901 ) as b

left join (select * from [Visanet Planeamiento].[DBO].[v_StockHabilitado] where periodo >= 201901 ) as a on a.codigo = b.codigo_s and a.periodo = b.periodo_s
left join (select periodo, codigo, estadohabilitado as estadohabilitado_ant from [Visanet Planeamiento].[DBO].[v_StockHabilitado] where periodo >=201812 ) as d on a.Codigo = d.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,1,convert(date,cast(d.periodo as varchar(10))+'01',112))
left join (select ruc as ruc_seg, segmento as segmento_nuevo, unidadnegocio as unidadnegocio from [Visanet Planeamiento].[DBO].[V_Segmento_Cliente]) as c on b.ruc = c.ruc_seg 
left join (select distinct Periodo, Codigo, SubTipo from [Visanet Planeamiento].[Comercial].[Desafiliacion] where Periodo >= 201901) as e on b.codigo_s = e.Codigo and b.periodo_s = e.Periodo

left join (select * from gdc..Tbl_Final_Aislado_codigo) as y on a.Codigo = y.codigo_s and a.Periodo = y.periodo
left join (select * from gdc..Tbl_Grupo_Valor_final) as z on b.ruc = z.ruc and convert(date,cast(b.periodo_s as varchar(10))+'01',112) = DATEADD(month,1,convert(date,cast(z.periodo as varchar(10))+'01',112))
left join (select Periodo, Codigo, Margen_TransaccionSoles, Margen_ComercioSoles from [Visanet Planeamiento]..[RentabilidadCompletaTotal2v] where periodo >= 201901 ) as w on a.Codigo = w.Codigo and a.Periodo = w.Periodo

GO