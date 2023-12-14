--delete from e_ncp where month(fecha_survey)=1 and year(fecha_survey)=2023

--select max(fecha_survey) from e_ncp
--select count(*) from e_ncp where month(fecha_survey)=1 and year(fecha_survey)=2023


drop table #tab1


select a.*,
      case when RUTA_LOCUCION like '%nps%' and VALUE_SURVEY>7 then 1
	       when RUTA_LOCUCION like '%nps%' and VALUE_SURVEY<6 then -1
	  else 0
	  end as NPS,
	        case when RUTA_LOCUCION like '%satisfaccion%' and VALUE_SURVEY >3 then 1
	  else 0
	  end as SAT,

	        case when RUTA_LOCUCION like '%solucion%' and VALUE_SURVEY=1 then 1
	  else 0
	  end as SOL,
            case when RUTA_LOCUCION like '%ces%' and VALUE_SURVEY >3 then 1
	  else 0
	  end as CES

into #tab1
from gdc..e_ncp as a

--hemos usado tabla 2 orden_1 es x pero divimos usar #tab1


drop table #tab3

select a.*,
case when ruta_locucion like '%bienvenida%' then 1 
     when ruta_locucion like '%gracias%' then 1 
	 else 0
	 end as flg_locucion
into #tab3
from #tab1 as a
 



delete from #tab3 where flg_locucion=1

drop table #tab4
select trasaction, count(*) as q_respuestas into #tab4 from #tab3 group by trasaction


drop table #tab5
select a.*, b.q_respuestas into #tab5 from #tab3 as a left join #tab4 as b on  a.trasaction=b.trasaction

drop table #tab6
select a.*,
case when q_respuestas=4 and FECHA_SURVEY<'2022-07-01' then 'encuesta completa'
     when q_respuestas>=2 and FECHA_SURVEY>='2022-07-01' then 'encuesta completa'
	 else 'encuesta incompleta' 
end as tipo_encuesta 
into #tab6
from #tab5 as a


drop table #tab7
select a.*,
       MONTH(FECHA_SURVEY) as Month,
	   YEAR(FECHA_SURVEY) as Year
into #tab7
from #tab6 as a


drop table #tab8
select a.*,
       cast(Month as varchar) as N_Month,
       case when Month <= 9 then '0'
	   else '1'
	   end as Flg_Month
into #tab8
from #tab7 as a


drop table #tab9
select a.*,
       case when Flg_Month = 0 then Flg_Month + N_Month
	   else cast(Month as varchar)
	   end as F_Month
into #tab9
from #tab8 as a


drop table #tab10
select a.*,
       (cast(Year as varchar) + F_Month) as Periodo
into #tab10
from #tab9 as a


drop table #tab11
select a.* ,
case when CAMPAÑA like '%Online%' then 'Pool Online Virtual'
     when CAMPAÑA like '%Fisico%' then 'POS Fisico'
	 when CAMPAÑA like '%Partner%' then 'Partner de Red'
	 end as CampañaN
	 into #tab11 
	 from #tab10 as a 



drop table #tab12
select a.*, b.NCOMERCIO, b.NRUC, b.UN, b.Segmento, b.Cluster
into #tab12
from #tab11 as a
left join gdc..ncp_llamadas_unif as b on a.TRASACTION = b.Id_Transacción



drop table #tab13
select a.*, b.Cuadrante_Aislado as Grupo_Valor
into #tab13
from #tab12 as a
left join gdc..tbl_GV as b on a.NRUC = b.ruc


drop table gdc..ncp_encu_unif
select *
into gdc..ncp_encu_unif
from #tab13


--select * from ncp_encu_unif where q_respuestas>4
--select max(periodo) from ncp_encu_unif
--select * from ncp_encu_unif where periodo=202212
--select max(fecha_survey) from ncp_encu_unif