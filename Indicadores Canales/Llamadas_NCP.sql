--Insertar data del dia anterior en el presente mes
--select top 1 * from gdc..ll_ncp

----delete from ll_ncp where month(fecha_hora)=12
--select count(*) from  ll_ncp where month(fecha_hora)=12

----select max(fecha_hora) from ll_ncp

--Agregar periodo
Use Gdc;

drop table #tab0
select * ,DATEADD(HH,-1,Fecha_Hora) as fechap
into #tab0
from ll_ncp

drop table #tab01

select *,
case when Id_Campaña=100000005 and DATEPART(DW,fechap) <=5 and DATEPART(HH,fechap)<8 then 0
     when Id_Campaña=100000010 and DATEPART(DW,fechap) <=5 and DATEPART(HH,fechap)<8 then 0
	 else 1
	 end as rango
into #tab01
from #tab0


drop table #tab1
select a.*,
       MONTH(fechap) as Month,
	   YEAR(fechap) as Year
into #tab1
from #tab01 as a


drop table #tab2
select a.*,
       cast(Month as varchar) as N_Month,
       case when Month <= 9 then '0'
	   else '1'
	   end as Flg_Month
into #tab2
from #tab1 as a


drop table #tab3
select a.*,
       case when Flg_Month = 0 then Flg_Month + N_Month
	   else cast(Month as varchar)
	   end as F_Month
into #tab3
from #tab2 as a

-- Agregar filtros Niubiz
drop table #tab4
select a.*,
       (cast(Year as varchar) + F_Month) as Periodo,
	   isnull(b.unidadnegocio,'Sin UN') as UN,
	   isnull(b.Segmento,'Sin Segmento') as Segmento,
	   isnull(b.ClusterGrupo,'Sin Cluster') as Cluster
into #tab4
from #tab3 as a
left join [Visanet Planeamiento]..V_Segmento_Cliente as b on a.NRUC = b.ruc


update #tab4
set Cluster = 'Sin Cluster'
where Cluster = ''


drop table #tab5
select a.*,
       convert(varchar,Fechap, 23) as Fecha
into #tab5
from #tab4 as a



drop table #tab6
select a.*,
       convert(varchar,Fecha, 23) as N_Fecha
into #tab6
from gdc..ncp_llamadas_previstas as a


drop table #tab7
select a.*,
       case when Id_Campaña = 100000005 then 'POS Físico'
	        when Id_Campaña = 100000010 then 'Partner de Red'
			else 'Pool Online Virtual'
	    end as Campaña
into #tab7
from #tab5 as a

--select distinct Campaña
--from #tab6





drop table #tab9
select a.*,
       isnull(b.llamadas_previstas, 0) as LL_Previstas,
	   isnull(b.horas_previstas, 0) as H_Previstas
into #tab9
from #tab7 as a
left join #tab6 as b on a.Fecha = b.N_Fecha and a.Campaña = b.Campaña



drop table #tab10
select a.*,
      case when Descripción='Abandonada' then 0
	       when Descripción='Error CTI' then 0
		   when Descripción='Otras causas' then 0
		   else 1
          end as LL_Atendida,

      case when Descripción='Abandonada' then 1
	       when Descripción='Error CTI' then 1
		   when Descripción='Otras causas' then 1
		   else 0
          end as LL_Abandonada
into #tab10
from #tab9 as a

drop table #tab11
select a.*, 
case when LL_Abandonada=1 and (datepart(n,Tiempo_Cola)*60 +datepart(s,Tiempo_Cola))<=20  then 1
else 0
end as LL_AbandonadaU
into #tab11
from #tab10 as a

drop table #tab12
select * , case when orig = '' then 0
else 1
end as LL_recibida
into #tab12 from #tab11 


drop table #tab13
select a.*, 
case when LL_Atendida=1 and (datepart(n,Tiempo_Cola)*60 +datepart(s,Tiempo_Cola))<20  then 1
else 0
end as LL_AtendidaU
into #tab13
from #tab12 as a

drop table #tab14
select a.*, 
datepart(n,agt)*60 +datepart(s,agt)+datepart(hh,agt)*3600 as TMO
into #tab14
from #tab13 as a



drop table #tab15
select a.*,b.[Modelo_online]
into #tab15
from #tab14 as a
left join tbl_modelo_atencion_online_ncp as b on a.NCOMERCIO=b.CodigoComercio 



update #tab15
set Modelo_online = null
where Campaña not like  '%Online%'

update #tab15
set Modelo_online = 'Masivo'
where Campaña  like  '%Online%' and Modelo_online is null



drop table gdc..ncp_llamadas_unif
select * 
into ncp_llamadas_unif
from #tab15

delete from gdc..Ncp_llamadas_unif
where id_transacción in (100164029, 100164030, 100164031, 100169293, 100170202,100187182,100187179,100187165,100187164,100187158,100187146,100187138,100187134,100187237,100187241,100187243,100190255,100193197,100193198,100193201,100193209,100194133,100194135)

delete from gdc..Ncp_llamadas_unif
where LL_AbandonadaU = 1

delete from gdc..Ncp_llamadas_unif
where Orig is null


--select * from ncp_llamadas_unif where periodo=202211

--select Campaña,Periodo,count(*)
--from ncp_llamadas_unif 
--where rango=1
--and LL_recibida=1
--group by Periodo ,Campaña order by periodo asc


