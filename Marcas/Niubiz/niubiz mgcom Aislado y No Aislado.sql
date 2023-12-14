-- INSTRUCCIONES !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    -- buscar el values para poner el periodo respectivo
  
  use [Visanet Planeamiento]
  declare @periodo1 as int
  set @periodo1 = 202112 -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  drop table #stock
  select a.periodo , a.ruc , a.Codigo, b.segmento, b.unidadnegocio
  into #stock
  from ( select * from comercial.stock where periodo = @periodo1 ) as a
  left join V_Segmento_Cliente as b on a.ruc = b.ruc
  where ComerciosTemporales = 0
  and Codigo in ( select codigo from v_StockHabilitado_v1 where periodo = @periodo1 and EstadoHabilitado = 1 )
  
  
  ------------------------------------------- MARGENES --------------------------------------------------------

  drop table #stock1
  select
         a.* ,
		 j.mgcom_n_4,
		 j.Vol_n_4,
		 k.mgcom_n_5,
		 k.Vol_n_5,
		 x.mgcom_n_6,
		 x.Vol_n_6
  into #stock1
  from #stock as a
  left join (select periodo, codigo, ruc, MargenComercio as mgcom_n_4, Volumen as Vol_n_4 from v_Rentabilidad_Margen_v2)  as j on a.codigo = j.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,+4,convert(date,cast(j.periodo as varchar(10))+'01',112)) -- N - 4
  left join (select periodo, codigo, ruc, MargenComercio as mgcom_n_5, Volumen as Vol_n_5 from v_Rentabilidad_Margen_v2)  as k on a.Codigo = k.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,+5,convert(date,cast(k.periodo as varchar(10))+'01',112)) -- N - 5
  left join (select periodo, codigo, ruc, MargenComercio as mgcom_n_6, Volumen as Vol_n_6 from v_Rentabilidad_Margen_v2)  as x on a.Codigo = x.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,+6,convert(date,cast(x.periodo as varchar(10))+'01',112)) -- N - 6


  drop table #stock2
  select
         a.* ,
		 j.mgcom_n_7,
		 j.Vol_n_7,
		 k.mgcom_n_8,
		 k.Vol_n_8,
		 x.mgcom_n_9,
		 x.Vol_n_9
  into #stock2
  from #stock1 as a
  left join (select periodo, codigo, ruc, MargenComercio as mgcom_n_7, Volumen as Vol_n_7 from v_Rentabilidad_Margen_v2)  as j on a.codigo = j.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,+7,convert(date,cast(j.periodo as varchar(10))+'01',112)) -- N - 7
  left join (select periodo, codigo, ruc, MargenComercio as mgcom_n_8, Volumen as Vol_n_8 from v_Rentabilidad_Margen_v2)  as k on a.Codigo = k.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,+8,convert(date,cast(k.periodo as varchar(10))+'01',112)) -- N - 8
  left join (select periodo, codigo, ruc, MargenComercio as mgcom_n_9, Volumen as Vol_n_9 from v_Rentabilidad_Margen_v2)  as x on a.Codigo = x.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,+9,convert(date,cast(x.periodo as varchar(10))+'01',112)) -- N - 9



  drop table #stock4
  select
         a.* ,
		 j.mgcom_n_1,
		 j.Vol_n_1,
		 k.mgcom_n_2,
		 k.Vol_n_2,
		 x.mgcom_n_3,
		 x.Vol_n_3
  into #stock4
  from #stock2 as a
  left join (select periodo, codigo, ruc, MargenComercio as mgcom_n_1, Volumen as Vol_n_1 from v_Rentabilidad_Margen_v2)  as j on a.codigo = j.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,+1,convert(date,cast(j.periodo as varchar(10))+'01',112)) -- N - 1
  left join (select periodo, codigo, ruc, MargenComercio as mgcom_n_2, Volumen as Vol_n_2 from v_Rentabilidad_Margen_v2)  as k on a.Codigo = k.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,+2,convert(date,cast(k.periodo as varchar(10))+'01',112)) -- N - 2
  left join (select periodo, codigo, ruc, MargenComercio as mgcom_n_3, Volumen as Vol_n_3 from v_Rentabilidad_Margen_v2)  as x on a.Codigo = x.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,+3,convert(date,cast(x.periodo as varchar(10))+'01',112)) -- N - 3


  drop table gdc..tbl_grupo_valor_nuevo
  select *
  into gdc..tbl_grupos_valor_niubiz_aislado_mgcom
  from #stock4


  
  ------------------------------------ REGLAS DE SEGMENTACION CORPORATIVO ----------------------------------------------------------  
  
  







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


