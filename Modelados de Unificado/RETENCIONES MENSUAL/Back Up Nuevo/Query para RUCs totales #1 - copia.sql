
  declare @periodo_primero int
  set @periodo_primero = 202010
  
  declare @periodo_segundo int
  set @periodo_segundo = 202009
  
  drop table #tab
  
  select Segmento, Ruc , count ( Codigo ) q_cod

  into #tab
  from gdc..tbl_retenciones_final
  where periodo = @periodo_primero
  and pool_funcionario = 'funcionario'
  and Unidad_de_negocio = 'corporativo'
  and Segmento in ('gobierno', 'gran cadena')
  and Retenido_No_Retenido = 'no retenido'
  group by segmento, ruc


  drop table #tabnueva

  select ruc, count ( codigo ) as q_habilitado
  into #tabnueva
  from comercial.stock
  where periodo = @periodo_primero
  and codigo in ( select codigo from v_StockHabilitado where periodo = @periodo_segundo and EstadoHabilitado = 1 )
  group by ruc


  drop table #tabprev
  select a.*
         ,
		 b.q_habilitado
  
  into #tabprev
  from #tab as a 
  left join #tabnueva as b on a.ruc = b.ruc


  
  select *
  from #tabprev
  
  
  select ruc , NOMBRECOME
  from Comercial.basecomercios
  where ruc in ( 20546832270, 20603339429, 20493492030 )
  order by ruc desc