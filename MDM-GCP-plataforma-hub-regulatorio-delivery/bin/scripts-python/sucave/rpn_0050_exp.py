from pyspark.sql import SparkSession
from pyspark.sql.functions import col, expr, lpad, lit, when, rpad, udf
from dataproc_delivery_plugin import get_spark_session, get_parquet_path_validacion, get_parquet_path_preexport, get_parquet_path_pre_validacion
from dataproc_delivery_plugin import get_parquet_path,read_table_as_df, Constantes, write_to_gcs_txt
from dataproc_delivery_plugin import get_last_day, get_path_inicio, Constantes, get_last_blob
from pyspark.sql.functions import concat_ws
from pyspark.sql.types import StringType
from pyspark.sql.functions import date_format
import re
from datetime import datetime
from calendar import monthrange
from dateutil.relativedelta import relativedelta
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

#def get_parquet_path_validacion(entidad,nombre_reporte,periodo,filename):

spark = get_spark_session("hr-dlv_to_exp_rpn0050")

ruta, inicio, lastdate = get_path_inicio(Constantes.C_RPN_0050)

C_YYMMDD = lastdate.replace("-","")[2:]  #ultimo dia mes formato  YYMMDD
C_YYYYMMDD = lastdate.replace("-","")  #ultimo dia mes formato  YYYYMMDD

nombre_reporte = "RPN0050"
nombre_archivo = f"01{C_YYMMDD}.048"
cabecera_estatica = f"00480100050{C_YYYYMMDD}012"

origen = get_parquet_path_pre_validacion(Constantes.C_REPORTES_SUCAVE,nombre_reporte,ruta)
ruta_parquet = get_parquet_path_validacion(Constantes.C_REPORTES_SUCAVE,nombre_reporte,ruta,get_last_blob(spark,origen))

# Leer archivos parquet y crear DataFrame
df = spark.read.parquet(ruta_parquet)

# Aplicar transformaciones de datos si es necesario

#Definir la UDF para validar caracteres extraños
def validate_str(x):
    #Después de aplicar strip(), si el resultado es una cadena vacía, not x.strip() será verdadero, y la función retornará None.
    #retornar None si x es None o si x no cumple con el patrón de la expresión regular, o si es de un solo carácter.
    if x is None or not x.strip() or len(x.strip()) == 1 or x.strip()=="NN" or re.match("^[a-zA-Z áéíóúÁÉÍÓÚñÑüÜ]*$", x) is None:
        return None
    else:
        return x

validate_str_udf = udf(validate_str, StringType())

# Aplicar la UDF a los campos relevantes
fields = ['ape_paterno_origen', 'ape_materno_origen', 'nom_primero_origen', 'nom_segundo_origen']
for field in fields:
    df = df.withColumn(field, validate_str_udf(col(field)))

# Calcular la condición de si todos los campos están nulos
condition_all_null = lit(True)  # Inicia como verdadero
for field in fields:
    condition_all_null = condition_all_null & col(field).isNull()

# Crear una columna temporal para marcar las filas donde todos los campos son nulos
df = df.withColumn("all_null", condition_all_null)

# Aplicar la lógica de reemplazo considerando la condición global y las condiciones individuales
for field in fields:
    df = df.withColumn(field, when(df["all_null"], "NN")
                       .otherwise(when(col(field).isNull(), "-").otherwise(col(field))))

# Eliminar la columna temporal
df = df.drop("all_null")
# Muestra el resultado (para temas de debugeo)
#df.show()

# Formateos adicionales a las columnas
df_data_report = df.select(lpad(col("numero_secuencia"), 6, " ").alias("NUMERO_SECUENCIA"),
                           rpad(col("ape_paterno_origen"), 40, " ").alias("APELLIDO_PATERNO"),
                           rpad(col("ape_materno_origen"), 40, " ").alias("APELLIDO_MATERNO"),
                           rpad(col("nom_primero_origen"), 40, " ").alias("PRIMER_NOMBRE"),
                           rpad(col("nom_segundo_origen"), 40, " ").alias("SEGUNDO_NOMBRE"),
                           when(col("tip_documento_origen").isNull() | col("num_documento_origen").isin("null",".") | col("num_documento_origen").isNull(),"-  ").otherwise(rpad(col("tip_documento_origen"), 3, " ")).alias("TIP_DOCUMENTO"),
                           when(col("num_documento_origen").isNull() | col("num_documento_origen").isin("null","."),"-           ").otherwise(rpad(col("num_documento_origen"), 12, " ")).alias("NUM_DOCUMENTO"), 
                           col("cod_producto_origen").alias("COD_PRODUCTO"),
                           lit("-").alias("RAYA"),
                           rpad(col("num_poliza"), 10, " ").alias("NUM_POLIZA"),
                           when(col("fec_hora_ocurrencia").isNull(),"        ").otherwise(date_format(col("fec_hora_ocurrencia"),'yyyyMMdd')).alias("FEC_HORA_OCURRENCIA"),
                           when(col("id_ubicacion_geografica").isNull() | col("id_ubicacion_geografica").isin("NO APLICA", "NO DETERMINADO"), lit("150100")).otherwise(lpad(col("id_ubicacion_geografica"), 6, "0")).alias("ID_UBICACION_GEOGRAFICA"),
                           rpad(col("num_placa"), 10, " ").alias("NUM_PLACA"),
                           when(col("nom_completo").isNull(), lit(" " * 120)).otherwise(rpad(col("nom_completo"), 120, " ")).alias("NOMBRE_COMPLETO"),
                           when(col("fecha_limite").isNull(),"        ").otherwise(date_format(col("fecha_limite"),'yyyyMMdd')).alias("FECHA_LIMITE"))
                       
#agrupamos los datos de las demas columnas en una sola, en una columna llamada cabecera_estatica
df_final = df_data_report.withColumn(cabecera_estatica, concat_ws("", *df_data_report.columns))
# Seleccionamos solo la cabecera estatica
df_export = df_final.select(cabecera_estatica)

# Escribir el contenido en un archivo de texto 

ruta_destino = get_parquet_path_preexport(Constantes.C_REPORTES_SUCAVE,nombre_reporte,ruta,get_last_blob(spark,origen),nombre_archivo)

write_to_gcs_txt(df_export,ruta_destino)
