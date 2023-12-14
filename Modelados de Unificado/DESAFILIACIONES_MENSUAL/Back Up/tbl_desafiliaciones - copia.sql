
  declare @periodonuevo bigint
  set @periodonuevo = 202202

  declare @periodoanterior bigint
  set @periodoanterior = 202201
  
  declare @periodoaislado bigint
  set @periodoaislado = 202111	-- se actualiza con el grupo de valor vigente
      
  drop table #tab1
  select 
         a.codigo,
		 a.periodo,
		 a.Ruc, 
		 a.AgrupacionGiros,
		 a.comerciostemporales,
		 a.Movimiento,
		 a.Vol,
		 a.MCCINTER,
		 a.MCCNAC,
		 a.MOI,
		 a.MOB,
		 a.FechaAlta,
		 a.Txn,
	     a.SubProducto,
		 a.Producto,
		 a.LimaProvincias,
		 b.Estadohabilitado,
		 b.habafil,
		 b.habdesf

  into #tab1
  from Comercial.stock as a
  left join v_StockHabilitado as b on a.codigo = b.codigo and a.periodo = b.periodo
  where a.Periodo = @periodonuevo
  
  
  drop table #tab3
  select a.*
         , 
         b.Segmento,
		 b.unidadnegocio

  into #tab3
  from #tab1 as a
  left join (select distinct ruc , Segmento , unidadnegocio from V_Segmento_Cliente ) as b on a.Ruc = b.Ruc

    
  drop table #tab4
  select a.*
         ,
		 b.RAZONSOCIA

  into #tab4
  from #tab3 as a
  left join Comercial.BaseComercios as b on a.Codigo = b.CODIGO

    
  drop table #tab7
  select a.*
         ,
		 case when substring(FechaAlta,1,4) = 2020 then '2020'
	     when substring(FechaAlta,1,4) = 2019 then '2019'
	     when substring (FechaAlta,1,4) = 2018 then '2018'
	     else '<2018' end as año_alta,
	     case when producto = 'CE' then (
	     case when subProducto in ('PW : POS WEB') then 'PAGO_LINK'
	     when subProducto in ('PT : PST','CD : DIRECTO','FP : PSP') THEN 'PAGO_WEB'
         when subProducto in ('CM : CMS') THEN 'Tu_Vitrina'
	     when subProducto in ('QE : QR ESTATICO', 'QR') THEN 'QR'
	     when subProducto in ('AP : APP') THEN 'Pago_APP' ELSE 'OTROS' END) 
	     else producto end SUB_PRODUCTOS
  
  into #tab7
  from #tab4 as a

  
  
  
  
  
      
  drop table #tab10
  select a.*
         ,
		 b.estadohabilitado_ant
  
  into #tab10
  from #tab7 as a
  left join (select periodo, codigo, estadohabilitado as estadohabilitado_ant from [Visanet Planeamiento].[DBO].[v_StockHabilitado] where periodo = @periodoanterior ) as b on a.Codigo = b.Codigo and convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,+1,convert(date,cast(b.periodo as varchar(10))+'01',112))
  
   
  drop table #tab11
  select a.*
         ,
		 b.Margen_Txn_Prom_Aislado

  into #tab11
  from #tab10 as a
  left join ( select * from gdc..Tbl_Final_Aislado_Codigo where periodo = @periodoaislado ) as b on a.codigo = b.Codigo_s

  
  drop table #tab14
  select a.* 
         ,
		 b.MargenTransaccion,
		 b.MargenComercio
  
  into #tab14
  from #tab11 as a
  left join ( select distinct periodo , codigo , margentransaccion , margencomercio from  v_rentabilidad_margen ) as b on a.Codigo = b.codigo and a.Periodo = b.periodo
  
       
  drop table #tab70000
  select a.*
         ,
		 b.Codigo as Codigo_desafiliado,
		 b.subtipo 
  
  into #tab70000
  from #tab14 as a
  left join Comercial.desafiliacion as b on a.codigo = b.codigo and b.periodo = a.periodo

      
  drop table #tab700000
  select a.*
         ,
		 b.cuadrante
  
  into #tab700000
  from #tab70000 as		a 
  left join ( select * from gdc..tbl_grupo_valor_final where periodo = @periodoaislado ) as b on  a.ruc = b.ruc



  drop table #tab700000000
  select a.* , b.ClusterGrupo
  into #tab700000000
  from #tab700000 as a
  left join V_Segmento_Cliente as b on a.ruc = b.ruc



  
  select a.* , isnull ( b.Estado , 0 ) as Estado_generado_mes_anterior
  into #tab7000000000
  from #tab700000000 as a
  left join comercial.Stock as b on convert(date,cast(a.periodo as varchar(10))+'01',112) = DATEADD(month,+1,convert(date,cast(b.periodo as varchar(10))+'01',112)) and a.Codigo = b.Codigo
   
  
  -- select * from #tab7000000000 where Codigo_desafiliado is not null and HabDesf = 1

    
  insert into gdc..tbl_desafiliaciones_2021
  select *
  from #tab7000000000