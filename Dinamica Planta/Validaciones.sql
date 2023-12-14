
  select count (*) 
  from comercial.stock 
  where periodo = 201911
  and movimiento = 1
  and codigo in (select codigo from comercial.stock where periodo = 201910 and movimiento = 1 )


  select count (*)
  from comercial.Reactivacion
  where periodo = 201911

  select distinct tipo
  from gdc..tbl_dinamica_planta
  where periodo = 201911

  
-- select sum (comercios) from gdc..tbl_dinamica_planta where tipo = 'Afiliaciones' and periodo = 201911
-- select sum (comercios) from gdc..tbl_dinamica_planta where tipo = 'Desafiliaciones' and periodo = 201911
-- select sum (comercios) from gdc..tbl_dinamica_planta where tipo = 'Permanecen' and periodo = 201911
-- select sum (comercios) from gdc..tbl_dinamica_planta where tipo = 'Reactivacion T.' and periodo = 201911
-- select count (*) from gdc..tbl_dinamica_planta