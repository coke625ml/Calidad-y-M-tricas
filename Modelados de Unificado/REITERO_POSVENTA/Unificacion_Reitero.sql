

alter table gdc..tbl_reitero_niubiz_pbi
add Gestion varchar(100)

update gdc..tbl_reitero_niubiz_pbi
set Gestion = 'Niubiz'
where Gestion is null


alter table gdc..tbl_reitero_vendemas_pbi
add Gestion varchar(100)

update gdc..tbl_reitero_vendemas_pbi
set Gestion = 'Vendemas'
where Gestion is null



drop table gdc..tbl_reitero_unificado_pbi
select *
into gdc..tbl_reitero_unificado_pbi
from
(

select *
from gdc..tbl_reitero_niubiz_pbi

union all

select *
from gdc..tbl_reitero_vendemas_pbi

) as subquery




--select periodo, pool, sum(q_cod_unicos_reitero) as q_cod_unicos_reitero, sum(q_cod_unicos) as q_cod_unicos
--from gdc..tbl_reitero_unificado_pbi
--where gestion = 'niubiz'
--and pool = 'pool corporativo'
--group by periodo, pool
--order by periodo asc



--select distinct n_llave
--from gdc..tbl_reitero_unificado_pbi