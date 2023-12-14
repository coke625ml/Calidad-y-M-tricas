--select top 10 *
--from gdc..base_tickets_vendemas


set datefirst 7

declare @periodo bigint
set @periodo = 202302


drop table #tab1
select *
into #tab1
from gdc..base_tickets_vendemas
where periodo = @periodo


drop table #tab2
select *
into #tab2
from #tab1
where categoria_servicio in ('AVERÍAS')
and categoria_incidente in ('PROBLEMAS DE HARDWARE')
and categoria_objeto in ('EQUIPO NO PRENDE', 'EQUIPO NO CARGA / POCA DURACIÓN BATERIA', 'PANTALLA ILEGIBLE', 'DAÑOS FÍSICOS DEL POS', 'TERMINAL BLOQUEADO', 
						  'VOUCHER ILEGIBLE', 'LECTURA DE TARJETA', 'PED TAMPERED', 'TERMINAL INOPERATIVO')




drop table #tab3
select *
into #tab3
from #tab1
where categoria_servicio in ('AVERÍAS')
and categoria_incidente in ('PROBLEMAS DE ACCESO')
and categoria_objeto in ('NO LLEGA CORREO DE CONF DE REGISTRO', 'NO RECONOCE EL USUARIO', 'NO PUEDE RESETEAR CONTRASEÑA', 'PROBLEMAS EN GENERAR USUARIO', 
						 'PROBLEMAS CON REGISTRO', 'PROBLEMAS PARA ACCEDER A LA PLATAFORMA', 'MANTENIMIENTO', 'PROBLEMAS PARA ACCEDER A FUNCIONALIDADES', 
						 'NO PUEDE INGRESAR AL APP')



drop table #tab4
select *
into #tab4
from #tab1
where categoria_servicio in ('AVERÍAS')
and categoria_incidente in ('NO SE COMPLETA TRANSACCIÓN')
and categoria_objeto in ('MENSAJES DE DENEGACIÓN', 'ERROR DE CONEXIÓN', 'RECARGAS Y PAGO DE SERVICIOS', 'No se visualiza Pagos de Prestamos', 
						 'Multibanco')



drop table #tab5
select *
into #tab5
from #tab1
where categoria_servicio in ('AVERÍAS')
and categoria_incidente in ('NO SE REALIZA EL PAGO DE COMISIONES')
and categoria_objeto in ('RECARGAS Y PAGO DE SERVICIOS', 'MULTIBANCO')



drop table #tab6
select *
into #tab6
from #tab1
where categoria_servicio in ('AVERÍAS')
and categoria_incidente in ('NO LLEGA CONFIRMACIÓN DE VENTA')



drop table #tab7
select *
into #tab7
from #tab1
where categoria_servicio in ('AVERÍAS')
and categoria_incidente in ('ERROR DE REPORTERÍA')
and categoria_objeto in ('NO PUEDE IMPRIMIR CIERRE DE LOTE', 'NO VISUALIZA TRANSACCIONES', 'NO PUEDE DESCARGAR REPORTES')



drop table #tab8
select *
into #tab8
from #tab1
where categoria_servicio in ('AVERÍAS')
and categoria_incidente in ('SIN DIAGNOSTICO')



drop table #tab9
select *
into #tab9
from #tab1
where categoria_servicio in ('AVERÍAS')
and categoria_incidente in ('PROBLEMAS DE SOFTWARE - APLICACIÓN')
and categoria_objeto in ('NO SE VISUALIZA OPCIONES DEL MENÚ', 'PROBLEMAS CON RECAUDACIÓN', 'PROBLEMAS CON SOLICITUD DE PRESTAMOS', 'PROBLEMAS TRANSACCIONALES', 
						 'PROBLEMAS DE TOKENIZACIÓN', 'PROBLEMA CON RECARGAS Y SERVICIOS', 'PROBLEMAS CON MULTIBANCO', 'PROBLEMAS PARA VINCULACIÓN')



drop table #tab10
select *
into #tab10
from #tab1
where categoria_servicio in ('CONSULTAS')
and categoria_incidente in ('CONCILIACIÓN DE ABONOS')
and categoria_objeto in ('CONCILIACIÓN DE ABONOS')




drop table #tab11
select *
into #tab11
from #tab1
where categoria_servicio in ('CONSULTAS')
and categoria_incidente in ('EDUCACIÓN')
and categoria_objeto in ('DENEGACIONES', 'USO DE PLATAFORMAS', 'PROCESOS', 'PRODUCTOS', 'COMISIONES', 'ENVIO CODIGO DE ACTIVACION', 'DESBLOQUEO DE USUARIO')




drop table #tab12
select *
into #tab12
from #tab1
where categoria_servicio in ('CONSULTAS')
and categoria_incidente in ('SEGUIMIENTO DE PEDIDO')
and categoria_objeto in ('EQUIPOS', 'CONTOMETROS', 'AVERIAS', 'TRÁMITES')



drop table #tab13
select *
into #tab13
from #tab1
where categoria_servicio in ('RECLAMOS')
and categoria_incidente in ('LIBRO DE RECLAMACIONES', 'PROBLEMAS CON PROMOCIONES', 'RECLAMO DE DEALERS', 'RECLAMO POR INCUMPLIMIENTO DE SLA')



drop table #tab14
select *
into #tab14
from #tab1
where categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('ABONO PENDIENTE')



drop table #tab15
select *
into #tab15
from #tab1
where categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('SERVICIOS ADICIONALES')
and categoria_objeto in ('ACTIVACION LIMAPASS', 'INACTIVACION LIMAPASS', 'INACTIVACION MULTIBANCO', 'ACTIVACION MULTIBANCO')




drop table #tab16
select *
into #tab16
from #tab1
where categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('ANULACIONES Y DEVOLUCIONES')
and categoria_objeto in ('ANULACIÓN DE VENTA', 'ANULACIÓN DE DELIVERY TARJETA', 'ANULACIÓN DELIVERY EFECTIVO/CONT-ENTREGA', 'DEVOLUCIÓN PRODUCTO TARJETA', 
						 'DEVOLUCIÓN PRODUCTO EFEC/CONT-ENTREGA')
						 


drop table #tab17
select *
into #tab17
from #tab1
where categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('LIBERACIÓN')
and categoria_objeto in ('LIBERACIÓN DE REGISTRO', 'LIBERACIÓN DE TRANSACCIÓN')




drop table #tab18
select *
into #tab18
from #tab1
where categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('MATERIALES Y ACCESORIOS')
and categoria_objeto in ('PUBLICIDAD', 'REPROGRAMACIÓN CONTÓMETROS', 'SOLICITUD DE TARJETA VENDEMAS')



drop table #tab19
select *
into #tab19
from #tab1
where categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('MODIFICACIÓN DE DATOS DE CONTACTO')
and categoria_objeto in ('MODIFICACIÓN DE CORREO ELECTRÓNICO', 'MODIFICACIÓN DE DIRECCIÓN', 'MODIFICACIÓN DE TELÉFONOS')



drop table #tab20
select *
into #tab20
from #tab1
where categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('MODIFICACIÓN DE DATOS TRIBUTARIOS')
and categoria_objeto in ('MODIFICACIÓN DE NOMBRE COMERCIAL', 'MODIFICACIÓN DE RAZÓN SOCIAL', 'MODIFICACIÓN DE REPRESENTANTE LEGAL')



drop table #tab21
select *
into #tab21
from #tab1
where categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('MODIFICACIÓN DE DATOS TRANSACCIONALES')
and categoria_objeto in ('CAMBIO DE RUBRO', 'MODIFICACIÓN DE CUENTA BANCARIA')



drop table #tab22
select *
into #tab22
from #tab1
where categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('MODIFICACIÓN DE PARÁMETROS')



drop table #tab23
select *
into #tab23
from #tab1
where categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('ROBO DE EQUIPO')



drop table #tab24
select *
into #tab24
from #tab1
where categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('PERMISOS LEY DEL CONSUMIDOR')



drop table #tab25
select *
into #tab25
from #tab1
where categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('DERECHOS DE ARCO')
and categoria_objeto in ('ACCESSO', 'CANCELACIÓN', 'OPOSICIÓN', 'RECTIFICACIÓN')



drop table #tab26
select *
into #tab26
from #tab1
where categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('SOLICITUD DE DETALLE DE ABONOS')



drop table #tab27
select *
into #tab27
from #tab1
where categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('REPROGRAMACIÓN DE DELIVERY')



drop table #tab28
select *
into #tab28
from #tab1
where categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('DOCUMENTOS')
and categoria_objeto in ('BOLETA O FACTURA POR COMISIONES', 'BOLETA O FACTURA POR COMPRA', 'FACTURA ERRADA', 'FACTURA QR', 'SUSTENTO DE DEVOLUCIÓN DE VENTA')



drop table #tab29
select *
into #tab29
from #tab1
where categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('HABILITACIÓN DE COMERCIO')
and categoria_objeto in ('ACTIVACIÓN DE CHIP', 'HABILITACIÓN DE COMERCIO')



drop table #tab30
select *
into #tab30
from #tab1
where categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('DESVINCULACIÓN DE EQUIPO')



drop table #tab31
select *
into #tab31
from #tab1
where categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('INHABILITACIÓN DE COMERCIO')



drop table #tab32
select *
into #tab32
from #tab1
where categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('INHABILITADO POR FRAUDE')



drop table #tab33
select *
into #tab33
from #tab1
where categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('CONTROVERSIAS')



drop table #tab34
select *
into #tab34
from #tab1
where categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('CAMBIO DE COMISIÓN')






--select distinct categoria_servicio
--from #tab1

--select distinct categoria_incidente
--from #tab1
--where categoria_servicio in ('REQUERIMIENTOS')

--select distinct categoria_objeto
--from #tab1
--where categoria_servicio in ('REQUERIMIENTOS')
--and categoria_incidente in ('CAMBIO DE COMISIÓN')









drop table #tab35
select *
into #tab35
from (


	select * from #tab2

	union all

	select * from #tab3

	union all
	
	select * from #tab4

	union all
	
	select * from #tab5

	union all
	
	select * from #tab6

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

	union all
	
	select * from #tab13

	union all
	
	select * from #tab14

	union all
	
	select * from #tab15

	union all
	
	select * from #tab16

	union all
	
	select * from #tab17

	union all
	
	select * from #tab18

	union all
	
	select * from #tab19

	union all
	
	select * from #tab20

	union all
	
	select * from #tab21

	union all
	
	select * from #tab22

	union all
	
	select * from #tab23

	union all
	
	select * from #tab24

	union all
	
	select * from #tab25

	union all
	
	select * from #tab26

	union all
	
	select * from #tab27

	union all
	
	select * from #tab28

	union all
	
	select * from #tab29

	union all
	
	select * from #tab30

	union all
	
	select * from #tab31

	union all
	
	select * from #tab32

	union all
	
	select * from #tab33

	union all
	
	select * from #tab34
		
	) as subquery2

delete from #tab35
where canal not in ('INBOUND', 'Pool Whatsapp Postventa')

delete from #tab35
where cast(id_comercio as nvarchar) = 0


delete from #tab35
where canal is null


--select count(*) from #tab35

drop table #tab36
select a.*,
       (categoria_servicio + categoria_incidente + categoria_objeto) as N_Llave,
	   DATEPART(week, fecha_inicio) as N_Sem,
	   SUBSTRING(cast(periodo as varchar),1,4) as Año,
	   CAST(id_comercio as nvarchar) as id_comercio_F
into #tab36
from #tab35 as a


drop table gdc..tbl_reitero_vendemas
select a.*,
       ROW_NUMBER() over (partition by id_comercio_F, N_Llave, N_Sem, Año order by fecha_inicio desc,id_ticket desc,canal asc) orden
into gdc..tbl_reitero_vendemas
from #tab36 as a




--select count(*) from gdc..tbl_reitero_vendemas
--select * from gdc..tbl_reitero_vendemas
-- CIERRE DE PROCESO


drop table #tab_reitero_1
select periodo, canal, N_Llave, Año, N_Sem, count(distinct id_comercio_F) as Q_Cod_Unicos_Reitero
into #tab_reitero_1
from gdc..tbl_reitero_vendemas as a
where orden > 1
group by periodo, canal, N_Llave, Año, N_Sem



drop table #tab_reitero_2
select periodo, canal, N_Llave, Año, N_Sem, count(distinct id_comercio_F) as Q_Cod_Unicos
into #tab_reitero_2
from gdc..tbl_reitero_vendemas as a
group by periodo, canal, N_Llave, Año, N_Sem



drop table #tab_reitero_3
select a.*, b.Q_Cod_Unicos
into #tab_reitero_3
from #tab_reitero_1 as a
left join #tab_reitero_2 as b on a.periodo = b.periodo and a.canal = b.canal and a.N_Llave = b.N_Llave and a.Año = b.Año and a.N_Sem = b.N_Sem


--select * from #tab_reitero_3

--select sum (q_cod_unicos) from #tab_reitero_3
--select sum (Q_Cod_Unicos_Reitero) from #tab_reitero_3
--select sum (cast(q_cod_unicos_reitero as float))/sum (q_cod_unicos) from #tab_reitero_3


alter table gdc..tbl_reitero_vendemas_pbi
drop column Gestion


insert into gdc..tbl_reitero_vendemas_pbi
select *
from #tab_reitero_3



	-- Validacion:

		 select * from #tab_reitero_3
		 select * from gdc..tbl_reitero_vendemas_pbi





-- Validaciones de logica de negocio:


		---- query con logica para validar reglas de negocio

		--select Año, periodo, N_Sem, fecha_inicio, id_comercio_F, id_comercio, N_Llave, id_ticket, orden
		--from gdc..tbl_reitero_vendemas
		--where id_comercio_F <> 0
		--and canal in ('INBOUND', 'Pool Whatsapp Postventa')
		--order by id_comercio_F, N_Llave, N_Sem, orden, periodo desc



		---- cálculo de retierados para numerador

		--select periodo, canal, count (distinct id_comercio_F) as q_id_cod_unicos_con_reitero
		--from gdc..tbl_reitero_vendemas
		--where id_comercio_F <> 0
		--and orden > 1
		--and nombre_comercio not like '%vendemas%'
		--and canal in ('INBOUND', 'Pool Whatsapp Postventa')
		--group by periodo, canal



		---- cálculo del total para denominador

		--select periodo, canal, count (distinct id_comercio_F) as q_id_cod_unicos_total
		--from gdc..tbl_reitero_vendemas
		--where id_comercio_F <> 0
		--and nombre_comercio not like '%vendemas%'
		--and canal in ('INBOUND', 'Pool Whatsapp Postventa')
		--group by periodo, canal
