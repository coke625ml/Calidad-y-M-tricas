
  declare @periodo1 as int
  set @periodo1 = 202107

  drop table #retenciones0
  select *
  into #retenciones0
  from comercial.stock
  where periodo = @periodo1
  

  drop table #retenciones
  select a.* , a.Codigo as Codigo_s, b.Segmento as Nuevo_Segmento
  into #retenciones
  from #retenciones0 as a
  left join V_Segmento_Cliente as b on a.ruc = b.ruc
  
  
  ------------------------------------------- MARGENES --------------------------------------------------------

  drop table #retenciones1
  select
         a.periodo,
		 a.Nuevo_Segmento,
         a.ruc, 
		 a.codigo_s,
		 j.margen_txn_n_4,
		 k.margen_txn_n_5,
		 x.margen_txn_n_6

  into #retenciones1

  from #retenciones as a
  left join (select periodo, codigo, ruc, MargenTransaccion as margen_txn_n_4 from v_rentabilidad_margen)  as j on a.codigo_s = j.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,+4,convert(date,cast(j.periodo as varchar(10))+'01',112)) -- N - 4
  left join (select periodo, codigo, ruc, MargenTransaccion as margen_txn_n_5 from v_rentabilidad_margen)  as k on a.Codigo_s = k.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,+5,convert(date,cast(k.periodo as varchar(10))+'01',112)) -- N - 5
  left join (select periodo, codigo, ruc, MargenTransaccion as margen_txn_n_6 from v_rentabilidad_margen)  as x on a.Codigo_s = x.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,+6,convert(date,cast(x.periodo as varchar(10))+'01',112)) -- N - 6



  drop table #retenciones2
  select
         a.periodo,
		 a.Nuevo_Segmento,
         a.ruc, 
		 a.codigo_s,
		 j.margen_txn_n_7,
		 k.margen_txn_n_8,
		 x.margen_txn_n_9

  into #retenciones2

  from #retenciones as a
  left join (select periodo, codigo, ruc, MargenTransaccion as margen_txn_n_7 from v_rentabilidad_margen)  as j on a.codigo_s = j.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,+7,convert(date,cast(j.periodo as varchar(10))+'01',112)) -- N - 7
  left join (select periodo, codigo, ruc, MargenTransaccion as margen_txn_n_8 from v_rentabilidad_margen)  as k on a.Codigo_s = k.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,+8,convert(date,cast(k.periodo as varchar(10))+'01',112)) -- N - 8
  left join (select periodo, codigo, ruc, MargenTransaccion as margen_txn_n_9 from v_rentabilidad_margen)  as x on a.Codigo_s = x.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,+9,convert(date,cast(x.periodo as varchar(10))+'01',112)) -- N - 9
   



   drop table #retenciones3
   select a.* , b.margen_txn_n_7 , b.margen_txn_n_8 , b.margen_txn_n_9
   into #retenciones3
   from #retenciones1 as a
   left join #retenciones2 as b on a.Codigo_s = b.Codigo_s

   
  drop table #retencion1
  select
         Codigo_s,
		 Nuevo_Segmento,
		 isnull ( ( sum ( margen_txn_n_4 + margen_txn_n_5 + margen_txn_n_6 + margen_txn_n_7 + margen_txn_n_8 + margen_txn_n_9 ) / 6 ) , 0 ) as Margen_Txn_Prom_Aislado
  
  into #retencion1
  from #retenciones3
  group by codigo_s , Nuevo_Segmento

  
  ------------------------------------------------ VOLUMEN ------------------------------------------------------------------

  drop table #retencion2
  select
        periodo, 
		ruc, 
		codigo_s
  into #retencion2
  from #retenciones

  
  drop table #retencion4
  select 
         a.*,
		 j.vol_n_4,
		 k.vol_n_5,
		 x.vol_n_6

  into #retencion4

  from #retencion2 as a
  left join (select periodo , Codigo , vol as vol_n_4 from comercial.stock)  as j on a.codigo_s = j.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,+4,convert(date,cast(j.periodo as varchar(10))+'01',112)) -- N - 4
  left join (select periodo , codigo , vol as vol_n_5 from comercial.stock)  as k on a.Codigo_s = k.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,+5,convert(date,cast(k.periodo as varchar(10))+'01',112)) -- N - 5
  left join (select periodo , codigo , vol as vol_n_6 from comercial.stock)  as x on a.Codigo_s = x.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,+6,convert(date,cast(x.periodo as varchar(10))+'01',112)) -- N - 6



  drop table #retencion7
  select 
         a.*,
		 j.vol_n_7,
		 k.vol_n_8,
		 x.vol_n_9

  into #retencion7

  from #retencion4 as a
  left join (select periodo , Codigo , vol as vol_n_7 from comercial.stock)  as j on a.codigo_s = j.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,+7,convert(date,cast(j.periodo as varchar(10))+'01',112)) -- N - 7
  left join (select periodo , codigo , vol as vol_n_8 from comercial.stock)  as k on a.Codigo_s = k.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,+8,convert(date,cast(k.periodo as varchar(10))+'01',112)) -- N - 8
  left join (select periodo , codigo , vol as vol_n_9 from comercial.stock)  as x on a.Codigo_s = x.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,+9,convert(date,cast(x.periodo as varchar(10))+'01',112)) -- N - 9

  
 
  drop table #ailsarvolumen1
  select
         codigo_s,
		 isnull ( ( sum ( vol_n_4 + vol_n_5 + vol_n_6  + vol_n_7 + vol_n_8 + vol_n_9) / 7 ) , 0 ) as Vol_Prom_Aislado
  into #ailsarvolumen1
  from #retencion7
  group by codigo_s

  
    
  ------------------------------------ final ----------------------------------------------------------  
  
  

 





  drop table #inicio
  select 
         a.*
		 ,
		 b.Vol_Prom_Aislado
  
  into #inicio
  
  from #retencion1 as a 
  left join #ailsarvolumen1 as b on a.codigo_s = b.codigo_s

  -- select * from #inicio

  select * from gdc..Tbl_Final_Aislado_Codigo



  alter table #inicio add Periodo BIGINT
  CONSTRAINT CONSTRAINTNAME DEFAULT 202107
  WITH VALUES

  -- select * from #inicio

  drop table #iniciofinal
  select nuevo_segmento , 
         codigo_s , 
		 margen_txn_prom_aislado , 
		 vol_prom_aislado , periodo 
  
  into #iniciofinal
  from #inicio
  
  insert into gdc..Tbl_Final_Aislado_Codigo
  select * 
  from #iniciofinal
  
  
  ----------------- Validacion ---------------------------

  
  -- select * from gdc..Tbl_Grupo_Valor_final where periodo is null

  select periodo, sum ( Margen_Txn_Prom_Aislado ) , sum ( Vol_Prom_Aislado )  , count ( * ) q
  from gdc..Tbl_Final_Aislado_Codigo
  group by periodo order by periodo desc

