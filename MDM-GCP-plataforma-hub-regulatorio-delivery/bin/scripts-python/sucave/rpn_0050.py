import pyspark
import datetime
import pyspark.sql.functions as F
# from pyspark.sql.functions import *
import calendar
from pyspark.sql.functions import broadcast,countDistinct,row_number,year, first, when, col
from pyspark.storagelevel import StorageLevel
import os
from pyspark.sql.types import StructType, StructField, IntegerType, StringType
from io import StringIO
from google.cloud import storage, bigquery
from pyspark.sql import *
from pathlib import Path
from pyspark.sql.window import Window
from dataproc_delivery_plugin import get_spark_session, write_to_gcs, get_parquet_path,read_table_as_df, get_parquet_path_pre_validacion
from dataproc_delivery_plugin import get_path_inicio, Constantes, get_last_blob, validar_version
from dataproc_delivery_plugin import get_parquet_path_validacion
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


nombre_reporte = "RPN0050"

spark = get_spark_session("hr-univ_to_dlv_rpn0050")

DATASET_POLIZA = 'uni_modelo_poliza'
DATASET_SINIESTRO = 'uni_modelo_siniestro'
DATASET_PERSONA = 'uni_modelo_persona'
# DATASET_COBRANZA = 'uni_modelo_cobranza'

# --------------------CAMPOS UTILIZADOS PARA EL RPN0050-------------------

parameters_poliza = [
    "id_poliza",
    "cod_producto_origen",
    "num_poliza",
    "nom_completo",
    "cod_producto_origen",
    "fec_inicio_vigencia",
    "des_estado_poliza", 
    "id_producto"
]


parameters_persona = [
     "id_persona",
     "nom_completo",
       
]

# parameters_siniestro = [
#      "id_siniestro",
#      "id_producto",
#      "fec_hora_ocurrencia",
#      "des_departamento_siniestro",
#      "des_distrito_siniestro",
#      "des_provincia_siniestro",
# ]

parameters_siniestro_vehicular = [
     "id_siniestro",
     "num_placa"
]

parameters_siniestro_agraviado = [
    "id_siniestro",
    "tip_documento_origen",
    "num_documento_origen",
    "ape_paterno_origen",
    "ape_materno_origen",
    "nom_primero_origen",
    "nom_segundo_origen"
]

# parameters_pre_liquidacion_siniestro = [
#     "id_siniestro",
#     "est_pre_liquidacion"
# ]
    
# ------------------------------------------------------------------

###Definiciones de valores para filtrar datasets


id_producto_valor='AX-2003'
id_origen_valor='AX'

# Lectura por particion en funcion del producto(id_producto='AX-2003')
df_poliza = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_POLIZA,'poliza')).filter(col("id_producto") == id_producto_valor)

#  Lectura por particion en funcion del producto(id_producto='AX-2003')
df_siniestro = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_SINIESTRO,'siniestro')).filter(col("id_producto") == id_producto_valor)


df_siniestro_vehicular = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_SINIESTRO,'siniestro_vehicular'))

df_ramo_siniestro = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_SINIESTRO,'ramo_siniestro'))

# Lectura particion con id_origen 'AX'
df_cobertura_siniestro = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_SINIESTRO,'cobertura_siniestro'))

df_siniestro_agraviado = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_SINIESTRO,'siniestro_agraviado')).select(
     *parameters_siniestro_agraviado )
     
df_persona  = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_PERSONA,'persona')).select(*parameters_persona)


df_siniestro_vehicular.createOrReplaceTempView("siniestro_vehicular")
df_ramo_siniestro.createOrReplaceTempView("ramo_siniestro")
df_siniestro_agraviado.createOrReplaceTempView("siniestro_agraviado")
df_cobertura_siniestro.createOrReplaceTempView("cobertura_siniestro")
df_siniestro.createOrReplaceTempView("siniestro")
df_poliza.createOrReplaceTempView("poliza")
df_persona.createOrReplaceTempView("PERSONA")


df_poliza_persona = spark.sql("""select po.*
                                        ,per.nom_completo 
                                from poliza po
                                left join PERSONA per 
                                on  po.id_contratante = per.id_persona
                                """)

df_poliza_persona.createOrReplaceTempView("poliza")
ruta, inicio ,fin = get_path_inicio(Constantes.C_RPN_0050)

df_periodo= spark.sql(f"""
    SELECT TO_DATE('{inicio}', 'yyyy-MM-dd') AS PERIODOINI,
           DATEADD(DAY,1,TO_DATE('{fin}', 'yyyy-MM-dd')) AS PERIODOFIN
""")

# periodo = df_periodo.selectExpr("date_format(PERIODOINI, 'yyyyMM') AS PERIODO").first()[0]

df_periodo.createOrReplaceTempView("PERIODO")

df_datos_reporte = spark.sql("""
  SELECT 
    PERIODOINI,
    CAST(PERIODOINI AS TIMESTAMP) AS TIMESTAMP_PERIODOINI, 
    CAST(PERIODOFIN AS TIMESTAMP) AS TIMESTAMP_PERIODOFIN,
    CAST(DATEADD(YEAR, -2, PERIODOFIN) AS TIMESTAMP) AS TIMESTAMP_FECHA_OCURRENCIA,
    'AX-2003' id_producto, 
    'AX-SOAT-SO01' id_cobertura_uno,
    'MUERTE' des_consecuencia,
    'AX-SOAT' id_ramo
 FROM 
    PERIODO
""")

df_datos_reporte.createOrReplaceTempView("datos_reporte")
# ----------------------------------------


# Cargar las tablas necesarias


# Filtrar siniestros_base
siniestros_base = spark.sql("""
SELECT 
    sini.id_siniestro, 
    pol.id_poliza, 
    sini.fec_hora_ocurrencia, 
    pol.num_poliza,
    pol.nom_completo,
    pol.cod_producto_origen,
    sini.id_certificado, 
    sini.fec_notificacion,
    sini.des_departamento_siniestro,
    sini.des_provincia_siniestro,
    sini.des_distrito_siniestro ,
    sini.id_ubicacion_geografica,
    pol.fec_inicio_vigencia,
    pol.des_estado_poliza, 
    pol.id_producto, 
    sini.id_estado_siniestro_origen,
    sini.id_estado_siniestro
FROM 
    siniestro sini
JOIN 
    poliza pol 
ON 
    sini.id_poliza = pol.id_poliza
JOIN 
    datos_reporte  gen 
ON 
    sini.id_producto = gen.id_producto
WHERE 
    sini.fec_hora_ocurrencia >= gen.TIMESTAMP_FECHA_OCURRENCIA
    AND sini.fec_hora_ocurrencia < gen.TIMESTAMP_PERIODOFIN
    AND sini.fec_notificacion < gen.TIMESTAMP_PERIODOFIN
    AND sini.id_estado_siniestro_origen NOT IN ('ANU', 'CER', 'RCH')
""")

nfilas_sb=siniestros_base.count()
logger.info(f"nfilas_siniestros_base: {nfilas_sb}")

siniestros_base.createOrReplaceTempView("siniestros_base")

# Coberturas siniestros base
coberturas_siniestros_base = spark.sql("""
   select distinct cs.id_siniestro
     from datos_reporte gen,
          siniestros_base sb
    inner join cobertura_siniestro cs on cs.id_siniestro = sb.id_siniestro
    where 1 = 1
      and cs.id_cobertura = gen.id_cobertura_uno
      and cs.mto_aprobado = 0
      and cs.mto_reserva_usd > 105
""")

##CTES
nfilas_cs=coberturas_siniestros_base.count()
logger.info(f"nfilas_coberturas_siniestros: {nfilas_cs}")


coberturas_siniestros_base.createOrReplaceTempView("coberturas_siniestros_base")



# Consulta final

df_reporte_50=spark.sql("""
select
distinct
sini.id_siniestro
,sini.fec_hora_ocurrencia
,date_add(sini.fec_hora_ocurrencia,730) as fecha_limite
,sini.id_poliza
,sini.id_certificado
,sini.num_poliza
,sini.id_producto
,sini.des_departamento_siniestro
,sini.des_provincia_siniestro
,sini.des_distrito_siniestro
,sini.id_ubicacion_geografica
,sini.cod_producto_origen
,sinveh.num_placa
,sini.id_estado_siniestro_origen
,sini.nom_completo
,sini.id_estado_siniestro
,rs.des_causa
,rs.des_consecuencia
,sia.tip_documento_origen
,sia.num_documento_origen
,sia.ape_paterno_origen
,sia.ape_materno_origen
,sia.nom_primero_origen
,sia.nom_segundo_origen
from datos_reporte gen, siniestros_base sini
inner join siniestro_vehicular sinveh on sinveh.id_siniestro = sini.id_siniestro
inner join ramo_siniestro rs on rs.id_siniestro = sini.id_siniestro and rs.id_ramo = gen.id_ramo
inner join siniestro_agraviado sia on sia.id_siniestro = sini.id_siniestro
where 1=1
and exists (
    select 1
      from coberturas_siniestros_base mr
     where mr.id_siniestro = sini.id_siniestro)
""")


# # windowSpec = Window.orderBy("id_siniestro")  # Usando "id_siniestro" como ejemplo, ajusta según tu contexto

# # # Agregar la columna "numero_secuencia" usando row_number()

# # df_reporte_50 = df_reporte_50.withColumn("numero_secuencia", F.row_number().over(windowSpec))
# # df_reporte_50 = df_reporte_50.select(
# #     "numero_secuencia",
# #     *df_reporte_50.columns[:-1]  # Seleccionar todas las columnas excepto "numero_secuencia"
# # )

# Contar de nuevo los registros en df_final y loguear la información
nreporte50 = df_reporte_50.count()
logger.info(f"nreporte50 después de agregar numero_secuencia: {nreporte50}")



windowSpec = Window.partitionBy("id_producto").orderBy("id_producto")

df_reporte_50 = df_reporte_50.withColumn("numero_secuencia", F.row_number().over(windowSpec))
#df_reporte4 = df_reporte4.withColumn("numero_secuencia", F.monotonically_increasing_id()+1)

df_reporte_50 = df_reporte_50.select(
    "numero_secuencia",
    *df_reporte_50.columns[:-1]  
)


destino = get_parquet_path_pre_validacion(Constantes.C_REPORTES_SUCAVE,nombre_reporte,ruta)
destino_final = get_parquet_path_validacion(Constantes.C_REPORTES_SUCAVE,nombre_reporte,ruta, validar_version(get_last_blob(spark,destino)))

write_to_gcs(df_reporte_50, destino_final)
#