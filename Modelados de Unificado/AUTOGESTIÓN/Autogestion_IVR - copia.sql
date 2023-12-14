

-- crear tabla temporal

drop table #tab1
select *
into #tab1
from gdc..tbl_AUTOGESTION_IVR_inicial


-- crear tabla final



drop table #tab2
select a.*,
	   SUBSTRING(CAST(FechaID as varchar),1,4) as Ano,
	   SUBSTRING(CAST(FechaID as varchar),6,2) as Mes
into #tab2
from #tab1 as a
where CodigoIVR in ('0123 M_1_CodMas_2', '0131 M_1_CodCEL_2', '0128 M_1_CodMas_3_1', '0129 M_1_CodMas_3_2', '0095 M_1_CodMas_4_Ticket_', '0110 M_2_Afiliacion_1_Pedido_')
or CodigoIVR  like '0095 M_1_CodMas_4_Ticket_%' 
or codigoivr like '0110 M_2_Afiliacion_1_Pedido_%' 

drop table gdc..tbl_AUTOGESTION_IVR_final
select a.*,
       (cast(Ano as varchar) + cast(Mes as varchar)) as Periodo
into gdc..tbl_AUTOGESTION_IVR_final
from #tab2 as a

select distinct CodigoIVR from #tab1