

 
    use VendeMasDWH

    drop table #tab1
	select *
	into #Tab1
	from (
	   
	select * from V_FactComerciosMensual
	where Periodo = 202111
	and Flag_Habilitado = 1 --> Habilitado y Validado
	and Flag_Pos = 1 --> terminal Vinculado
  
    union all


	select * from V_FactComerciosMensual
	where Periodo = 202111
	and Flag_Habilitado = 1 --> Habilitado y Validado
	and Flag_Pos = 0 --> Sin terminal Vinculado se considera Digital
    
	) as Subquery

	
	
	
		drop table #tab2
		select a. * , ( ( cast( codigo as bigint) - cast(right( codigo , 1) as int)) / 100 ) as CODIGOF
		into #tab2
		from [Visanet Planeamiento]..v_Rentabilidad_Margen_v2 as a
		where fuente = 'v+'
		and periodo = 202101

		
	drop table #tab3
	select a. * , ( ( cast( codigo as bigint) - cast(right( codigo , 1) as int)) / 100 ) as CODIGOF
	into #tab3
	from [Visanet Planeamiento]..v_Rentabilidad_Margen_v2 as a
	where fuente = 'v+'
	and periodo = 202102
	

	drop table #tab4
	select a. * , ( ( cast( codigo as bigint) - cast(right( codigo , 1) as int)) / 100 ) as CODIGOF
	into #tab4
	from [Visanet Planeamiento]..v_Rentabilidad_Margen_v2 as a
	where fuente = 'v+'
	and periodo = 202103


	drop table #Tab5
	select a. * , ( ( cast( codigo as bigint) - cast(right( codigo , 1) as int)) / 100 ) as CODIGOF
	into #tab5
	from [Visanet Planeamiento]..v_Rentabilidad_Margen_v2 as a
	where fuente = 'v+'
	and periodo = 202104
	

	drop table #tab7
	select a. * , ( ( cast( codigo as bigint) - cast(right( codigo , 1) as int)) / 100 ) as CODIGOF
	into #tab7
	from [Visanet Planeamiento]..v_Rentabilidad_Margen_v2 as a
	where fuente = 'v+'
	and periodo = 202105
	

	drop table #tab8
	select a. * , ( ( cast( codigo as bigint) - cast(right( codigo , 1) as int)) / 100 ) as CODIGOF
	into #tab8
	from [Visanet Planeamiento]..v_Rentabilidad_Margen_v2 as a
	where fuente = 'v+'
	and periodo = 202106


	drop table #Tab9
	select a. * , ( ( cast( codigo as bigint) - cast(right( codigo , 1) as int)) / 100 ) as CODIGOF
	into #tab9
	from [Visanet Planeamiento]..v_Rentabilidad_Margen_v2 as a
	where fuente = 'v+'
	and periodo = 202107


	drop table #Tab10
	select a. * , ( ( cast( codigo as bigint) - cast(right( codigo , 1) as int)) / 100 ) as CODIGOF
	into #tab10
	from [Visanet Planeamiento]..v_Rentabilidad_Margen_v2 as a
	where fuente = 'v+'
	and periodo = 202108


	drop table #Tab11
	select a. * , ( ( cast( codigo as bigint) - cast(right( codigo , 1) as int)) / 100 ) as CODIGOF
	into #tab11
	from [Visanet Planeamiento]..v_Rentabilidad_Margen_v2 as a
	where fuente = 'v+'
	and periodo = 202109


	drop table #Tab12
	select a. * , ( ( cast( codigo as bigint) - cast(right( codigo , 1) as int)) / 100 ) as CODIGOF
	into #tab12
	from [Visanet Planeamiento]..v_Rentabilidad_Margen_v2 as a
	where fuente = 'v+'
	and periodo = 202110
	
	
	
	
	select *
	into #tab13

	from ( 

	select * from #tab2

	union all

	select * from #tab3

	union all

	select * from #tab4
	
	union all

	select * from #tab4
	
	union all

	select * from #tab5

	union all

	select * from #tab7

	union all
	
	select * from #tab8

	union all

	select * from #tab9

	union all

	select * from #tab10

	union all

	select * from #tab11

	union all

	select * from #tab12


	) as subquery2
	
	
	
	
	
	
	drop table #tab14
	select periodo , CODIGOF , sum ( MargenTransaccion ) as MargenTransaccion , sum ( Volumen ) as Volumen
	into #tab14
	from #tab13
	group by periodo , CODIGOF

	
    -- select * from #tab14	
	
	-- select top 1 * from #tab1
	
	
	--select CODIGOF , count (*) 
	--from #tab13
	--where Periodo = 202107
	--group by Codigof


	--select Codigo, CODIGOF , count (*) 
	--from #tab2
	--group by Codigo, CODIGOF
	
	
	drop table #tab15
	select a.* , isnull (b.MargenTransaccion , 0 ) as MgTXN_n_4 , isnull ( b.Volumen, 0 ) as Vol_n_4
	into #tab15
	from #Tab1 as a
	left join #tab14 as b on a.CodigoNBO =  b.Codigof  and convert(date,cast(a.Periodo as varchar(10))+'01',112) = DATEADD(month,+4,convert(date,cast(b.periodo as varchar(10))+'01',112)) -- N - 4
	
	
	--select * 
	--from #tab14
			
	--use [Visanet Planeamiento]
		
	
	drop table #tab16
	select a.* , isnull (b.MargenTransaccion , 0 ) as MgTXN_n_5 , isnull ( b.Volumen, 0 ) as Vol_n_5
	into #tab16
	from #tab15 as a
	left join #tab14 as b on a.CodigoNBO =  b.Codigof  and convert(date,cast(a.Periodo as varchar(10))+'01',112) = DATEADD(month,+5,convert(date,cast(b.periodo as varchar(10))+'01',112)) -- N - 5


	
	drop table #tab17
	select a.* , isnull (b.MargenTransaccion , 0 ) as MgTXN_n_6 , isnull ( b.Volumen, 0 ) as Vol_n_6
	into #tab17
	from #Tab16 as a
	left join #tab14 as b on a.CodigoNBO =  b.Codigof  and convert(date,cast(a.Periodo as varchar(10))+'01',112) = DATEADD(month,+6,convert(date,cast(b.periodo as varchar(10))+'01',112)) -- N - 6


	
	drop table #tab18
	select a.* , isnull (b.MargenTransaccion , 0 ) as MgTXN_n_7 , isnull ( b.Volumen, 0 ) as Vol_n_7
	into #tab18
	from #Tab17 as a
	left join #tab14 as b on a.CodigoNBO =  b.Codigof  and convert(date,cast(a.Periodo as varchar(10))+'01',112) = DATEADD(month,+7,convert(date,cast(b.periodo as varchar(10))+'01',112)) -- N - 7


	
	drop table #tab19
	select a.* , isnull (b.MargenTransaccion , 0 ) as MgTXN_n_8 , isnull ( b.Volumen, 0 ) as Vol_n_8
	into #tab19
	from #Tab18 as a
	left join #tab14 as b on a.CodigoNBO =  b.Codigof  and convert(date,cast(a.Periodo as varchar(10))+'01',112) = DATEADD(month,+8,convert(date,cast(b.periodo as varchar(10))+'01',112)) -- N - 8



	drop table #tab20
	select a.* , isnull (b.MargenTransaccion , 0 ) as MgTXN_n_9 , isnull ( b.Volumen, 0 ) as Vol_n_9
	into #tab20
	from #Tab19 as a
	left join #tab14 as b on a.CodigoNBO =  b.Codigof  and convert(date,cast(a.Periodo as varchar(10))+'01',112) = DATEADD(month,+9,convert(date,cast(b.periodo as varchar(10))+'01',112)) -- N - 9




	select *
	from #tab20