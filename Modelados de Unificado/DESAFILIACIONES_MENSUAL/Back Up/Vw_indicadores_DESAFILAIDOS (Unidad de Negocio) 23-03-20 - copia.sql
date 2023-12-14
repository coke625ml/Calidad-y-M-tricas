USE [Gdc]
GO

/****** Object:  View [dbo].[vw_indicadores_habilitados_desaf]    Script Date: 20/03/2020 18:16:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




alter view [dbo].[vw_indicadores_habilitados_desaf]
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
	isnull (m.canal, 'SIN CANAL') AS CANAL,
	ISNULL (m.subcanal,'SIN SUBCANAL') AS SUBCANAL,
	ISNULL (m.proveedor, 'SIN PROVEEDOR') AS PROVEEDOR,
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
	isnull (q.movimiento,0) as Movimiento_n_1,
	isnull (n.movimiento,0) as Movimiento_n_2,
	isnull (q.Vol,0)    Vol_n_1, 
	isnull (n.Vol,0)    Vol_m_2
from 
	(select periodo as periodo_s, ruc, codigo as codigo_s, fechaalta, mob, moi, movimiento, estado, vol, txn, comisionvisanet, mccnac, 
	        agrupaciongiros, producto, subproducto, comerciostemporales, LimaProvincias 
	 from [Visanet Planeamiento].[Comercial].[Stock] where Periodo >= 201712) as b

left join (select * from [Visanet Planeamiento].[DBO].[v_StockHabilitado] where periodo >= 201712) as a on a.codigo = b.codigo_s and a.periodo = b.periodo_s
left join (select periodo, codigo, estadohabilitado as estadohabilitado_ant from [Visanet Planeamiento].[DBO].[v_StockHabilitado] ) as d on a.Codigo = d.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,1,convert(date,cast(d.periodo as varchar(10))+'01',112))
left join (select ruc as ruc_seg, segmento as segmento_nuevo, unidadnegocio as unidadnegocio from [Visanet Planeamiento].[DBO].[V_Segmento_Cliente]) as c on b.ruc = c.ruc_seg 
left join (select distinct Periodo, Codigo, SubTipo from [Visanet Planeamiento].[Comercial].[Desafiliacion] where Periodo >= 201712) as e on b.codigo_s = e.Codigo and b.periodo_s = e.Periodo
left join (select distinct codigo, canal, subcanal, proveedor from gdc..Afiliacionesproa where alta >= 201712) as m on b.codigo_s = m.codigo
left join (select periodo, codigo, vol, Txn, movimiento, Estado from [Visanet Planeamiento].[Comercial].[Stock] ) as q on b.codigo_s = q.Codigo and convert(date,cast(b.periodo_s as varchar(10))+'01',112) = DATEADD(month,1,convert(date,cast(q.periodo as varchar(10))+'01',112)) -- N-1
left join (select periodo, codigo, vol, Txn, movimiento, Estado from [Visanet Planeamiento].[Comercial].[Stock] ) as n on b.codigo_s = n.Codigo and convert(date,cast(b.periodo_s as varchar(10))+'01',112) = DATEADD(month,2,convert(date,cast(n.periodo as varchar(10))+'01',112)) -- N-2
GO


