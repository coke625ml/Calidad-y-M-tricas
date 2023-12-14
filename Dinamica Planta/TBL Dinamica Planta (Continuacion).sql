-- drop table gdc..tbl_dinamica_planta

-- select * into gdc..tbl_dinamica_planta from gdc..tbl_reactivaciones 


 
  
-- XXXXXXXXXXX EMPEZAR DESDE AQUÍ XXXXXXXXXXXXXX --






-- select periodo, tipo, count (*) from gdc..tbl_dinamica_planta group by periodo, tipo order by periodo desc
  
    
  declare @periodo1 as int  
  set @periodo1 = 202001 -- periodo menor

  declare @periodo2 as int
  set @periodo2 = 202002 -- periodo mayor

  

--Stock--

drop table #previo1
select periodo, codigo, ruc, comerciostemporales, limaprovincias, agrupaciongiros, producto, subproducto, movimiento, estado, vol, txn, moi, mob
into #previo1
from Comercial.Stock where Periodo in (@periodo1, @periodo2)

-- select periodo, count (*) from #previo1 group by periodo

--Cruce con desafiliaciones--

drop table #stock2
select a.*,
isnull(b.habafil,0) Habafil, 
isnull(b.habdesf,0) habdesf, 
isnull(b.estadohabilitado,0) as estadohabilitado 
into #stock2
from #previo1 as a 
left join v_stockhabilitado as b on a.codigo = b.codigo and a.periodo = b.periodo

-- select count (*) from #stock2

-- Quitar duplicados

drop table #stock
select a.*
into #stock
from (select a.*,
row_number() over (partition by codigo,periodo order by codigo)  rnk
from #stock2 a) a where a.rnk=1  

-- select count (*) from #stock

-- Agregar Segmento y Subsegmento -- 

drop table #stockfinal1
select c.segmento as segmento_, c.subsegmento as subsegmento_, a.*
into #stockfinal1
from #stock as a 
left join V_Segmento_Cliente as c on a.ruc = c.ruc and a.periodo = c.periodo

-- select count (*) from #stockfinal1





--  select count (*) from v_StockHabilitado where periodo = 201910 and estadohabilitado = 1
--  select count (*) from #planta_i where periodo = 201910 and estadohabilitado =1





-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX CREACION DE TEMPORALES SEMI - FINAL XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX --

drop table #perm  

select a.*, b.MOI as MOI_ANTERIOR,
case when (a.txn>=3 and a.vol>=20) then 1 else 0 end Uso into #perm 
from 
(select * from #stockfinal1 where Movimiento=1 and periodo = @periodo2 ) a left join
(select * from #stockfinal1 where Movimiento=1 and periodo = @periodo1 ) b on a.Codigo = b.Codigo
where b.Periodo is not null


drop table #desafiliacion

select a.*, MOI as MOI_ANTERIOR,
case when (a.txn>=3 and a.vol>=20) then 1 else 0 end uso into #desafiliacion
from 
(select * from #stockfinal1 where Periodo = @periodo2 ) a left join
(select * from Comercial.Desafiliacion where Periodo = @periodo2 ) b on a.Codigo=b.Codigo
where b.Periodo is not null


drop table #react_temp

select a.*, MOI as MOI_ANTERIOR,
case when (a.txn>=3 and a.vol>=20) then 1 else 0 end uso into #react_temp 
from 
(select * from #stockfinal1 where Periodo = @periodo2 ) a left join
(select * from Comercial.reactivacion where Periodo = @periodo2 ) b on a.Codigo=b.Codigo
where b.Periodo is not null



---- XXXXXXXXXXXXXXXXXXXXXXXXXXXX TABLA FINAL XXXXXXXXXXXXXXXXXXXXXXXXXXX ----



-- AFILIACIONES




drop table #afiliaciones
SELECT 
Periodo,
Producto,
AgrupacionGiros,
Comerciostemporales,
Limaprovincias, 
Movimiento, 
Estado,
MOI, 
Habafil,
Habdesf, 
Segmento_, 
Subsegmento_, 
Estadohabilitado, 
CASE 
WHEN Producto ='CE' THEN(
CASE WHEN SubProducto IN('PW : POS WEB') THEN 'PAGO_LINK'
WHEN SubProducto IN('PT : PST','CD : DIRECTO','FP : PSP') THEN 'PAGO_WEB'
WHEN SubProducto IN('CM : CMS') THEN 'Tu_Vitrina'
WHEN SubProducto IN('AP : APP') THEN 'Pago_APP' 
WHEN SubProducto IN('QE : QR ESTATICO','QR') THEN 'QR' ELSE 'OTROS' END)  
ELSE Producto END SUB_PRODUCTO,
case
when MOB>=0 and MOB<=2 then '[0-2]'
when MOB>2 and MOB<=12 then '<2-12]'
when MOB>12 and MOB<=24 then '<12-24]'
when MOB>24 then '<24-mas]'
else null end R_MOB,
case when (txn>=3 and vol>=20) then 1 else 0 end uso,
COUNT(*) COMERCIOS,
SUM(TXN) TXN,
SUM(VOL) VOL
into #afiliaciones
FROM #stockfinal1
WHERE Periodo = @periodo2  -------------------------------------------------------------- Cambia periodo al periodo mayor
AND Habafil = 1
GROUP BY 
Periodo, 
Producto,
AgrupacionGiros,
Comerciostemporales,
Limaprovincias, 
Movimiento, 
Estado,
MOI, 
Habafil,
Habdesf, 
Segmento_, 
Subsegmento_, 
Estadohabilitado, 
CASE 
WHEN Producto ='CE' THEN(
CASE WHEN SubProducto IN('PW : POS WEB') THEN 'PAGO_LINK'
WHEN SubProducto IN('PT : PST','CD : DIRECTO','FP : PSP') THEN 'PAGO_WEB'
WHEN SubProducto IN('CM : CMS') THEN 'Tu_Vitrina'
WHEN SubProducto IN('AP : APP') THEN 'Pago_APP' 
WHEN SubProducto IN('QE : QR ESTATICO','QR') THEN 'QR' ELSE 'OTROS' END)  
ELSE Producto END,
case
when MOB>=0 and MOB<=2 then '[0-2]'
when MOB>2 and MOB<=12 then '<2-12]'
when MOB>12 and MOB<=24 then '<12-24]'
when MOB>24 then '<24-mas]'
else null end,
case when (txn>=3 and vol>=20) then 1 else 0 end

-- select * from #afiliaciones

alter table #afiliaciones
ADD Tipo NVARCHAR (20) NOT NULL
CONSTRAINT CONSTRAINTNAME DEFAULT 'Afiliaciones'
WITH VALUES


insert into gdc..tbl_dinamica_planta
select * 
from #afiliaciones


-- DESAFILIACIONES  



drop table #desaf
select 
Periodo,
Producto,
AgrupacionGiros,
Comerciostemporales,
Limaprovincias, 
Movimiento, 
Estado,
MOI_ANTERIOR, 
Habafil,
Habdesf, 
Segmento_, 
Subsegmento_, 
Estadohabilitado, 
CASE 
WHEN Producto ='CE' THEN(
CASE WHEN SubProducto IN('PW : POS WEB') THEN 'PAGO_LINK'
WHEN SubProducto IN('PT : PST','CD : DIRECTO','FP : PSP') THEN 'PAGO_WEB'
WHEN SubProducto IN('CM : CMS') THEN 'Tu_Vitrina'
WHEN SubProducto IN('AP : APP') THEN 'Pago_APP' 
WHEN SubProducto IN('QE : QR ESTATICO','QR') THEN 'QR' ELSE 'OTROS' END)  
ELSE Producto END SUB_PRODUCTO,
case
when MOB>=0 and MOB<=2 then '[0-2]'
when MOB>2 and MOB<=12 then '<2-12]'
when MOB>12 and MOB<=24 then '<12-24]'
when MOB>24 then '<24-mas]'
else null end R_MOB,
uso,
COUNT(*) COMERCIOS,
SUM(TXN) TXN,
SUM(VOL) VOL
into #desaf
from #desafiliacion
WHERE HABDESF = 1
GROUP BY 
Periodo,
Producto,
AgrupacionGiros,
Comerciostemporales,
Limaprovincias, 
Movimiento, 
Estado,
MOI_ANTERIOR, 
Habafil,
Habdesf, 
Segmento_, 
Subsegmento_, 
Estadohabilitado, 
CASE 
WHEN Producto ='CE' THEN(
CASE WHEN SubProducto IN('PW : POS WEB') THEN 'PAGO_LINK'
WHEN SubProducto IN('PT : PST','CD : DIRECTO','FP : PSP') THEN 'PAGO_WEB'
WHEN SubProducto IN('CM : CMS') THEN 'Tu_Vitrina'
WHEN SubProducto IN('AP : APP') THEN 'Pago_APP' 
WHEN SubProducto IN('QE : QR ESTATICO','QR') THEN 'QR' ELSE 'OTROS' END)  
ELSE Producto END,
case
when MOB>=0 and MOB<=2 then '[0-2]'
when MOB>2 and MOB<=12 then '<2-12]'
when MOB>12 and MOB<=24 then '<12-24]'
when MOB>24 then '<24-mas]'
else null end,
uso


alter table #desaf
ADD Tipo NVARCHAR (20) NOT NULL
CONSTRAINT CONSTRAINTN DEFAULT 'Desafiliaciones'
WITH VALUES  


insert into gdc..tbl_dinamica_planta
select * 
from #desaf


-- PERMANECEN



drop table #tbl_permanencia
select
Periodo,
Producto,
AgrupacionGiros,
Comerciostemporales,
Limaprovincias, 
Movimiento, 
Estado,
MOI_ANTERIOR, 
Habafil,
Habdesf, 
Segmento_, 
Subsegmento_, 
Estadohabilitado, 
CASE 
WHEN Producto ='CE' THEN(
CASE WHEN SubProducto IN('PW : POS WEB') THEN 'PAGO_LINK'
WHEN SubProducto IN('PT : PST','CD : DIRECTO','FP : PSP') THEN 'PAGO_WEB'
WHEN SubProducto IN('CM : CMS') THEN 'Tu_Vitrina'
WHEN SubProducto IN('AP : APP') THEN 'Pago_APP' 
WHEN SubProducto IN('QE : QR ESTATICO','QR') THEN 'QR' ELSE 'OTROS' END)  
ELSE Producto END SUB_PRODUCTO,
case
when MOB>=0 and MOB<=2 then '[0-2]'
when MOB>2 and MOB<=12 then '<2-12]'
when MOB>12 and MOB<=24 then '<12-24]'
when MOB>24 then '<24-mas]'
else null end R_MOB,
uso,
COUNT(*) COMERCIOS,
SUM(TXN) TXN,
SUM(VOL) VOL
into #tbl_permanencia
from #perm
GROUP BY 
Periodo,
Producto,
AgrupacionGiros,
Comerciostemporales,
Limaprovincias, 
Movimiento, 
Estado,
MOI_ANTERIOR, 
Habafil,
Habdesf, 
Segmento_, 
Subsegmento_, 
Estadohabilitado, 
CASE 
WHEN Producto ='CE' THEN(
CASE WHEN SubProducto IN('PW : POS WEB') THEN 'PAGO_LINK'
WHEN SubProducto IN('PT : PST','CD : DIRECTO','FP : PSP') THEN 'PAGO_WEB'
WHEN SubProducto IN('CM : CMS') THEN 'Tu_Vitrina'
WHEN SubProducto IN('AP : APP') THEN 'Pago_APP' 
WHEN SubProducto IN('QE : QR ESTATICO','QR') THEN 'QR' ELSE 'OTROS' END)  
ELSE Producto END,
case
when MOB>=0 and MOB<=2 then '[0-2]'
when MOB>2 and MOB<=12 then '<2-12]'
when MOB>12 and MOB<=24 then '<12-24]'
when MOB>24 then '<24-mas]'
else null end,
uso  


alter table #tbl_permanencia
ADD Tipo NVARCHAR (20) NOT NULL
CONSTRAINT CONSTRAME DEFAULT 'Permanecen'
WITH VALUES  


insert into gdc..tbl_dinamica_planta
select * 
from #tbl_permanencia



-- REACTIACIONES T. 



drop table #reactitemp
select 
Periodo,
Producto,
AgrupacionGiros,
Comerciostemporales,
Limaprovincias, 
Movimiento, 
Estado,
MOI_ANTERIOR, 
Habafil,
Habdesf, 
Segmento_, 
Subsegmento_, 
Estadohabilitado, 
CASE 
WHEN Producto ='CE' THEN(
CASE WHEN SubProducto IN('PW : POS WEB') THEN 'PAGO_LINK'
WHEN SubProducto IN('PT : PST','CD : DIRECTO','FP : PSP') THEN 'PAGO_WEB'
WHEN SubProducto IN('CM : CMS') THEN 'Tu_Vitrina'
WHEN SubProducto IN('AP : APP') THEN 'Pago_APP' 
WHEN SubProducto IN('QE : QR ESTATICO','QR') THEN 'QR' ELSE 'OTROS' END)  
ELSE Producto END SUB_PRODUCTO,
case
when MOB>=0 and MOB<=2 then '[0-2]'
when MOB>2 and MOB<=12 then '<2-12]'
when MOB>12 and MOB<=24 then '<12-24]'
when MOB>24 then '<24-mas]'
else null end R_MOB,
uso,
COUNT(*) COMERCIOS,
SUM(TXN) TXN,
SUM(VOL) VOL
into #reactitemp
from #react_temp
GROUP BY 
Periodo,
Producto,
AgrupacionGiros,
Comerciostemporales,
Limaprovincias, 
Movimiento, 
Estado,
MOI_ANTERIOR, 
Habafil,
Habdesf, 
Segmento_, 
Subsegmento_, 
Estadohabilitado, 
CASE 
WHEN Producto ='CE' THEN(
CASE WHEN SubProducto IN('PW : POS WEB') THEN 'PAGO_LINK'
WHEN SubProducto IN('PT : PST','CD : DIRECTO','FP : PSP') THEN 'PAGO_WEB'
WHEN SubProducto IN('CM : CMS') THEN 'Tu_Vitrina'
WHEN SubProducto IN('AP : APP') THEN 'Pago_APP' 
WHEN SubProducto IN('QE : QR ESTATICO','QR') THEN 'QR' ELSE 'OTROS' END)  
ELSE Producto END ,
case
when MOB>=0 and MOB<=2 then '[0-2]'
when MOB>2 and MOB<=12 then '<2-12]'
when MOB>12 and MOB<=24 then '<12-24]'
when MOB>24 then '<24-mas]'
else null end ,
uso  



alter table #reactitemp
ADD Tipo NVARCHAR (20) NOT NULL
CONSTRAINT CONSTRAINTE DEFAULT 'Reactivacion T.'
WITH VALUES  


insert into gdc..tbl_dinamica_planta
select * 
from #reactitemp


-- select sum (comercios) from #afiliaciones
-- select sum (comercios) from #desaf
-- select sum (comercios) from #tbl_permanencia
-- select sum (comercios) from #reactitemp


-- INSERTAR DATOS DE REACTIVACIONES / PLANTA INICIAL


 insert into gdc..tbl_dinamica_planta select * from gdc..tbl_reactivaciones where periodo = @periodo2 and tipo in ('Reactivaciones','Planta I')



 -- CONVERTIR EL SIGNO DE DESAFILIACIONES EN NEGATIVO

update gdc..tbl_dinamica_planta set comercios = comercios * -1 where tipo = 'Desafiliaciones' and Periodo <= @periodo1

update gdc..tbl_dinamica_planta set comercios = comercios * -1 where tipo = 'Desafiliaciones'

 -- select * from gdc..tbl_dinamica_planta where tipo = 'Desafiliaciones'


 -- Validaciones 

	--select * 
	--from gdc..tbl_dinamica_planta 
	--where Tipo = 'Desafiliaciones'
	
	--select periodo, Tipo, SUM (COMERCIOS) from gdc..tbl_dinamica_planta group by Periodo, Tipo order by Periodo desc
