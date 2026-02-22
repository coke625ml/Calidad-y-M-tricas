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
from datetime import datetime
from dateutil.relativedelta import relativedelta
from pyspark.sql.window import Window
from dataproc_delivery_plugin import get_spark_session, write_to_gcs, get_parquet_path,read_table_as_df, get_parquet_path_pre_validacion
from dataproc_delivery_plugin import get_path_inicio, Constantes, get_last_blob, validar_version
from dataproc_delivery_plugin import get_parquet_path_validacion, formatear_fecha
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


nombre_reporte = "RPN0062"

spark = get_spark_session("hr-univ_to_dlv_rpn0062")

DATASET_POLIZA = 'uni_modelo_poliza'
DATASET_ANALYTICS = 'analytics'


# --------------------CAMPOS UTILIZADOS PARA EL RPN0062-------------------




parameters_vehiculo = [
    "num_placa",
    "des_tipo",
    "periodo"
]
    

parameters_prima_devengada_rrgg = [
        'pro_cod_producto_origen',
        'mnt_prima_emitida_dev_usd',
        'periodo',
        'pol_id_poliza',
        'cer_id_certificado',
        'pro_id_producto',
        'veh_num_placa'
]


parameters_siniestro_generales = [
        'mto_total_reserva_usd',
        'periodo_ocurrencia',
        'pol_id_poliza',
        'id_certificado',
        'id_producto',
        'periodo'
]

# ------------------------------------------------------------------

id_producto_valor='AX-2003'


df_vehiculo = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_POLIZA,'vehiculo')).select(*parameters_vehiculo)

df_prima_devengada_rrgg = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_ANALYTICS,'prima_devengada_rrgg')).select(*parameters_prima_devengada_rrgg).where(col("pro_id_producto")==id_producto_valor)

df_siniestro_generales = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_ANALYTICS,'siniestro_generales')).select(*parameters_siniestro_generales).where(col("id_producto")==id_producto_valor)



df_vehiculo.createOrReplaceTempView("vehiculo")
df_prima_devengada_rrgg.createOrReplaceTempView("prima_devengada_rrgg")
df_siniestro_generales.createOrReplaceTempView("siniestro_generales")


ruta, inicio = get_path_inicio(Constantes.C_RPN_0062)

df_info_vehi = spark.sql("""
    SELECT DISTINCT num_placa, des_tipo FROM (
      SELECT num_placa, des_tipo,
      row_number() over (partition by num_placa ORDER BY periodo DESC) orden
      FROM vehiculo
    ) where orden=1 """).createOrReplaceTempView("info_vehi")

# Convertir la fecha de inicio a datetime
fecha_inicio_dt = datetime.strptime(inicio, '%Y-%m-%d')

# Calcular las fechas de un mes antes y dos meses antes
fechas = [
    fecha_inicio_dt,
    fecha_inicio_dt - relativedelta(months=1),
    fecha_inicio_dt - relativedelta(months=2)
]

# Convertir las fechas a string en el formato deseado
fechas_str = [fecha.strftime('%Y-%m-%d') for fecha in fechas]

consulta_spark = """
  SELECT
     '{0}' AS periodo,
    concat(p.pro_cod_producto_origen, ' - SOAT') AS producto,
    CASE v.des_tipo
      WHEN 'AMBULANCIA' THEN 'AMBULANCIA'
      WHEN 'AUTO' THEN 'AUTO'
      WHEN 'BARANDA' THEN 'BARANDA'
      WHEN 'BARREDORA' THEN 'BARREDORA'
      WHEN 'BOMBERO' THEN 'BOMBERO'
      WHEN 'CAJON' THEN 'CAJON'
      WHEN 'CAMARA ISOTERMICA' THEN 'CAMARA ISOTERMICA'
      WHEN 'CARGADOR FRONTAL' THEN 'CARGADOR FRONTAL'
      WHEN 'CISTERNA' THEN 'CISTERNA'
      WHEN 'COMPACTADORA' THEN 'COMPACTADORA'
      WHEN 'CUATRIMOTO' THEN 'CUATRIMOTO'
      WHEN 'FRIGORIFICO' THEN 'FRIGORIFICO'
      WHEN 'FURGON' THEN 'FURGON'
      WHEN 'GRUA' THEN 'GRUA'
      WHEN 'HORMIGONERA' THEN 'HORMIGONERA'
      WHEN 'INTERCAMBIADOR' THEN 'INTERCAMBIADOR'
      WHEN 'LOCOMOTORA' THEN 'LOCOMOTORA'
      WHEN 'LUBRICADOR' THEN 'LUBRICADOR'
      WHEN 'MAQUINARIA PESADA' THEN 'MAQUINARIA PESADA'
      WHEN 'RETROESCABADORA' THEN 'RETROESCABADORA'
      WHEN 'MEZCLADORA' THEN 'MEZCLADORA'
      WHEN 'MICROBUS' THEN 'MICROBUS'
      WHEN 'MINIBUS' THEN 'MINIBUS'
      WHEN 'MONTACARGA' THEN 'MONTACARGA'
      WHEN 'MOTO' THEN 'MOTO'
      WHEN 'MOTONIVELADORA' THEN 'MOTONIVELADORA'
      WHEN 'MULTIPROPOSITO' THEN 'MULTIPROPOSITO'
      WHEN 'OMNIBUS' THEN 'OMNIBUS'
      WHEN 'PANEL' THEN 'PANEL'
      WHEN 'PAVIMENTADOR' THEN 'PAVIMENTADOR'
      WHEN 'PERFORADOR' THEN 'PERFORADOR'
      WHEN 'PICK UP 4X2' THEN 'PICK UP'
      WHEN 'PICK UP 4X4' THEN 'PICK UP'
      WHEN 'PLATAFORMA' THEN 'PLATAFORMA'
      WHEN 'REMOLCADOR' THEN 'REMOLCADOR'
      WHEN 'TRACTO / REMOLCADOR' THEN 'REMOLCADOR'
      WHEN 'RURAL' THEN 'RURAL'
      WHEN 'SEMI REMOLQUE' THEN 'SEMI REMOLQUE'
      WHEN 'STATION WAGON' THEN 'STATION WAGON'
      WHEN 'TRACTOR AGRICOLA' THEN 'TRACTOR AGRICOLA'
      WHEN 'TRIMOTO' THEN 'TRIMOTO'
      WHEN 'VAN' THEN 'VAN'
      WHEN 'VOLQUETE' THEN 'VOLQUETE'
      ELSE 'OTROS'
    END AS veh_des_tipo,
    round(sum(p.mnt_prima_emitida_dev_usd),2) AS mnt_prima_emitida_dev_usd,
    round(sum(ifnull(s.mto_total_reserva_usd,0)),2) AS mto_total_reserva_usd,
    round(round(sum(ifnull(s.mto_total_reserva_usd,0)),2) / round(sum(p.mnt_prima_emitida_dev_usd),2),2) AS siniestralidad
  FROM prima_devengada_rrgg p
  LEFT JOIN siniestro_generales s
    ON p.periodo = s.periodo_ocurrencia
    AND p.pol_id_poliza = s.pol_id_poliza
    AND p.cer_id_certificado = s.id_certificado
    AND p.pro_id_producto = s.id_producto
    AND s.periodo = DATE '{0}'
    AND s.periodo_ocurrencia BETWEEN add_months(DATE '{0}', -12) AND DATE '{0}'
  LEFT JOIN info_vehi v
    ON p.veh_num_placa = v.num_placa
  WHERE p.periodo BETWEEN add_months(DATE '{0}', -12) AND DATE '{0}'
    AND p.pro_id_producto = 'AX-2003'
  GROUP BY 1,2,3
  ORDER BY 3
"""

# DataFrame vacío para almacenar el resultado de la unión
df_reporte_62 = None

for fecha in fechas_str:
    # Filtrar los DataFrames por fecha
    df_filtrado = spark.sql(consulta_spark.format(fecha))
    
    # Realizar la unión de los DataFrames filtrados
    if df_reporte_62 is None:
        df_reporte_62 = df_filtrado
    else:
        df_reporte_62 = df_reporte_62.union(df_filtrado)

df_reporte_62.createOrReplaceTempView("df_reporte_62")

df_agrupado = spark.sql("""
    SELECT * FROM df_reporte_62
    ORDER BY 1, 3
""")

df_agrupado.createOrReplaceTempView("df_agrupado")

#Formateo

# Paso 1: Pivoteo

# Pivotar el DataFrame para convertir los valores de periodo en columnas
df_pivot = df_agrupado.groupBy("veh_des_tipo") \
    .pivot("periodo") \
    .sum("siniestralidad")


mes_2 = formatear_fecha(fechas[2])
mes_1 = formatear_fecha(fechas[1])
mes_0 = formatear_fecha(fechas[0])

# Renombrar las columnas pivotadas a los nombres de los meses
# Esto dependerá de los datos específicos de tu 'periodo'
df_reporte_62_final_1 = df_pivot \
    .withColumnRenamed(fechas_str[2], mes_2) \
    .withColumnRenamed(fechas_str[1], mes_1) \
    .withColumnRenamed(fechas_str[0], mes_0)

# Formatear los valores numéricos a strings con formato de moneda

df_reporte_62_final_1_formateado = df_reporte_62_final_1.withColumn(mes_2, F.format_string("%d%%", (F.col(mes_2) * 100).cast("int")))\
                                                        .withColumn(mes_1, F.format_string("%d%%", (F.col(mes_1) * 100).cast("int")))\
                                                        .withColumn(mes_0, F.format_string("%d%%", (F.col(mes_0) * 100).cast("int")))  


df_reporte_62_final_1_formateado.createOrReplaceTempView("df_reporte_62_final_1_formateado")

df_reporte_62_final = spark.sql("""
    SELECT  veh_des_tipo AS `USO DE VEHICULO`,
            `{0}`, 
            `{1}`, 
            `{2}`
    FROM df_reporte_62_final_1_formateado
""".format(mes_2, mes_1, mes_0))

destino = get_parquet_path_pre_validacion(Constantes.C_REPORTES_MINTRA,nombre_reporte,ruta)
destino_final = get_parquet_path_validacion(Constantes.C_REPORTES_MINTRA,nombre_reporte,ruta, validar_version(get_last_blob(spark,destino)))

write_to_gcs(df_reporte_62_final, destino_final)
#