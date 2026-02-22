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


nombre_reporte = "RPN0064"

spark = get_spark_session("hr-univ_to_dlv_rpn0064")

##Orígenes script
##`rs-prd-dlk-dd-stging-f0e1.stg_modelo_persona.direccion_persona`
##`rs-prd-dlk-dd-stging-f0e1.stg_modelo_persona.persona`
##`rs-shr-al-analyticsz-prj-ebc1.anl_siniestro.siniestro_movimientos`
##`rs-shr-al-analyticsz-prj-ebc1.anl_produccion.prima_devengada_rrgg`

##Declaración datasets
DATASET_PERSONA = 'uni_modelo_persona'
DATASET_ANL_SINIESTRO = 'uni_modelo_anl_siniestro'
DATASET_ANL_PRODUCCION='uni_modelo_anl_produccion'

##Declaración campos necesarios en tablas
parameters_direccion_persona = [
 "id_persona",
 "des_departamento",
 "des_provincia",
 "periodo"
]

parameters_siniestro_movimientos = [
"id_poliza",
"id_contratante",
"mnt_movimiento_sol_np",
"mes_movimiento"
]

parameters_persona = [
"id_persona",
"des_departamento",
"des_provincia"
]

parameters_prima_devengada=[
    "periodo",
	"des_dpto_contratante",
	"des_provincia_contratante",
    "mnt_prima_retenida1_dev_sol",
    "mnt_comision_np_dev_sol",
    "periodo",
    "pro_id_producto",
    "des_dpto_contratante"
]


###Definiciones de valores para filtrar datasets

id_producto_valor='AX-2003'
id_origen_valor='AX'

##Lectura de tablas


df_direccion_persona = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_PERSONA,'direccion_persona')).select(*parameters_direccion_persona).filter(col("id_producto") == id_producto_valor)

df_siniestro_movimientos = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_ANL_SINIESTRO,'siniestro_movimietnos')).select(*parameters_siniestro_movimientos)

df_persona = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_PERSONA,'persona')).select(*parameters_persona)

df_prima_devengada=spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_ANL_PRODUCCION,'prima_devengada_rrgg')).select(*parameters_prima_devengada).filter(col("pro_id_producto") == id_producto_valor)

df_persona_documento_identidad=spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_PERSONA,'persona_documento_identidad'))

df_poliza = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_POLIZA,'poliza'))

## Df´s a temporales

df_direccion_persona.createOrReplaceTempView("direccion_persona")
df_siniestro_movimientos.createOrReplaceTempView("siniestro_movimientos")
df_persona.createOrReplaceTempView("persona")
df_prima_devengada.createOrReplaceTempView("prima_devengada")
df_persona_documento_identidad.createOrReplaceTempView("persona_documento_identidad")
df_poliza.createOrReplaceTempView("poliza")

##Persona desglosado

df_persona = spark.sql("""select per.*,pdi.tip_documento, pdi.num_documento, pdi.ind_documento_principal
                                        ,per.nom_completo 
                                from persona_documento_identidad pdi
                                left join persona per 
                                on  pdi.id_persona = per.id_persona
                                """)
df_persona.createOrReplaceTempView("persona")

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



##CTE's


direccion_persona_cte = spark.sql("""
  SELECT * 
  FROM (
    SELECT id_persona, des_departamento, des_provincia, periodo,
      MAX(periodo) OVER (PARTITION BY id_persona ORDER BY periodo DESC) AS max_periodo
    FROM direccion_persona
  )
  WHERE periodo = max_periodo
""")

direccion_persona_cte.persona.createOrReplaceTempView("persona")

persona_cte =spark.sql ("""
 SELECT A.id_persona,A.tip_documento,num_documento,A.ind_documento_principal,B.des_departamento, B.des_provincia,
 FROM persona AS A
 LEFT JOIN direccion_persona B on A.id_persona=B.id_persona
 WHERE A.ind_documento_principal = '1'
""")

persona_cte.createOrReplaceTempView("persona")



poliza_cte=sparl.sql("""
  SELECT po.id_poliza, po.num_poliza, po.id_contratante, pe.des_departamento, pe.des_provincia
  FROM  poliza po
  INNER JOIN persona pe
  ON po.id_contratante = pe.id_persona
""")

poliza_cte.createOrReplaceTempView("poliza")

siniestro_movimientos_cte =spark.sql("""
  SELECT
    date(concat(substr(mes_movimiento,1,4),'-',substr(mes_movimiento,5,2),'-01')) AS periodo,
    id_poliza,
    id_contratante,
    mnt_movimiento_sol_np
  FROM siniestro_movimientos
  WHERE 
  periodo >= '2000-01-01'
  AND concat(substr(mes_movimiento,1,4),'-',substr(mes_movimiento,5,2),'-01') BETWEEN {fecha[2]} AND {fecha[0]}
  AND tip_movimiento_siniestro = 'RESERVA'
""")

siniestro_movimientos_cte.createOrReplaceTempView("siniestro_movimientos")

siniestros_cte=spark.sql("""
  SELECT
    s.periodo,
    p.des_departamento,
    p.des_provincia,
    sum(s.mnt_movimiento_sol_np) AS mnt_movimiento_sol_np
  FROM siniestro_movimientos s
  left join poliza p
    on s.id_poliza = p.id_poliza
    AND s.id_contratante = p.id_contratante
  WHERE s.periodo BETWEEN BETWEEN {fecha[2]} AND {fecha[0]}
    AND p.des_departamento not IN ('')
  GROUP BY 1,2,3
  ORDER BY 2,3
 """ )

siniestros.createOrReplaceTempView("siniestros")

primas_cte=spark.sql ("""
	SELECT
		p.periodo,
		p.des_dpto_contratante,
		p.des_provincia_contratante,
		ROUND(SUM(p.mnt_prima_retenida1_dev_sol),2) AS mnt_prima_retenida1_dev_sol,
		ROUND(SUM(p.mnt_comision_np_dev_sol),2) AS mnt_comision_np_dev_sol
	FROM prima_devengada p
	WHERE p.periodo BETWEEN BETWEEN {fecha[2]} AND {fecha[0]}
		  AND p.des_dpto_contratante NOT IN ('','ND')
	GROUP BY 1,2,3
	ORDER BY 1,2,3
""")

primas_cte.createOrReplaceTempView("primas")

df_reporte_64=spark.sql("""SELECT
	p.periodo,
	p.des_dpto_contratante,
	p.des_provincia_contratante,
	(p.mnt_prima_retenida1_dev_sol - p.mnt_comision_np_dev_sol - ifnull(s.mnt_movimiento_sol_np,0)) AS RT
FROM primas p
LEFT JOIN siniestros s
	ON p.periodo = s.periodo
	AND p.des_dpto_contratante = s.des_departamento
	AND p.des_provincia_contratante = s.des_provincia
ORDER BY 1,2,3
""")

destino = get_parquet_path_pre_validacion(Constantes.C_REPORTES_MINTRA,nombre_reporte,ruta)
destino_final = get_parquet_path_validacion(Constantes.C_REPORTES_MINTRA,nombre_reporte,ruta, validar_version(get_last_blob(spark,destino)))

write_to_gcs(df_reporte_64, destino_final)