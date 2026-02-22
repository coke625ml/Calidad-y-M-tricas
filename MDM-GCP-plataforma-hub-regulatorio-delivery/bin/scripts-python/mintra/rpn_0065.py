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
from datetime import datetime

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


nombre_reporte = "RPN0065"

spark = get_spark_session("hr-univ_to_dlv_rpn0065")

DATASET_POLIZA = 'uni_modelo_poliza'
DATASET_ANALYTICS = 'analytics'

# --------------------CAMPOS UTILIZADOS PARA EL RPN0065-------------------
parameters_siniestro_generales = [
    "num_poliza",
    "num_siniestro",
    "num_placa_siniestro_veh"
]

parameters_siniestro_movimientos = [
        'num_poliza',
        'num_siniestro',
        'num_certificado',
        'num_siniestro',
        'fec_ocurrencia_siniestro',
        'des_causa_siniestro',
        'mnt_movimiento_usd_np',
        'id_siniestro',
        'mes_movimiento',
        'id_producto'
]

parameters_vehiculo = [
    "num_placa",
    "info_soat_des_uso_vehiculo_soat"
]


# ------------------------------------------------------------------

id_producto_valor='AX-2003'
id_origen_valor='AX'

# Lectura por particion en funcion del producto(id_producto='AX-2003')
df_siniestro_generales = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_ANALYTICS,'siniestro_generales')).filter(col("id_producto") == id_producto_valor).select(*parameters_siniestro_generales)

#  Lectura por particion en funcion del producto(id_producto='AX-2003')
df_siniestro_movimientos = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_ANALYTICS,'siniestro_movimientos')).filter(col("id_producto") == id_producto_valor).select(*parameters_siniestro_movimientos)


df_vehiculo = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_POLIZA,'vehiculo')).select(*parameters_vehiculo)



df_siniestro_generales.createOrReplaceTempView("siniestro_generales")
df_siniestro_movimientos.createOrReplaceTempView("siniestro_movimientos")
df_vehiculo.createOrReplaceTempView("vehiculo")



ruta, inicio = get_path_inicio(Constantes.C_RPN_0065)


fecha_recibida = inicio.replace('-', '')

fecha1 = datetime.strptime(fecha_recibida, "%Y%m%d")
fecha2 = str(spark.sql(f"SELECT last_day(add_months('{fecha1}', -1)) AS fecha").collect()[0][0])
fecha3 = str(spark.sql(f"SELECT last_day(add_months('{fecha1}', -2)) AS fecha").collect()[0][0])
fecha1=str(fecha1)

fechas = [fecha1, fecha2, fecha1]


query = """
WITH siniestros_placa AS (
  SELECT 
    num_poliza,
    num_siniestro,
    num_placa_siniestro_veh
  FROM `rs-shr-al-analyticsz-prj-ebc1.anl_siniestro.siniestro_generales`
  WHERE periodo = '{fecha}'
    AND id_producto = 'AX-2003'
),
vehiculos AS (
  SELECT DISTINCT num_placa, info_soat_des_uso_vehiculo_soat
  FROM (
    SELECT num_placa, i.info_soat_des_uso_vehiculo_soat,
    row_number() over (partition by num_placa ORDER BY periodo DESC) orden
    FROM `rs-shr-al-analyticsz-prj-ebc1.anl_vehiculo.parque_automotor`,
    UNNEST(info_soat) i
    WHERE info_soat_des_uso_vehiculo_soat IS NOT NULL
  )
  WHERE orden=1
  AND info_soat_des_uso_vehiculo_soat IS NOT NULL
)
SELECT 
 '{fecha}' as periodo, 
 '2003 - SOAT' AS producto,
 s.num_poliza,
 s.num_certificado,
 substr(s.id_siniestro,4,CHAR_LENGTH(s.id_siniestro)) as idesin,
 '' AS agraviado,
 s.num_siniestro,
 s.fec_ocurrencia_siniestro,
 s.des_causa_siniestro,
 v.info_soat_des_uso_vehiculo_soat,
 sum(s.mnt_movimiento_usd_np) mnt_movimiento_usd_np 
FROM `rs-shr-al-analyticsz-prj-ebc1.anl_siniestro.siniestro_movimientos` s
LEFT JOIN siniestros_placa sp ON sp.num_poliza = s.num_poliza and sp.num_siniestro = s.num_siniestro  
LEFT JOIN vehiculos v on sp.num_placa_siniestro_veh = v.num_placa
WHERE s.periodo >= '2000-01-01'
AND tip_movimiento_siniestro = 'PAGO' 
AND concat(substr(s.mes_movimiento,1,4),'-',substr(s.mes_movimiento,5,2),'-01')
  BETWEEN CAST(DATE_SUB('{fecha}', INTERVAL 11 MONTH) AS STRING) AND '{fecha}'
AND s.id_producto = 'AX-2003'
group by 
s.num_poliza,
s.num_certificado,
substr(s.id_siniestro,4,CHAR_LENGTH(s.id_siniestro)),
s.num_siniestro,
s.fec_ocurrencia_siniestro,
s.des_causa_siniestro,
v.info_soat_des_uso_vehiculo_soat
"""

# Recopilar resultados para cada fecha y unirlos
dataframes = []

for fecha in fechas:
    consulta = query.format(fecha=fecha)
    df = spark.sql(consulta)
    dataframes.append(df)

# Unir todos los DataFrames
resultado_df = dataframes[0]

for df in dataframes[1:]:
    resultado_df = resultado_df.union(df)

destino = get_parquet_path_pre_validacion(Constantes.C_REPORTES_MINTRA,nombre_reporte,ruta)
destino_final = get_parquet_path_validacion(Constantes.C_REPORTES_MINTRA,nombre_reporte,ruta, validar_version(get_last_blob(spark,destino)))

write_to_gcs(df_reporte_50, destino_final)