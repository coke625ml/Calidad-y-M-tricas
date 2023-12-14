
  use [Visanet Planeamiento]
       declare @periodo1 as float
	   set @periodo1 = (select max(periodo) from gdc..tbl_retenciones_final)  -- XXXXXXXXXXXXXXXXXX COLOCAR NUEVO PERIODO
	  
	  drop table #tab1
	  select Periodo , 
	         ruc, 
			 Retenido_No_Retenido,
			 Pool_Funcionario,
			 Cuadrante,
			 ClusterGrupo,
			 Agrupaciones_Motivos,
			 Unidad_de_negocio,			 
			 Segmento,
			 count ( codigo ) as q_cod , 
			 sum ( isnull ( Margen_Txn_Prom_Aislado , 0 ) ) as MgAislado
			 
	  into #Tab1
	  from gdc..tbl_retenciones_final
	  where periodo = @periodo1
	  group by 
	         Periodo , 
	         ruc, 
			 Retenido_No_Retenido,
			 Pool_Funcionario,
			 Cuadrante,
			 ClusterGrupo,
			 Agrupaciones_Motivos,
			 Unidad_de_negocio,
			 Pool_Funcionario,
			 Segmento


	drop table #tab2
	select *
	into #tab2
	FROM
	(
	SELECT *
	, DupRank = ROW_NUMBER() OVER (
					PARTITION BY RUC
					ORDER BY (SELECT NULL)
				)
	FROM comercial.basecomercios
	where ruc in ( select ruc from #Tab1 ) 
	) AS T
	WHERE DupRank = 1




	drop table #tab3	
	select a.* , b.RAZONSOCIA
	into #Tab3
	from #Tab1 as a
	left join #tab2 as b on a.ruc = b.ruc



	drop table #tab4
	select a.* , 
	       
		   case when MgAislado < 0 then '[Margen Negativo]'
		        when MgAislado >= 0 and MgAislado <= 200 then '[0-200]'
				when MgAislado > 200 and MgAislado <= 500 then '[200-500]'
				when MgAislado > 500 and MgAislado <= 1000 then '[500-1000]'
				when MgAislado > 1000 and MgAislado <= 2000 then '[1000-2000]'
				when MgAislado > 2000 and MgAislado <= 3000 then '[2000-3000]'
				when MgAislado > 3000 then '[>3000]'

		   end as Rangos
    
	into #tab4
	from #Tab3 as a


		
	
	insert into  gdc..tbl_retenciones_final_ruc
	select *
	from #tab4