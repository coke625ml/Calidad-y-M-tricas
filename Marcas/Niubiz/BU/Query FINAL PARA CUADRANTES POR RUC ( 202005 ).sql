-- INSTRUCCIONES !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    -- buscar el values para poner el periodo respectivo

  declare @periodo1 as int
  set @periodo1 = 202111 -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  drop table #retenciones
  select a.periodo as periodo_s , b.segmento as nuevo_segmento , a.ruc , a.Codigo as codigo_s
  into #retenciones
  from comercial.stock as a
  left join V_Segmento_Cliente as b on a.ruc = b.ruc
  where a.Periodo = @periodo1
  and ComerciosTemporales = 0
  
  
  ------------------------------------------- MARGENES --------------------------------------------------------

  drop table #retenciones1
  select
         a.periodo_s,
		 a.Nuevo_Segmento,
         a.ruc, 
		 a.codigo_s,
		 j.margen_txn_n_4,
		 k.margen_txn_n_5,
		 x.margen_txn_n_6
  into #retenciones1
  from #retenciones as a
  left join (select periodo, codigo, ruc, MargenTransaccion as margen_txn_n_4 from v_Rentabilidad_Margen_v2)  as j on a.codigo_s = j.Codigo and convert(date,cast(a.periodo_s as varchar(10))+'01',112) = DATEADD(month,+4,convert(date,cast(j.periodo as varchar(10))+'01',112)) -- N - 4
  left join (select periodo, codigo, ruc, MargenTransaccion as margen_txn_n_5 from v_Rentabilidad_Margen_v2)  as k on a.Codigo_s = k.Codigo and convert(date,cast(a.periodo_s as varchar(10))+'01',112) = DATEADD(month,+5,convert(date,cast(k.periodo as varchar(10))+'01',112)) -- N - 5
  left join (select periodo, codigo, ruc, MargenTransaccion as margen_txn_n_6 from v_Rentabilidad_Margen_v2)  as x on a.Codigo_s = x.Codigo and convert(date,cast(a.periodo_s as varchar(10))+'01',112) = DATEADD(month,+6,convert(date,cast(x.periodo as varchar(10))+'01',112)) -- N - 6



  drop table #retenciones4
  select
         a.* 
		 ,
		 j.margen_txn_n_7,
		 k.margen_txn_n_8,
		 x.margen_txn_n_9

  into #retenciones4
  from #retenciones1 as a
  left join (select periodo, codigo, ruc, MargenTransaccion as margen_txn_n_7 from v_Rentabilidad_Margen_v2)  as j on a.codigo_s = j.Codigo and convert(date,cast(a.periodo_s as varchar(10))+'01',112) = DATEADD(month,+7,convert(date,cast(j.periodo as varchar(10))+'01',112)) -- N - 7
  left join (select periodo, codigo, ruc, MargenTransaccion as margen_txn_n_8 from v_Rentabilidad_Margen_v2)  as k on a.Codigo_s = k.Codigo and convert(date,cast(a.periodo_s as varchar(10))+'01',112) = DATEADD(month,+8,convert(date,cast(k.periodo as varchar(10))+'01',112)) -- N - 8
  left join (select periodo, codigo, ruc, MargenTransaccion as margen_txn_n_9 from v_Rentabilidad_Margen_v2)  as x on a.Codigo_s = x.Codigo and convert(date,cast(a.periodo_s as varchar(10))+'01',112) = DATEADD(month,+9,convert(date,cast(x.periodo as varchar(10))+'01',112)) -- N - 9
  
  
  drop table #retenciones7
  select
         ruc, 
		 Nuevo_Segmento,
		 sum ( margen_txn_n_4 ) as margen_txn_n_4,
		 sum ( margen_txn_n_5 ) as margen_txn_n_5, 
		 sum ( margen_txn_n_6 ) as margen_txn_n_6, 
		 sum ( margen_txn_n_7 ) as margen_txn_n_7, 
		 sum ( margen_txn_n_8 ) as margen_txn_n_8, 
		 sum ( margen_txn_n_9 ) as margen_txn_n_9

  into #retenciones7
  from #retenciones4
  group by ruc , Nuevo_Segmento

  
  drop table #retencion1
  select
         ruc,
		 Nuevo_Segmento,
		 isnull ( ( sum ( margen_txn_n_4 + margen_txn_n_5 + margen_txn_n_6 + margen_txn_n_7 + margen_txn_n_8 + margen_txn_n_9 ) / 6 ) , 0 ) as Margen_Txn_Prom_Aislado
  into #retencion1
  from #retenciones7
  group by ruc , Nuevo_Segmento

  
  
  ------------------------------------------------ VOLUMEN ------------------------------------------------------------------

  drop table #retencion2
  select
        periodo_s, 
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
  left join (select periodo_s, codigo_s, vol as vol_n_4 from gdc..vw_indicadores_habilitados)  as j on a.codigo_s = j.Codigo_s and convert(date,cast(a.periodo_s as varchar(10))+'01',112) = DATEADD(month,+4,convert(date,cast(j.periodo_s as varchar(10))+'01',112)) -- N - 4
  left join (select periodo_s, codigo_s, Vol as vol_n_5 from gdc..vw_indicadores_habilitados)  as k on a.Codigo_s = k.Codigo_s and convert(date,cast(a.periodo_s as varchar(10))+'01',112) = DATEADD(month,+5,convert(date,cast(k.periodo_s as varchar(10))+'01',112)) -- N - 5
  left join (select periodo_s, codigo_s, Vol as vol_n_6 from gdc..vw_indicadores_habilitados)  as x on a.Codigo_s = x.Codigo_s and convert(date,cast(a.periodo_s as varchar(10))+'01',112) = DATEADD(month,+6,convert(date,cast(x.periodo_s as varchar(10))+'01',112)) -- N - 6


  drop table #retencion7
  select 
         a.*
		 ,
		 j.vol_n_7,
		 k.vol_n_8,
		 x.vol_n_9
		 
  into #retencion7 
  from #retencion4 as a
  left join (select periodo_s, codigo_s, vol as vol_n_7 from gdc..vw_indicadores_habilitados)  as j on a.codigo_s = j.Codigo_s and convert(date,cast(a.periodo_s as varchar(10))+'01',112) = DATEADD(month,+7,convert(date,cast(j.periodo_s as varchar(10))+'01',112)) -- N - 7
  left join (select periodo_s, codigo_s, Vol as vol_n_8 from gdc..vw_indicadores_habilitados)  as k on a.Codigo_s = k.Codigo_s and convert(date,cast(a.periodo_s as varchar(10))+'01',112) = DATEADD(month,+8,convert(date,cast(k.periodo_s as varchar(10))+'01',112)) -- N - 8
  left join (select periodo_s, codigo_s, Vol as vol_n_9 from gdc..vw_indicadores_habilitados)  as x on a.Codigo_s = x.Codigo_s and convert(date,cast(a.periodo_s as varchar(10))+'01',112) = DATEADD(month,+9,convert(date,cast(x.periodo_s as varchar(10))+'01',112)) -- N - 9

  
  drop table #aislarvolumen
  select
         ruc, 
		 sum ( vol_n_4 ) as vol_n_4,
		 sum ( vol_n_5 ) as vol_n_5, 
		 sum ( vol_n_6 ) as vol_n_6, 
		 sum ( vol_n_7 ) as vol_n_7, 
		 sum ( vol_n_8 ) as vol_n_8, 
		 sum ( vol_n_9 ) as vol_n_9

  into #aislarvolumen
  from #retencion7
  group by ruc

  
  drop table #aislarvolumen1
  select
         ruc,
		 isnull ( ( sum ( vol_n_4 + vol_n_5 + vol_n_6 + vol_n_7 + vol_n_8 + vol_n_9 ) / 6 ) , 0 ) as Vol_Prom_Aislado
  into #aislarvolumen1
  from #aislarvolumen
  group by ruc

  
  
  
  ------------------------------------ final ----------------------------------------------------------  
  
  







  drop table #inicio
  select 
         a.*
		 ,
		 b.Vol_Prom_Aislado
  into #inicio
  from #retencion1 as a 
  left join #aislarvolumen1 as b on a.ruc = b.ruc



  select * 
  from #inicio
  where ruc in ( select ruc from v_StockHabilitado_v1 where periodo = 202111 and EstadoHabilitado = 1 )


  -- select avg (Margen_Txn_Prom_Aislado) as prom_margen , avg ( Vol_Prom_Aislado ) as prom_volumen from #inicio where Nuevo_Segmento in ( 'Tradicional' ,  'Ligero Top' ) 
   

  drop table #final
  select
         a.*
		 ,

		 case when   Nuevo_Segmento = 'Masivo' and Vol_Prom_Aislado >= 4299 and ( Margen_Txn_Prom_Aislado )>= 6.2 then '[Masivo : G1]'
														    
				when Nuevo_Segmento = 'Masivo' and Vol_Prom_Aislado < 4299 and  ( Margen_Txn_Prom_Aislado )>= 6.2 then '[Masivo : G2]'

				when Nuevo_Segmento = 'Masivo' and Vol_Prom_Aislado < 4299 and  ( Margen_Txn_Prom_Aislado )< 6.2 then '[Masivo : G4]'

				when Nuevo_Segmento = 'Masivo' and Vol_Prom_Aislado >= 4299 and ( Margen_Txn_Prom_Aislado )< 6.2 then '[Masivo : G3]'

				
				
				when Nuevo_Segmento = 'Gran Cadena' then '[Corporativo : G1]'
				
				when Nuevo_Segmento = 'Gobierno' then '[Corporativo : G1]'


				when Nuevo_Segmento in ( 'Top' )  and Vol_Prom_Aislado >= 692269 and ( Margen_Txn_Prom_Aislado )>= 2657 then '[Corporativo : G1]'
														    
				when Nuevo_Segmento in ( 'Top' ) and Vol_Prom_Aislado < 692269   and   ( Margen_Txn_Prom_Aislado ) < 2657 then '[Corporativo : G2]'

				

				
				when Nuevo_Segmento in ( 'Tradicional' , 'Ligero Top' )  and Vol_Prom_Aislado >= 37796 and ( Margen_Txn_Prom_Aislado )>= 178 then '[Corporativo : G1]'
														    
				when Nuevo_Segmento in ( 'Tradicional' , 'Ligero Top' ) and Vol_Prom_Aislado <37796 and   ( Margen_Txn_Prom_Aislado )>= 178 then '[Corporativo : G2]'

				when Nuevo_Segmento in ( 'Tradicional' , 'Ligero Top' ) and Vol_Prom_Aislado < 37796 and  ( Margen_Txn_Prom_Aislado )< 178 then '[Corporativo : G4]'

				when Nuevo_Segmento in ( 'Tradicional' , 'Ligero Top' ) and Vol_Prom_Aislado >= 37796 and ( Margen_Txn_Prom_Aislado )< 178 then '[Corporativo : G3]'




				when Nuevo_Segmento in ( 'Transporte' , 'Servicios Financieros' ,  'PFs' , 'Otros (Izipay)' )  and Vol_Prom_Aislado >= 1377744 and ( Margen_Txn_Prom_Aislado )>= 3877 then '[Procesamiento : G1]'
														    
				when Nuevo_Segmento in ( 'Transporte' , 'Servicios Financieros' ,  'PFs' , 'Otros (Izipay)' ) and Vol_Prom_Aislado <1377744 and   ( Margen_Txn_Prom_Aislado )>= 3877 then '[Procesamiento : G2]'

				when Nuevo_Segmento in ( 'Transporte' , 'Servicios Financieros' ,  'PFs' , 'Otros (Izipay)' ) and Vol_Prom_Aislado < 1377744 and  ( Margen_Txn_Prom_Aislado )< 3877 then '[Procesamiento : G4]'

				when Nuevo_Segmento in ( 'Transporte' , 'Servicios Financieros' ,  'PFs' , 'Otros (Izipay)' ) and Vol_Prom_Aislado >= 1377744 and ( Margen_Txn_Prom_Aislado )< 3877 then '[Procesamiento : G3]'


				end as Cuadrante


  
  into #final	  
  from #inicio as a		

		  
		  -- select * from #final
		  -- select * from gdc..Tbl_Grupo_Valor_final where periodo = 202104
		  
		  


  alter table #final add Periodo BIGINT
  CONSTRAINT CONSTRAINTNAME DEFAULT 202107
  WITH VALUES

  

  select nuevo_segmento , ruc , Margen_Txn_Prom_Aislado , Vol_Prom_Aislado , Cuadrante , cast ( periodo as float ) as periodo
  into #finalv1
  from #final 


  -- select * from #finalv1
  
  
  
  
  
  
  
  insert into gdc..Tbl_Grupo_Valor_final
  select * 
  from #finalv1
  
  
  
  
  
  

  
  
  
  
  
  
  --alter table #final
  --drop column Marca_Gran_Cadena

  --select * 
  --from gdc..Tbl_Grupo_Valor_final
  
  ----------------- Validacion ---------------------------

  
  -- select * from gdc..Tbl_Grupo_Valor_final where periodo is null

  --select periodo, count ( * ) q
  --from gdc..tbl_grupo_valor_final
  --group by periodo 

  
  ----------------- Asignacion retención -----------------

  --drop table #reten
  --select 
  --       a.*
		-- ,
		-- b.Cuadrante
		   
  --into #reten
  --from gdc..tbl_retenciones_final as a
  --left join #final as b on a.ruc = b.ruc
  --where a.periodo = 202002

  
  --select 
  --       a.periodo,
		-- a.Segmento,
		-- a.Ruc,
		-- a.Codigo,
		-- a.Cuadrante,
		-- a.Retenido_No_Retenido,
		-- a.Herramienta,
		-- b.margen_txn_n_4,
		-- b.margen_txn_n_5,
		-- b.margen_txn_n_6,
		-- b.margen_txn_n_7,
		-- b.margen_txn_n_8,

		-- b.margen_txn_n_9

  --from #reten as a
  --left join #retenciones4 as b on a.Codigo = b.codigo_s





  -- select COUNT (*) from gdc..tbl_grupo_valor_final where periodo = 202007


