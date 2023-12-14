
--select count (*) as q from gdc..tbl_CONSOLIDADO_DIGITALES_CP_inicial

--select count (*) as q from gdc..tbl_CONSOLIDADO_DIGITALES_CP_final


-- 1. agregar UN, Segmento, Cluster

   use [Visanet Planeamiento]

	--select distinct Campaña from gdc..tbl_CONSOLIDADO_DIGITALES_CP_inicial


-- trabajar primero con los canales de Vendemas, donde todo es Masivo por regla
 

	--delete from gdc..tbl_CONSOLIDADO_DIGITALES_CP_inicial
	--where periodo = 202207 -- !!!!!!!!!!!!!!!!!!!!!!!!! periodo actual
	

	declare @periodo as bigint
	set @periodo = (select max(Periodo) from gdc..tbl_CONSOLIDADO_DIGITALES_CP_inicial)

	
	--delete from gdc..tbl_CONSOLIDADO_DIGITALES_CP_final
	--where periodo = (select max(Periodo) from gdc..tbl_CONSOLIDADO_DIGITALES_CP_inicial)
	

	drop table #tab1
	select *
	into #tab1
	from gdc..tbl_CONSOLIDADO_DIGITALES_CP_inicial
	where Campaña in ('DASHBOARD VENDEMAS', 'ECOMMERCE VENDEMAS')
	and periodo = @periodo


	alter table #tab1
	add unidadnegocio varchar(50), segmento varchar(50), clustergrupo varchar(50), Grupo_Valor_F varchar(50)

	update #tab1
	set unidadnegocio = 'Masivo'
	where unidadnegocio is null

	update #tab1
	set segmento = 'Masivo'
	where segmento is null

	update #tab1
	set clustergrupo = 'Sin Cluster'
	where clustergrupo is null


-- despues con los canales que no son de Vendemas, asignar respectivamente

	drop table #tab2
	select *
	into #tab2
	from gdc..tbl_CONSOLIDADO_DIGITALES_CP_inicial
	where Campaña not in ('DASHBOARD VENDEMAS', 'ECOMMERCE VENDEMAS')
	and Periodo = @periodo


	drop table #tab3
	select a.*, b.RUC as RUC_1
	into #tab3
	from #tab2 as a
	left join comercial.basecomercios as b on a.CODIGO = b.CODIGO


	drop table #tab4
	select a.*,
	       case when RUC is not null then RUC
		        when RUC is null and RUC_1 is not null then (isnull(RUC,'') + isnull(RUC_1,''))		   
		   else 0
		   end as RUC_F
	into #tab4
	from #tab3 as a
	
	
	drop table #tab5
	select a.Periodo, a.RUC_F as RUC, CODIGO, NPS, CES, SAT, SOL, MAIL_CONTACTO, TELEFONO_CONTACTO, Campaña, Proveedor
	into #tab5
	from #tab4 as a


	drop table #tab6
	select a.*, b.unidadnegocio, b.Segmento, b.ClusterGrupo
	into #tab6
	from #tab5 as a
	left join V_Segmento_Cliente as b on a.RUC = b.Ruc


	drop table #tab7
	select a.*, b.Cuadrante_No_Aislado as Grupo_Valor_F
	into #tab7
	from #tab6 as a
	left join gdc..tbl_GV as b on a.RUC = b.ruc

	
-- unificar ambas tablas

	
	insert into gdc..tbl_CONSOLIDADO_DIGITALES_CP_final
	select *
	from (
	
	select * from #tab1

	union all 

	select * from #tab7

	) as subquery


	