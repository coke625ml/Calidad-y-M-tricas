
  select * 
  from v_StockHabilitado
  where periodo = 201911
  and habafil = 1
  and codigo in  (select codigo from comercial.stock where periodo = 201911 and Movimiento = 1)



  select count (*) 
  from comercial.stock 
  where periodo = 201911
  and movimiento = 1
  and codigo in (select codigo from comercial.stock where periodo = 201910 and movimiento = 1 )


  select * 
  from v_StockHabilitado
  where periodo = 201910
  and EstadoHabilitado = 1
  and codigo in  (select codigo from comercial.stock where periodo = 201910 and Movimiento = 0)
  and codigo in (select codigo from v_StockHabilitado where periodo = 201910 and EstadoHabilitado = 1)