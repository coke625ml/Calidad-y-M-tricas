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
from dataproc_delivery_plugin import get_path_inicio, Constantes, get_last_blob, validar_version, write_to_gcs_coalesce_1
from dataproc_delivery_plugin import get_parquet_path_validacion, formatear_fecha
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


nombre_reporte = "RPN0063"

spark = get_spark_session("hr-univ_to_dlv_rpn0063")

DATASET_ANALYTICS = 'analytics'


# --------------------CAMPOS UTILIZADOS PARA EL RPN0062-------------------


parameters_produccion = [
    'departamento',
    'provincia',
    'mnt_prima_np_usd',
    'tc_a_sol',
    'periodo',
    'id_producto',
    'ind_acumulado'
]
    

# ------------------------------------------------------------------

id_producto_valor='AX-2003'

df_produccion = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_ANALYTICS,'produccion')).select(*parameters_produccion).where(col("id_producto")==id_producto_valor)

df_produccion.createOrReplaceTempView("produccion")


ruta, inicio = get_path_inicio(Constantes.C_RPN_0063)

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
  SELECT '{0}' AS periodo, departamento, provincia, round(sum(mnt_prima_np_usd * tc_a_sol),2) AS mnt_prima_np_sol
  FROM produccion
  WHERE YEAR(periodo) = YEAR(DATE '{0}')
  AND periodo <= DATE '{0}'
  AND id_producto='AX-2003'
  AND ind_acumulado='PRODUCCION'
  AND provincia NOT IN ('','ND')
  GROUP BY 1,2,3
  ORDER BY 2,3
"""

# DataFrame vacío para almacenar el resultado de la unión
df_reporte_63 = None

for fecha in fechas_str:
    # Filtrar los DataFrames por fecha
    df_filtrado = spark.sql(consulta_spark.format(fecha))

    # Realizar la unión de los DataFrames filtrados
    if df_reporte_63 is None:
        df_reporte_63 = df_filtrado
    else:
        df_reporte_63 = df_reporte_63.union(df_filtrado)

df_reporte_63.createOrReplaceTempView("df_reporte_63")

df_agrupado = spark.sql("""
    SELECT * FROM df_reporte_63
    ORDER BY 1, 2, 3
""")

df_agrupado.createOrReplaceTempView("df_agrupado")

#Formateo

# Paso 1: Pivoteo

# Pivotar el DataFrame para convertir los valores de periodo en columnas
df_pivot = df_agrupado.groupBy("departamento", "provincia") \
    .pivot("periodo") \
    .sum("mnt_prima_np_sol")

mes_2 = formatear_fecha(fechas[2])
mes_1 = formatear_fecha(fechas[1])
mes_0 = formatear_fecha(fechas[0])

# Renombrar las columnas pivotadas a los nombres de los meses
# Esto dependerá de los datos específicos de tu 'periodo'
df_reporte_63_final_1 = df_pivot \
    .withColumnRenamed(fechas_str[2], mes_2) \
    .withColumnRenamed(fechas_str[1], mes_1) \
    .withColumnRenamed(fechas_str[0], mes_0)

# Formatear los valores numéricos a strings con formato de moneda

df_reporte_63_final_1_formateado = df_reporte_63_final_1.withColumn(mes_2, F.format_number(F.col(mes_2), 2))\
                                                        .withColumn(mes_1, F.format_number(F.col(mes_1), 2))\
                                                        .withColumn(mes_0, F.format_number(F.col(mes_0), 2))

df_reporte_63_final_1_formateado.createOrReplaceTempView("df_reporte_63_final_1_formateado")

df_reporte_63_final = spark.sql("""
    SELECT  departamento AS DEPARTAMENTO,
            provincia as PROVINCIA,
            `{0}`, 
            `{1}`, 
            `{2}`
    FROM df_reporte_63_final_1_formateado
""".format(mes_2, mes_1, mes_0))


# Paso 2: Calcular subtotales por departamento
df_total_por_departamento = spark.sql("""
    SELECT departamento,
           periodo,
           round(sum(mnt_prima_np_sol),2) AS total_por_departamento
    FROM df_agrupado
    GROUP BY departamento, periodo
    ORDER BY 1, 2
""")

# Pivotar el DataFrame para convertir los valores de periodo en columnas
df_pivot_2 = df_total_por_departamento.groupBy("departamento") \
    .pivot("periodo") \
    .sum("total_por_departamento")

# Renombrar las columnas pivotadas a los nombres de los meses
# Esto dependerá de los datos específicos de tu 'periodo'
df_reporte_63_final_2 = df_pivot_2 \
    .withColumnRenamed(fechas_str[2], mes_2) \
    .withColumnRenamed(fechas_str[1], mes_1) \
    .withColumnRenamed(fechas_str[0], mes_0)

# Formatear los valores numéricos a strings con formato de moneda

df_reporte_63_final_2_formateado = df_reporte_63_final_2.withColumn(mes_2, F.format_number(F.col(mes_2), 2))\
                                                        .withColumn(mes_1, F.format_number(F.col(mes_1), 2))\
                                                        .withColumn(mes_0, F.format_number(F.col(mes_0), 2))
                                                        
df_reporte_63_final_2_formateado.createOrReplaceTempView("df_reporte_63_final_2_formateado")

df_reporte_63_final_subtotales = spark.sql("""
    SELECT  departamento AS DEPARTAMENTO,
            "" as PROVINCIA,
            `{0}`, 
            `{1}`, 
            `{2}`
    FROM df_reporte_63_final_2_formateado
""".format(mes_2, mes_1, mes_0))

# calculando total general

# Paso 3: Calcular total general

df_total = spark.sql("""
    SELECT periodo,
           round(sum(mnt_prima_np_sol),2) AS total
    FROM df_agrupado
    GROUP BY periodo
    ORDER BY 1
""")

# Pivotar el DataFrame para convertir los valores de periodo en columnas
df_pivot_3 = df_total.groupBy("periodo")\
    .pivot("periodo") \
    .sum("total")

# Renombrar las columnas pivotadas a los nombres de los meses
# Esto dependerá de los datos específicos de tu 'periodo'
df_reporte_63_final_3 = df_pivot_3 \
    .withColumnRenamed(fechas_str[2], mes_2) \
    .withColumnRenamed(fechas_str[1], mes_1) \
    .withColumnRenamed(fechas_str[0], mes_0)
    
df_total_agg = df_reporte_63_final_3.agg(
    F.sum(F.col(mes_2)).alias(mes_2),
    F.sum(F.col(mes_1)).alias(mes_1),
    F.sum(F.col(mes_0)).alias(mes_0)
)
# Formatear los valores numéricos a strings con formato de moneda

df_reporte_63_final_3_formateado = df_total_agg.withColumn(mes_2, F.format_number(F.col(mes_2), 2))\
                                               .withColumn(mes_1, F.format_number(F.col(mes_1), 2))\
                                               .withColumn(mes_0, F.format_number(F.col(mes_0), 2))

df_reporte_63_final_3_formateado.createOrReplaceTempView("df_reporte_63_final_3_formateado")

df_reporte_63_final_total = spark.sql("""
    SELECT  "TOTAL GENERAL" AS DEPARTAMENTO,
            "" as PROVINCIA,
            `{0}`, 
            `{1}`, 
            `{2}`
    FROM df_reporte_63_final_3_formateado
""".format(mes_2, mes_1, mes_0))

df_reporte_63_final_total.createOrReplaceTempView("df_reporte_63_final_total")


# Uniendo subtotales al dataframe principal
# Paso 4

df_departamentos =  spark.sql("""
    SELECT DISTINCT departamento
    FROM df_agrupado
    ORDER BY 1
    """)


# DataFrame acumulativo para almacenar el resultado final
df_reporte_63_resultado_final = None

for departamento in df_departamentos.collect():
    # Filtrar las filas de df_reporte_63_final para el departamento actual
    df_temp_reporte_0 = df_reporte_63_final.filter(F.col("DEPARTAMENTO") == departamento.departamento)
    
    # Definir la ventana de partición por DEPARTAMENTO y ordenar por PROVINCIA para mantener el orden
    windowSpec = Window.partitionBy("DEPARTAMENTO").orderBy("PROVINCIA")
    # Agregar una columna temporal que enumera las filas dentro de cada DEPARTAMENTO
    df_temp = df_temp_reporte_0.withColumn("row_num", row_number().over(windowSpec))
    # Reemplazar los valores de DEPARTAMENTO con null excepto para la primera fila de cada grupo
    df_temp_reporte = df_temp.withColumn("DEPARTAMENTO", when(col("row_num") == 1, col("DEPARTAMENTO")).otherwise(None))
    #Eliminamos la columna temporal row_num ya que no la necesitamos
    df_temp_reporte = df_temp_reporte.drop("row_num")
    
    # Filtrar la fila correspondiente en df_reporte_63_final_subtotales para el departamento actual
    df_temp_subtotal = df_reporte_63_final_subtotales.filter(F.col("DEPARTAMENTO") == departamento.departamento)
    df_temp_subtotal.createOrReplaceTempView("df_temp_subtotal")
    df_temp_subtotal_2 = spark.sql("""
    SELECT  CONCAT('TOTAL ',DEPARTAMENTO) AS DEPARTAMENTO,
            "" as PROVINCIA,
            `{0}`, 
            `{1}`, 
            `{2}`
    FROM df_temp_subtotal
    """.format(mes_2, mes_1, mes_0))
    
    # Unir las filas de reporte con la fila de subtotal
    df_temp_unido = df_temp_reporte.union(df_temp_subtotal_2)
    
    # Unir este resultado con el DataFrame acumulativo
    if df_reporte_63_resultado_final is None:
        df_reporte_63_resultado_final = df_temp_unido
    else:
        df_reporte_63_resultado_final = df_reporte_63_resultado_final.union(df_temp_unido)

# Paso 5 o Final : Unir el total general al DataFrame acumulativo

df_reporte_63_resultado_final_ultimo = df_reporte_63_resultado_final.union(df_reporte_63_final_total)


destino = get_parquet_path_pre_validacion(Constantes.C_REPORTES_MINTRA,nombre_reporte,ruta)
destino_final = get_parquet_path_validacion(Constantes.C_REPORTES_MINTRA,nombre_reporte,ruta, validar_version(get_last_blob(spark,destino)))

write_to_gcs_coalesce_1(df_reporte_63_resultado_final_ultimo, destino_final)
#