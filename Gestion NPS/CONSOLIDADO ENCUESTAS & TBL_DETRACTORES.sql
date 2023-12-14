
declare @periodo float
set @periodo =202311


-- 1. Modelado de COMDATA


drop table #tab_COMDATA_CP
select Periodo, unidadnegocio, segmento, clustergrupo, Grupo_Valor_F, Respuesta1 as NPS, Respuesta2 as SAT, Respuesta3 as SOL, Respuesta4 as CES,
	   RUC_F as RUC,
       case when Programa = 'Afiliaciones' then 'AFILIACIONES-CALL'
	        when Programa = 'C2C Corporativo' then 'C2C CORPORATIVO-CALL'
			when Programa = 'C2C Vendemas' then 'C2C VENDEMAS-CALL'
			when Programa = 'WHATSAPP' then 'WHATSAPP-CALL'
			when Programa = 'VENDEMAS' then 'VENDEMAS-CALL'
			when Programa='Emprendedor' then 'EMPRENDEDOR-CALL'
			else Programa
	   end as Gestion_Final

into #tab_COMDATA_CP
from gdc..tbl_CP_COMDATA_final
where periodo = @periodo



-- AGREGAR PROVEEDOR

alter table #tab_COMDATA_CP
add Proveedor varchar(50)

update #tab_COMDATA_CP
set Proveedor = 'COMDATA'
where Proveedor is null




-- 2. Modelado de NECOMPLUS

select * from gdc..ncp_encu_unif


drop table #tab_ID
select distinct Periodo, trasaction
into #tab_ID
from gdc..ncp_encu_unif
where periodo = @periodo
and tipo_encuesta = 'encuesta completa'


drop table #tab_nps
select trasaction, VALUE_SURVEY
into #tab_nps
from gdc..ncp_encu_unif
where periodo = @periodo
and tipo_encuesta = 'encuesta completa'
and RUTA_LOCUCION like '%NPS%'

drop table #tab_sat
select trasaction, VALUE_SURVEY
into #tab_sat
from gdc..ncp_encu_unif
where periodo = @periodo
and tipo_encuesta = 'encuesta completa'
and RUTA_LOCUCION like '%SAT%'


drop table #tab_sol
select trasaction, VALUE_SURVEY
into #tab_sol
from gdc..ncp_encu_unif
where periodo = @periodo
and tipo_encuesta = 'encuesta completa'
and RUTA_LOCUCION like '%sol%'


drop table #tab_ces
select trasaction, VALUE_SURVEY
into #tab_ces
from gdc..ncp_encu_unif
where periodo = @periodo
and tipo_encuesta = 'encuesta completa'
and RUTA_LOCUCION like '%ces%'


drop table #tbl_NCP_CP_1
select a.*, b.VALUE_SURVEY as NPS,
       d.VALUE_SURVEY as SAT,
	   e.VALUE_SURVEY as SOL,
	   r.VALUE_SURVEY as CES
intO #tbl_NCP_CP_1
from #tab_ID as a
left join #tab_nps as b on a.TRASACTION = b.TRASACTION
left join #tab_sat as d on a.TRASACTION = d.TRASACTION
left join #tab_sol as e on a.TRASACTION = e.TRASACTION
left join #tab_ces as r on a.TRASACTION = r.TRASACTION



drop table #tbl_NCP_CP_2
select a.*, b.NRUC, UN as unidadnegocio, Segmento, Cluster as clustergrupo
into #tbl_NCP_CP_2
from #tbl_NCP_CP_1 as a
left join gdc..ncp_llamadas_unif as b on a.TRASACTION = b.Id_Transacción


drop table #tbl_NCP_CP_3
select a.*, ROW_NUMBER() over (partition by TRASACTION order by Periodo) orden_1
into #tbl_NCP_CP_3
from gdc..ncp_encu_unif as a
where periodo = @periodo
and tipo_encuesta = 'encuesta completa'


delete from #tbl_NCP_CP_3
where orden_1 > 1


drop table #tbl_NCP_CP_4
select a.*, Grupo_Valor, CampañaN
into #tbl_NCP_CP_4
from #tbl_NCP_CP_2 as a
left join #tbl_NCP_CP_3 as b on a.TRASACTION = b.TRASACTION



drop table #tab_NECOMPLUS_CP
select Periodo, unidadnegocio, Segmento, clustergrupo, Grupo_Valor as Grupo_Valor_F, NPS, SAT, SOL, CES, NRUC as RUC,
       CampañaN as Gestion_Final
into #tab_NECOMPLUS_CP
from #tbl_NCP_CP_4




-- AGREGAR PROVEEDOR

alter table #tab_NECOMPLUS_CP
add Proveedor varchar(50)

update #tab_NECOMPLUS_CP
set Proveedor = 'NECOMPLUS'
where Proveedor is null



-- 3. Modelado de SISCARD


drop table #tab_SISCARD_CP
select Periodo, unidadnegocio, Segmento as segmento, ClusterGrupo, Cuadrante_No_Aislado as Grupo_Valor_F,
       NPS, SAT, SOL, CES, RUC

into #tab_SISCARD_CP
from gdc..tbl_CP_SISCARD_final
where cast(periodo as float) = @periodo


-- AGREGAR GESTION_FINAL

alter table #tab_SISCARD_CP
add Gestion_Final varchar(50)

update #tab_SISCARD_CP
set Gestion_Final = 'CALL TECNICO'
where gestion_final is null


-- AGREGAR PROVEEDOR

alter table #tab_SISCARD_CP
add Proveedor varchar(50)

update #tab_SISCARD_CP
set Proveedor = 'SISCARD'
where Proveedor is null




-- Modelado de WHATSAPP COMDATA

drop table #tab_WHATSAPP_COMDATA_CP
select Periodo, unidadnegocio, Segmento, ClusterGrupo, Grupo_Valor_F, NPS, SAT_1, SOL_1, CES_1, DNI_RUC as RUC, Campaña as Gestion_Final
into #tab_WHATSAPP_COMDATA_CP
from gdc..tbl_whatsapp_CP_final
where Periodo = @periodo


alter table #tab_WHATSAPP_COMDATA_CP
add Proveedor varchar(50)

-- AGREGAR PROVEEDOR

update #tab_WHATSAPP_COMDATA_CP
set Proveedor = 'COMDATA'
where Proveedor is null


update #tab_WHATSAPP_COMDATA_CP
set Gestion_Final = 'WHATSAPP-CALL'
where Gestion_Final is null



-- Modelado de VENDEMAS COMDATA

drop table #tab_VENDEMAS_COMDATA_CP_INICIAL
select Periodo, unidadnegocio, segmento, cluster as clustergrupo, Grupo_Valor_F, NPS, SATISFACCIÓN as SAT,
       SOLUCIÓN as SOL, CES, CAMPAÑA as Gestion_Final
into #tab_VENDEMAS_COMDATA_CP_INICIAL
from gdc..tbl_vendemas_CP_final
where periodo = @periodo


alter table #tab_VENDEMAS_COMDATA_CP_INICIAL
add RUC float

drop table #tab_VENDEMAS_COMDATA_CP
select Periodo, unidadnegocio, segmento, clustergrupo, Grupo_Valor_F, NPS, SAT, SOL, CES, 
       RUC, Gestion_Final
into #tab_VENDEMAS_COMDATA_CP
from #tab_VENDEMAS_COMDATA_CP_INICIAL as a

alter table #tab_VENDEMAS_COMDATA_CP
add Proveedor varchar(50)

update #tab_VENDEMAS_COMDATA_CP
set Proveedor = 'COMDATA'
where Proveedor is null


update #tab_VENDEMAS_COMDATA_CP
set Gestion_Final = 'VENDEMAS-CALL'
where Gestion_Final is null




-- Modelado de CONSOLIDADO DIGITALES (HOTJAR, HOWUKU, SM )



drop table #tab_CONSOLIDADO_DIGITALES_CP_SIN_NEL
select Periodo, unidadnegocio, segmento, clustergrupo, Grupo_Valor_F, NPS, SAT, SOL, CES, RUC, Campaña as Gestion_Final, Proveedor
into #tab_CONSOLIDADO_DIGITALES_CP_SIN_NEL
from gdc..tbl_CONSOLIDADO_DIGITALES_CP_final 
where campaña <> 'NEL'
and periodo = @periodo


drop table #tab_CONSOLIDADO_DIGITALES_CP_CON_NEL
select Periodo, unidadnegocio, segmento, clustergrupo, Grupo_Valor_F, NPS, SAT, SOL, CES, RUC, Campaña as Gestion_Final, Proveedor
into #tab_CONSOLIDADO_DIGITALES_CP_CON_NEL
from gdc..tbl_CONSOLIDADO_DIGITALES_CP_final 
where campaña = 'NEL'
and periodo = @periodo


drop table #tab_CONSOLIDADO_DIGITALES_CP
select *
into #tab_CONSOLIDADO_DIGITALES_CP
from
(
select * from #tab_CONSOLIDADO_DIGITALES_CP_SIN_NEL

union all

select * from #tab_CONSOLIDADO_DIGITALES_CP_CON_NEL
) as subquery


--Agregar Chatbot

--drop table #tab_chatbot
--select periodo,unidadnegocio,SEGMENTO,clustergrupo,grupo_valor_f,NPS,SAT,SOL,ces,ruc,gestion_final,proveedor
--into #tab_chatbot
--from Gdc..tbl_chatbot_cp



-- Consolidar COMDATA, NECOMPLUS, SISCARD, HOTJAR, HOWUKU, SM


drop table #tab_CONSOLIDAD_PROVEEDORES_CP
select *
into #tab_CONSOLIDAD_PROVEEDORES_CP
from (

select * from #tab_COMDATA_CP

union all 

select * from #tab_NECOMPLUS_CP

union all

select * from #tab_SISCARD_CP

union all 

select * from #tab_WHATSAPP_COMDATA_CP

union all

select * from #tab_VENDEMAS_COMDATA_CP

union all

select * from #tab_CONSOLIDADO_DIGITALES_CP

union all

--select * from #tab_chatbot

) as subquery 





-- select * from #tab_CONSOLIDAD_PROVEEDORES_CP





drop table #tab_CONSOLIDAD_PROVEEDORES_CP_F
select a.*, cast(Gestion_Final as varchar) as Gestion_Final_1
into #tab_CONSOLIDAD_PROVEEDORES_CP_F
from #tab_CONSOLIDAD_PROVEEDORES_CP as a


-- select * from #tab_CONSOLIDAD_PROVEEDORES_CP_F

--select distinct proveedor from #tab_CONSOLIDAD_PROVEEDORES_CP_F
--select distinct Gestion_Final_1 from #tab_CONSOLIDAD_PROVEEDORES_CP_F
--select count (*) as q from #tab_CONSOLIDAD_PROVEEDORES_CP_F where Gestion_Final_1 is null
--select count (*) as q from #tab_CONSOLIDAD_PROVEEDORES_CP_F where proveedor is null


drop table #tab_FLAG_NPS_1
select a.*,
       case when cast(NPS as float) in (9,8) then 'Promotores'
	        when cast(NPS as float) in (7,6) then 'Neutros'
			when cast(NPS as float) in (5,4,3,2,1,0) then 'Detractores'
			when NPS is null then 'Sin Respuesta'
			else 'Sin Respuesta'
	   end as FLAG_NPS,
	   case when Gestion_Final_1 like '%Afiliaciones%' then 'Propuesta de Valor'
	        when Gestion_Final_1  like '%C2C%' then 'Propuesta de Valor'
			else 'Postventa'
       end as Dimension
into #tab_FLAG_NPS_1
from #tab_CONSOLIDAD_PROVEEDORES_CP_F as a
where proveedor in ('COMDATA', 'SISCARD', 'NECOMPLUS') 
and Gestion_Final_1 not in ('WHATSAPP-CALL')
-- order by NPS desc


drop table #tab_FLAG_NPS_2
select a.*,
       case when cast(NPS as float) in (10,9) then 'Promotores'
	        when cast(NPS as float) in (8,7) then 'Neutros'
			when cast(NPS as float) in (6,5,4,3,2,1,0) then 'Detractores'
			when NPS is null then 'Sin Respuesta'
			else 'Sin Respuesta'
	   end as FLAG_NPS,
     case when Gestion_Final_1 like '%Afiliaciones%' then 'Propuesta de Valor'
	      when Gestion_Final_1  like '%C2C%' then 'Propuesta de Valor'
		  else 'Postventa'
       end as Dimension
into #tab_FLAG_NPS_2
from #tab_CONSOLIDAD_PROVEEDORES_CP_F as a
where proveedor in ('COMDATA', 'SISCARD', 'NECOMPLUS','chat-bot') 
and Gestion_Final_1 in ('WHATSAPP-CALL','chatbot')
-- order by NPS desc

SELECT * FROM #tab_FLAG_NPS_2

drop table #tab_FLAG_NPS_3
select a.*,
       case when cast(NPS as float) in (10,9) then 'Promotores'
	        when cast(NPS as float) in (8,7) then 'Neutros'
			when cast(NPS as float) in (6,5,4,3,2,1,0) then 'Detractores'
			when NPS is null then 'Sin Respuesta'
			else 'Sin Respuesta'
	   end as FLAG_NPS,
	   case when Gestion_Final_1 = 'ECOMMERCE VENDEMAS' then 'Propuesta de Valor'
	        when Gestion_Final_1 ='INTEGRACIONES' then 'Propuesta de Valor'
			else 'Experiencia de Uso'
       end as Dimension
into #tab_FLAG_NPS_3
from #tab_CONSOLIDAD_PROVEEDORES_CP_F as a
where proveedor not in ('COMDATA', 'SISCARD', 'NECOMPLUS','chat-bot') 
-- order by NPS desc



---- volver a consolidar la tabla pero con la marca de NPS

drop table #tab_CONSOLIDAD_PROVEEDORES_CP_1
select *
into #tab_CONSOLIDAD_PROVEEDORES_CP_1
from (

select * from #tab_FLAG_NPS_1

union all

select * from #tab_FLAG_NPS_2

union all

select * from #tab_FLAG_NPS_3

) as subquery



-- Base de encuestas consolidada


insert into gdc..tbl_ENCUESTAS_CONSOLIDADAS_final
select * 
from #tab_CONSOLIDAD_PROVEEDORES_CP_1


		--  select * from gdc..tbl_ENCUESTAS_CONSOLIDADAS_final where periodo = (select max(periodo) from gdc..tbl_ENCUESTAS_CONSOLIDADAS_final)




--  Consolidacion de base de detractores

drop table #tab_CONSOLIDAD_PROVEEDORES_CP_2
select * 
into #tab_CONSOLIDAD_PROVEEDORES_CP_2
from #tab_CONSOLIDAD_PROVEEDORES_CP_1 
where unidadnegocio is not null 
and NPS is not null
and FLAG_NPS = 'detractores'






use [Visanet Planeamiento]




-- Q Desafiliaciones 2022




drop table #tab_desafiliacion_1
select *
into #tab_desafiliacion_1
from comercial.Desafiliacion
where Periodo >= 202201
and SubTipo = 'VOLUNTARIAS'



drop table #tab_desafiliacion_2
select a.*, b.RUC
into #tab_desafiliacion_2
from #tab_desafiliacion_1 as a
left join comercial.BaseComercios as b on a.Codigo = b.CODIGO



drop table #tab_desafiliacion_3
select RUC, count (*) as Q_Desaf_Voluntarias
into #tab_desafiliacion_3
from #tab_desafiliacion_2
group by RUC






-- Vol Desafiliaciones 2022


drop table #tab_vol_desaf
select a.Periodo, a.Codigo, a.RUC, a.Vol
into #tab_vol_desaf
from comercial.stock as a
where Periodo >= 202201
and codigo in (select codigo from #tab_desafiliacion_1)



drop table #tab_vol_desaf_1
select ruc, sum(Vol) as Vol_Desaf
into #tab_vol_desaf_1
from #tab_vol_desaf
group by RUC




-- consolidacion de vista de detractores


--delete from gdc..tbl_GESTION_DETRACTORES_final
--where Periodo = (select MAX(Periodo) from #tab_CONSOLIDAD_PROVEEDORES_CP_2)


insert into gdc..tbl_GESTION_DETRACTORES_final
select a.Periodo,a.unidadnegocio,a.segmento,a.clustergrupo,a.Grupo_Valor_F,a.NPS,a.SAT,a.SOL,a.CES,a.RUC,a.Gestion_Final,a.proveedor,Gestion_Final_1,a.FLAG_NPS
,isnull(b.Q_Desaf_Voluntarias,0) as Q_Desaf_Voluntarias, isnull(d.Vol_Desaf,0) as Vol_Desaf, f.RAZONSOCIA
from #tab_CONSOLIDAD_PROVEEDORES_CP_2 as a
left join #tab_desafiliacion_3 as b on a.RUC = b.RUC
left join #tab_vol_desaf_1 as d on a.RUC = d.Ruc
left join (select ruc, RAZONSOCIA, count(*) as Q_Cod from Comercial.BaseComercios group by ruc, RAZONSOCIA) as f on a.RUC = f.RUC


--select *
--from gdc..tbl_GESTION_DETRACTORES_final
--where unidadnegocio = 'masivo'
--and grupo_valor_f is null

--select *
--from gdc..tbl_GESTION_DETRACTORES_final
--where unidadnegocio = 'corporativo'
--and grupo_valor_f is null



update gdc..tbl_GESTION_DETRACTORES_final
set clustergrupo = 'Sin Cluster'
where clustergrupo is null

update gdc..tbl_GESTION_DETRACTORES_final
set clustergrupo = 'Sin Cluster'
where clustergrupo = ''


update gdc..tbl_GESTION_DETRACTORES_final
set grupo_valor_f = '[Masivo : G4]'
where unidadnegocio = 'masivo'
and grupo_valor_f is null

update gdc..tbl_GESTION_DETRACTORES_final
set grupo_valor_f  = '[Corporativo : G4]'
where unidadnegocio = 'corporativo'
and grupo_valor_f is null

