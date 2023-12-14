--select top 10 *
--from gdc..base_tickets_niubiz

set datefirst 7

declare @periodo bigint
set @periodo = 202302


-- inicio de proceso


drop table #tab1
select *
into #tab1
from gdc..base_tickets_niubiz
where periodo = @periodo


drop table #tab2
select *
into #tab2
from #tab1
where tipo_ticket in ('SOLICITUDES DE CLIENTES')
and categoria_servicio in ('AVERÍAS')
and categoria_incidente in ('PROBLEMAS DE ACCESO')
and categoria_objeto in ('NO PUEDE RESETEAR CONTRASEÑA', 'PROBLEMAS CON USUARIOS', 'TERMINAL INVALIDO', 'PROBLEMAS PARA ACCEDER A LA PLATAFORMA', 
						 'TERMINAL BLOQUEADO', 'MANTENIMIENTO', 'PROBLEMAS PARA GENERAR USUARIOS', 'NO RECONOCE EL USUARIO')


drop table #tab3
select *
into #tab3
from #tab1
where tipo_ticket in ('SOLICITUDES DE CLIENTES')
and categoria_servicio in ('AVERÍAS')
and categoria_incidente in ('NO SE COMPLETA TRANSACCIÓN')
and categoria_objeto in ('MENSAJES DE DENEGACIÓN', 'NO SALE TRANSACCIÓN EXITOSA', 'NO SE CONCRETA EL PAGO AL PAGAHABIENTE')



drop table #tab4
select *
into #tab4
from #tab1
where tipo_ticket in ('SOLICITUDES DE CLIENTES')
and categoria_servicio in ('AVERÍAS')
and categoria_incidente in ('NO LLEGA CONFIRMACIÓN DE VENTA')
and categoria_objeto in ('MENSAJES DE CONFIRMACIÓN EN PLATAFORMAS', 'NO SE GENERÓ VOUCHER', 'NO LLEGÓ EL EMAILING', 'TRANSACCIÓN CON DATOS INCOMPLETOS')



drop table #tab5
select *
into #tab5
from #tab1
where tipo_ticket in ('SOLICITUDES DE CLIENTES')
and categoria_servicio in ('AVERÍAS')
and categoria_incidente in ('ERROR DE REPORTERÍA')
and categoria_objeto in ('NO PUEDE IMPRIMIR CIERRE DE LOTE', 'NO DESCARGA ARCHIVO EXCEL DE TRANSACCION', 'NO IMPRIME DETALLE DE TRANSACCIONES', 'ERROR EN REPORTE DE CARGOS',
						 'ARCHIVOS DE RESPUESTA', 'REPORTE DE DENEGACIONES', 'NO RECIBE ARCHIVO DE MOVIMIENTOS', 'DATA INCOMPLETA O ERRONEA')




drop table #tab6
select *
into #tab6
from #tab1
where tipo_ticket in ('SOLICITUDES DE CLIENTES')
and categoria_servicio in ('AVERÍAS')
and categoria_incidente in ('NO SE VISUALIZAN OPCIONES DEL MENÚ')



drop table #tab7
select *
into #tab7
from #tab1
where tipo_ticket in ('SOLICITUDES DE CLIENTES')
and categoria_servicio in ('AVERÍAS')
and categoria_incidente in ('ERROR DE COMUNICACIÓN')



drop table #tab8
select *
into #tab8
from #tab1
where tipo_ticket in ('SOLICITUDES DE CLIENTES')
and categoria_servicio in ('AVERÍAS')
and categoria_incidente in ('ERROR DE INTEGRACIÓN')




drop table #tab9
select *
into #tab9
from #tab1
where tipo_ticket in ('SOLICITUDES DE CLIENTES')
and categoria_servicio in ('AVERÍAS')
and categoria_incidente in ('PROBLEMAS EN PLATAFORMA')
and categoria_objeto in ('ERROR EN VOUCHER', 'MENSAJES DE ERROR EN PLATAFORMAS', 'ERRORES DE RECAUDACIÓN', 'ERROR EN IMPORTACIÓN DE AFILIACIONES', 
						 'SOLICITUDES DE AFILIACIÓN', 'ERROR EN IMPORTACIÓN DE CARGOS', 'ERROR AL INVOCAR UN API', 'PROBLEMAS PARA PROCESAR SOLICITUDES')



drop table #tab10
select *
into #tab10
from #tab1
where tipo_ticket in ('SOLICITUDES DE CLIENTES')
and categoria_servicio in ('AVERÍAS')
and categoria_incidente in ('PROBLEMAS DE HARDWARE')
and categoria_objeto in ('EQUIPO NO PRENDE', 'EQUIPO NO CARGA', 'PANTALLA ILEGIBLE', 'ERROR DE CHIP', 
						 'DAÑOS FÍSICOS DEL POS', 'TERMINAL BLOQUEADO', 'VOUCHER ILEGIBLE', 'POS INHIBIDO', 'LECTURA DE TARJETA')



drop table #tab11
select *
into #tab11
from #tab1
where tipo_ticket in ('SOLICITUDES DE CLIENTES')
and categoria_servicio in ('AVERÍAS')
and categoria_incidente in ('NIUBIZ EN LÍNEA')
and categoria_objeto in ('PROBLEMAS PARA ACCEDER PLATAFORMA', 'NO PUEDE RESETEAR CONTRASEÑA', 'PROBLEMAS EN GENERAR USUARIO', 'NO VISUALIZA CODIGOS',
						 'NO VISUALIZA DOCUMENTOS', 'NO VISUALIZA OPCIONES DEL MENU', 'NO PUEDE ACTUALIZAR DATOS', 'PROBLEMAS CON SOLICITUDES',
						 'NO PUEDE DESCARGAR DOCUMENTOS', 'NO PUEDE ACCEDER A OPCIONES DEL MENÚ')



drop table #tab12
select *
into #tab12
from #tab1
where tipo_ticket in ('SOLICITUDES DE CLIENTES')
and categoria_servicio in ('AVERÍAS')
and categoria_incidente in ('SIN DIAGNOSTICO')



drop table #tab13
select *
into #tab13
from #tab1
where tipo_ticket in ('SOLICITUDES DE CLIENTES')
and categoria_servicio in ('CONSULTAS')
and categoria_incidente in ('CONCILIACIONES')
and categoria_objeto in ('DETALLE DE VENTAS', 'DETALLE DE ABONOS', 'CONSULTA DE DEUDA')



drop table #tab14
select *
into #tab14
from #tab1
where tipo_ticket in ('SOLICITUDES DE CLIENTES')
and categoria_servicio in ('CONSULTAS')
and categoria_incidente in ('EDUCACIÓN')
and categoria_objeto in ('BENEFICIOS NIUBIZ', 'TARIFAS Y COMISIONES', 'USO DE PLATAFORMAS', 'PRODUCTOS', 'PROCESOS')




drop table #tab15
select *
into #tab15
from #tab1
where tipo_ticket in ('SOLICITUDES DE CLIENTES')
and categoria_servicio in ('DERIVACIONES Y CALL BACK')
and categoria_incidente in ('DEVOLUCIÓN DE LLAMADA')




drop table #tab16
select *
into #tab16
from #tab1
where tipo_ticket in ('SOLICITUDES DE CLIENTES')
and categoria_servicio in ('DERIVACIONES Y CALL BACK')
and categoria_incidente in ('RETENCIONES')




drop table #tab17
select *
into #tab17
from #tab1
where tipo_ticket in ('SOLICITUDES DE CLIENTES')
and categoria_servicio in ('RECLAMOS')
and categoria_incidente in ('CARGOS NO RECONOCIDOS', 'LIBRO DE RECLAMACIONES')



drop table #tab18
select *
into #tab18
from #tab1
where tipo_ticket in ('SOLICITUDES DE CLIENTES')
and categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('ABONO PENDIENTE')
and categoria_objeto in ('ANULACIÓN AUTOMÁTICA', 'ANULACIÓN EFECTUADA POR EL COMERCIO', 'COBRO DE MENOS', 'PROPINAS', 'TRANSACCIÓN NO ABONADA')




drop table #tab19
select *
into #tab19
from #tab1
where tipo_ticket in ('SOLICITUDES DE CLIENTES')
and categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('ANULACIONES Y DEVOLUCIONES')
and categoria_objeto in ('A SOLICITUD DEL COMERCIO', 'DUPLICIDAD POR FALLA DE POS', 'ERROR DE DIGITACIÓN', 'NO IMPRESIÓN DE VOUCHER', 'SIN SISTEMA')



drop table #tab20
select *
into #tab20
from #tab1
where tipo_ticket in ('SOLICITUDES DE CLIENTES')
and categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('SERVICIOS ADICIONALES - TRAX FINANCIERA')
and categoria_objeto in ('CARGO DEMORADO', 'DCC', 'DEPÓSITO PREVIO', 'PAGA RÁPIDO', 'PRE AUTORIZACIONES', 'CASHBACK', 'PROPINAS', 'RESERVA GARANTIZADA',
						 'MULTIMARCA', 'DATEAME', 'BILLETERAS', 'GIFTCARD', 'NIUBIZ GO')




drop table #tab21
select *
into #tab21
from #tab1
where tipo_ticket in ('SOLICITUDES DE CLIENTES')
and categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('SERVICIOS ADICIONALES - TRAX DATA', 'SERVICIOS ADICIONALES – TRAX DATA')
and categoria_objeto in ('PUBLICIDAD PUNTO DE VENTA', 'VOUCHER DIGITAL', 'APERTURA DE CANALES', 'PRESTAMOS', 'NIUBIZ MEDIA', 'FLOTAS',
						 'CTA. SUELDO BCP', 'QROMA', 'OH GIFTCARD', 'PUNTOS GNB', 'DESCUENTOS RIPLEY', 'PROMOTICK ZONACARDS', 'CUPONATIC',
						 'LIFEMILES', 'GROUPON', 'SUSCRIPTORES EL COMERCIO', 'MUNI MIRAFLORES', 'NOCHES VISA', 'BBVA BENEFICIOS', 'PUNTOS BBVA',
						 'CTA SUELDO IBK', 'MILLAS IBK', 'PUNTOS BANBIF', '	HOLISTIC BANBIF', 'DESCUENTOS CAJA AREQUIPA', 'SUMA', 'POS SOS')




drop table #tab22
select *
into #tab22
from #tab1
where tipo_ticket in ('SOLICITUDES DE CLIENTES')
and categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('CONFIGURACIONES DE BIN')



drop table #tab23
select *
into #tab23
from #tab1
where tipo_ticket in ('SOLICITUDES DE CLIENTES')
and categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('CAMBIO DE DIVISAS')




drop table #tab24
select *
into #tab24
from #tab1
where tipo_ticket in ('SOLICITUDES DE CLIENTES')
and categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('MIGRACIONES')
and categoria_objeto in ('MODALIDAD DE PLAN', 'MIGRACIÓN CÓDIGOS BENEFICIARIOS')



drop table #tab25
select *
into #tab25
from #tab1
where tipo_ticket in ('SOLICITUDES DE CLIENTES')
and categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('CAMBIO DE ESTADO')
and categoria_objeto in ('DESAFILIACIÓN', 'DESAFILIACIÓN', 'REACTIVACIÓN CÓDIGO PERMANENTE')




drop table #tab26
select *
into #tab26
from #tab1
where tipo_ticket in ('SOLICITUDES DE CLIENTES')
and categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('CAPACITACIÓN')
and categoria_objeto in ('USO DE PLATAFORMAS', 'PROCESOS', 'PROCESOS', 'BENEFICIOS NIUBIZ', 'TARIFAS Y COMISIONES')




drop table #tab27
select *
into #tab27
from #tab1
where tipo_ticket in ('SOLICITUDES DE CLIENTES')
and categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('LIBERACIÓN')




drop table #tab28
select *
into #tab28
from #tab1
where tipo_ticket in ('SOLICITUDES DE CLIENTES')
and categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('MATERIALES Y ACCESORIOS')
and categoria_objeto in ('CINTAS CONTOMETROS', 'MATERIAL POP', 'REIMPRESIÓN QR')




drop table #tab29
select *
into #tab29
from #tab1
where tipo_ticket in ('SOLICITUDES DE CLIENTES')
and categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('MODIFICACIÓN DE DATOS DE CONTACTO')
and categoria_objeto in ('CREACIÓN DE CONTACTO', 'MODIFICACIÓN DE TELEFONOS', 'MODIFICACIÓN DE DIRECCIÓN ADMINISTRATIVA', 'MODIFICACIÓN DE CONTACTO', 
						 'MODIFICACIÓN DE CONTACTO / CORREO', 'MODIFICACIÓN DE DIRECCIÓN COMERCIAL')




drop table #tab30
select *
into #tab30
from #tab1
where tipo_ticket in ('SOLICITUDES DE CLIENTES')
and categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('MODIFICACIÓN DE DATOS TRANSACCIONALES')
and categoria_objeto in ('MODIFICACION CORREO ARCHIVO MOVIMIENTOS', 'MODIFICACIÓN DE CUENTA BANCARIA', 'MODIFICACIÓN DE MCC (NAC-INT)')



drop table #tab31
select *
into #tab31
from #tab1
where tipo_ticket in ('SOLICITUDES DE CLIENTES')
and categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('MODIFICACIÓN DE DATOS TRIBUTARIOS')
and categoria_objeto in ('MODIFICACIÓN DE RAZÓN SOCIAL', 'MODIFICACIÓN DE CORREO DAE', 'ADICIONAR REPRESENTANTE LEGAL', 'MODIFICACIÓN DE REPRESENTANTE LEGAL',
						 'MODIFICACIÓN DE NOMBRE COMERCIAL')



drop table #tab32
select *
into #tab32
from #tab1
where tipo_ticket in ('SOLICITUDES DE CLIENTES')
and categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('MODIFICACIÓN DE PARÁMETROS')
and categoria_objeto in ('MONTOS MIN./MÁX.', 'CÓDIGO CID/BID', 'DE SEGURIDAD', 'TIPO DE LIQUIDACIÓN', 'GRUPO COMERCIO', 'MODIFICACION IP', 'MODIFICACION DE FORMATOS')




drop table #tab33
select *
into #tab33
from #tab1
where tipo_ticket in ('SOLICITUDES DE CLIENTES')
and categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('ORDEN DE SERVICIO')
and categoria_objeto in ('AMPLIACIÓN', 'CONFIGURACIÓN MULTICOMERCIOS', 'CONFIGURACIÓN OPERADOR', 'INSTALACIÓN', 'REEMPLAZO', 'REINSTALACIÓN', 'RETIRO')




drop table #tab34
select *
into #tab34
from #tab1
where tipo_ticket in ('SOLICITUDES DE CLIENTES')
and categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('ROBO DE POS')



drop table #tab35
select *
into #tab35
from #tab1
where tipo_ticket in ('SOLICITUDES DE CLIENTES')
and categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('PERMISOS LEY DEL CONSUMIDOR')
and categoria_objeto in ('PERMISO PARA APLICAR A CAMP. TELEMERC', 'PERMISO PARA MODIFICAR  DATOS PERSONALES')



drop table #tab36
select *
into #tab36
from #tab1
where tipo_ticket in ('SOLICITUDES DE CLIENTES')
and categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('DERECHOS ARCO')
and categoria_objeto in ('ACCESO', 'RECTIFICACION', 'RECTIFICACION', 'OPOSICION')




drop table #tab37
select *
into #tab37
from #tab1
where tipo_ticket in ('SOLICITUDES DE CLIENTES')
and categoria_servicio in ('REQUERIMIENTOS')
and categoria_incidente in ('REPORTES Y DOCUMENTACIÓN')
and categoria_objeto in ('SOLICITUD DE DOCUMENTO AUTORIZADO', 'ENTREGA DE DOCUMENTACIÓN', 'SOLICITUD DE CONTRATO', 'INFORME TÉCNICO', 'SOLICITUD DETALLE DE CÓDIGOS AFILIADOS',
						 'SOLICITUD DE DETALLE DE TRANSACCIONES', 'REGISTRO ARCHIVO DE MOVIMIENTOS CORREO', 'REGISTRO ARCHIVO DE MOVIMIENTOS SFTP', 'NOTA DE DÉBITO', 
						 'NOTA DE DEBITO', 'CARTA NO ADEUDO')




drop table #tab38
select *
into #tab38
from #tab1
where tipo_ticket in ('SOLICITUDES DE NEGOCIO')
and categoria_servicio in ('SERVICIOS ADICIONALES - TRAX FINANCIERA')
AND categoria_incidente IN ('CASHBACK', 'DATEAME', 'MULTIMARCA', 'PAGA RÁPIDO', 'CARGO DEMORADO', 'DCC', 'DEPÓSITO PREVIO', 'PRE AUTORIZACIONES',
							'PROPINAS', 'RESERVA GARANTIZADA')







drop table #tab39
select *
into #tab39
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

	union all
	
	select * from #tab35

	union all
	
	select * from #tab36

	union all
	
	select * from #tab37
	  
	union all
	
	select * from #tab38

	) as subquery2


	--select * from #tab39

delete from #tab39
where codigo_comercio = '#'

delete from #tab39
where ruc = 20341198217

delete from #tab39
where ruc = 20602370497

delete from #tab39
where pool = ''

delete from #tab39
where pool is null

delete from #tab39 
where codigo_comercio is null

drop table #tab40
select a.*,
       (categoria_servicio + categoria_incidente + categoria_objeto) as N_Llave,
	   DATEPART(week, convert(datetime2,fecha_id,11)) as N_Sem,
	   SUBSTRING(cast(periodo as varchar),1,4) as Año
into #tab40
from #tab39 as a



drop table gdc..tbl_reitero
select a.*,
       ROW_NUMBER() over (partition by codigo_comercio, N_Llave, Año, N_Sem order by fecha_id desc,id_ticket desc,pool asc) orden
into gdc..tbl_reitero
from #tab40 as a






-- CIERRE DE PROCESO


--select distinct fecha_id,N_Sem from gdc..tbl_reitero order by fecha_id

--select count(*) from gdc..tbl_reitero
--select * from gdc..tbl_reitero






--  CREAR VISTA PARA POWER BI




drop table #tab_reitero_1
select periodo, pool, N_Llave, Año, N_Sem, count(distinct codigo_comercio) as Q_Cod_Unicos_Reitero
into #tab_reitero_1
from gdc..tbl_reitero as a
where orden > 1
group by periodo, pool, N_Llave, Año, N_Sem


--select sum(q_cod_unicos_reitero) from #tab_reitero_1
--select * from #tab_reitero_1

drop table #tab_reitero_2
select periodo, pool, N_Llave, Año, N_Sem, count(distinct codigo_comercio) as Q_Cod_Unicos
into #tab_reitero_2
from gdc..tbl_reitero as a
group by periodo, pool, N_Llave, Año, N_Sem

--select * from #tab_reitero_2

drop table #tab_reitero_3
select a.*, b.Q_Cod_Unicos
into #tab_reitero_3
from #tab_reitero_1 as a
left join #tab_reitero_2 as b on a.periodo = b.periodo and a.pool = b.pool and a.N_Llave = b.N_Llave and a.Año = b.Año and a.N_Sem = b.N_Sem


--select sum(q_cod_unicos_reitero) from #tab_reitero_3

--select sum(q_cod_unicos)  from #tab_reitero_3

--select sum(cast(q_cod_unicos_reitero as float))/sum(q_cod_unicos) from #tab_reitero_3


alter table gdc..tbl_reitero_niubiz_pbi
drop column gestion

update #tab_reitero_3
set Q_Cod_Unicos_Reitero=0
where Q_Cod_Unicos_Reitero is null

insert into gdc..tbl_reitero_niubiz_pbi
select periodo,pool,N_Llave,Año,N_Sem,Q_Cod_Unicos_Reitero,Q_Cod_Unicos
from #tab_reitero_3


	-- Validacion: validar que la tabla final y la temporal final cuadran en forma

		--select * from #tab_reitero_3
		--select * from gdc..tbl_reitero_niubiz_pbi





-- INICIO DE VALIDACIONES



		---- query con logica para validar reglas de negocio

		--select Año, periodo, N_Sem, fecha_id, codigo_comercio, N_Llave, id_ticket, orden
		--from gdc..tbl_reitero_1
		--where codigo_comercio <> '#'
		--and ruc <> 20341198217
		--and ruc <> 20602370497
		--and pool <> ''
		--order by codigo_comercio, N_Llave, N_Sem, orden, periodo desc


		---- cálculo de retierados para numerador

		--select periodo, pool, count (distinct codigo_comercio) as q_cod_unicos_con_reitero
		--from gdc..tbl_reitero
		--where codigo_comercio <> '#'
		--and orden > 1
		--and ruc <> 20341198217
		--and ruc <> 20602370497
		--and pool <> ''
		--group by periodo, pool

		---- cálculo del total para denominador

		--select periodo, pool, count (distinct codigo_comercio) as q_cod_unicos_total
		--from gdc..tbl_reitero
		--where codigo_comercio <> '#'
		--and ruc <> 20341198217
		--and ruc <> 20602370497
		--and pool <> ''
		--group by periodo, pool




		--select canal, count (*) as q_tickets from gdc..base_tickets_vendemas where periodo >= 202204 group by canal


		--select distinct categoria_servicio
		--from #tab1
		--where tipo_ticket in ('SOLICITUDES DE NEGOCIO')

		--select distinct categoria_incidente
		--from #tab1
		--where tipo_ticket in ('SOLICITUDES DE NEGOCIO')
		--and categoria_servicio in ('SERVICIOS ADICIONALES - TRAX FINANCIERA')

		--select distinct categoria_objeto
		--from #tab1
		--where tipo_ticket in ('SOLICITUDES DE NEGOCIO')
		--and categoria_servicio in ('SERVICIOS ADICIONALES - TRAX FINANCIERA')