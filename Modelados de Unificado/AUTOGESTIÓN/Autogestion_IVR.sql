declare @ano float
set @ano = 2023

declare @mes float
set @mes = 04


-- crear tabla temporal

drop table #tab1
select *
into #tab1
from ivr_abril
where YEAR(FechaID) = @ano
and MONTH(FechaID) = @mes


-- crear tabla final



drop table #tab2
select a.*,
	   SUBSTRING(CAST(FechaID as varchar),1,4) as Ano,
	   SUBSTRING(CAST(FechaID as varchar),6,2) as Mes
into #tab2
from #tab1 as a
where CodigoIVR like '%M_1_CodMas_2%' or codigoivr like '%M_1_CodCEL_2%' or codigoivr like '%M_1_CodMas_3_1%' or codigoivr like '%M_1_CodMas_3_2%'


drop table #tab3
select a.*,
	   SUBSTRING(CAST(FechaID as varchar),1,4) as Ano,
	   SUBSTRING(CAST(FechaID as varchar),6,2) as Mes
into #tab3
from #tab1 as a
where CodigoIVR like ('%M_1_CodMas_4_Ticket_%')



drop table #tab4
select a.*,
	   SUBSTRING(CAST(FechaID as varchar),1,4) as Ano,
	   SUBSTRING(CAST(FechaID as varchar),6,2) as Mes
into #tab4
from #tab1 as a
where CodigoIVR like '0110 M_2_Afiliacion_1_Pedido_%'



drop table #tab5
select *
into #tab5
from
(
select * from #tab2
union all
select * from #tab3
union all
select * from #tab4
) as query



insert into gdc..tbl_AUTOGESTION_IVR_final
select a.*,
       (cast(Ano as varchar) + cast(Mes as varchar)) as Periodo
from #tab5 as a


	-- select * from gdc..tbl_AUTOGESTION_IVR_final


