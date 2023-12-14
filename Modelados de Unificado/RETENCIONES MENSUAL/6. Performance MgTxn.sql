--create table gdc..tbl_retorno_retenciones_inicial (
--cosecha int,
--Codigo int,
--Retenido_No_Retenido varchar(100),
--Unidad_de_negocio varchar(100),
--Pool_Funcionario  varchar(100),
--orden int,
--mgtxn_m0 float,
--mgtxn_m1 float,	
--mgtxn_m2 float,
--mgtxn_m3 float,
--mgtxn_m4 float,
--mgtxn_m5 float
--)


select * from gdc..tbl_retorno_retenciones_inicial



-- agregar grupo de valor

drop table #tab1
select a.*, b.ruc
into #tab1
from gdc..tbl_retorno_retenciones_inicial as a
left join comercial.basecomercios as b on a.codigo = b.codigo


drop table #tab2
select a.*, b.Segmento, d.cuadrante_aislado
into #tab2
from #tab1 as a
left join V_Segmento_Cliente as b on a.RUC = b.Ruc
left join gdc..tbl_GV as d on a.ruc = d.ruc


update #tab2
set Cuadrante_Aislado = '[Masivo : G4]'
where Cuadrante_Aislado is null
and Unidad_de_negocio = 'Masivo'

update #tab2
set Cuadrante_Aislado = '[Corporativo : G4]'
where Cuadrante_Aislado is null
and Segmento in ('Ligero TOP', 'Tradicional')

update #tab2
set Cuadrante_Aislado = '[Corporativo : G4]'
where Cuadrante_Aislado is null
and Segmento in ('TOP', 'Gobierno', 'Gran Cadena')


drop table gdc..tbl_retorno_retenciones_final
select *
into gdc..tbl_retorno_retenciones_final
from #tab2



--select *
--from gdc..tbl_retorno_retenciones_final
--where Unidad_de_negocio = 'masivo'
--and Cuadrante_Aislado like '%corporativo%'


--update gdc..tbl_retorno_retenciones_final
--set Cuadrante_Aislado = '[Masivo : G4]'
--where Unidad_de_negocio = 'masivo'
--and Cuadrante_Aislado like '%corporativo%'