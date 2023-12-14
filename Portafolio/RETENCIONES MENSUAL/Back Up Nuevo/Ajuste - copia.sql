-- Notas

  -- 1. UN Masivo 
     -- Ratio Q: ajustar 202004
	 -- Ratio S: ajustar 202009 , 202010

  -- 2. Corporativo:

     -- 2.1. Solo Pool
     -- Ratio de Q: ajustar 202004, 202005, 202006, 202009, 202010
	 -- Ratio de S/: ajustar 202009 , 202010

	 -- 2.2. Funcionario y Pool
	 -- Ratio de Q: ajustar 202004, 202005, 202006
	 -- Ratio de S: ajustar 202010

  -- 3. Total
     -- Ratio Q: ajustar 202004, 



	 select periodo, Retenido_No_Retenido, count (*) 
	 from gdc..tbl_retenciones_final
	 where Unidad_de_negocio = 'Corporativo'
	 and periodo = 202004
	 and Pool_Funcionario = 'Pool'
	 group by periodo, Retenido_No_Retenido
	 


	 select codigo, Margen_Txn_Prom_Aislado
	 from gdc..tbl_retenciones_final
	 where periodo = 202004
	 and Unidad_de_negocio = 'Corporativo'
	 and Retenido_No_Retenido = 'No Retenido'
	 and Pool_Funcionario = 'Pool'
	 order by Margen_Txn_Prom_Aislado asc
	 

	 
		 update gdc..tbl_retenciones_final
		 set Retenido_No_Retenido = 'Retenido'
		 where periodo = 202004
		 and Unidad_de_negocio = 'Corporativo'
		 and Pool_Funcionario = 'Pool'
		 and codigo in ( 650080282 )