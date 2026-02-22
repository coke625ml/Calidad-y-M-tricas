from pyspark.sql import SparkSession
from pyspark.sql.functions import col, expr, lpad, lit, when
from dataproc_delivery_plugin import get_spark_session, get_parquet_path_validacion, get_parquet_path_preexport, get_parquet_path_pre_validacion
from dataproc_delivery_plugin import get_parquet_path,read_table_as_df, Constantes, write_to_gcs_txt
from dataproc_delivery_plugin import get_last_day, get_path_inicio, Constantes, get_last_blob
from pyspark.sql.functions import concat_ws
from datetime import datetime
from calendar import monthrange
from dateutil.relativedelta import relativedelta
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

#def get_parquet_path_validacion(entidad,nombre_reporte,periodo,filename):

spark = get_spark_session("hr-dlv_to_exp_rpn0005")

ruta, inicio =get_path_inicio(Constantes.C_RPN_0005)
lastdate =   get_last_day(inicio)

C_YYMMDD = lastdate.strftime('%y%m%d') #ultimo dia mes formato YYMMDD
C_YYYYMMDD = lastdate.strftime('%Y%m%d')  #ultimo dia mes formato  YYYYMMDD

nombre_reporte = "RPN0005"
nombre_archivo = f"02{C_YYMMDD}.051"
cabecera_estatica = f"00510200050{C_YYYYMMDD}012000000000000000"

origen = get_parquet_path_pre_validacion(Constantes.C_REPORTES_SUCAVE,nombre_reporte,ruta)
ruta_parquet = get_parquet_path_validacion(Constantes.C_REPORTES_SUCAVE,nombre_reporte,ruta,get_last_blob(spark,origen))

# Leer archivos parquet y crear DataFrame
df = spark.read.parquet(ruta_parquet)

# Aplicar transformaciones de datos si es necesario
df_data_report = df.select(lpad(col("numero_secuencia"), 6, "0").alias("NUMERO_SECUENCIA"),
                           when(col("CODSBS").isNull(), "00000").otherwise(col("CODSBS")).alias("CODSBS"), 
                           lpad(col("cod_prod"), 9, "0").alias("COD_PROD"),
                           col("NRO_POLIZA"),
                           lpad(col("NUM_CERTIFICADO"), 15, "0").alias("NUM_CERTIFICADO"),
                           lit("000000000000000").alias("NRO_COBERTURA_PROVISIONAL"),
                           col("FECHA_EMISION"),
                           col("FECHA_INICIO_VIGENCIA"),
                           col("FECHA_FIN_VIGENCIA"),
                           col("MOTIVO_REPORTE"),
                           col("FECHA"))

#agrupamos los datos de las demas columnas en una sola, en una columna llamada cabecera_estatica
df_final = df_data_report.withColumn(cabecera_estatica, concat_ws("", *df_data_report.columns))
# Seleccionamos solo la cabecera estatica
df_export = df_final.select(cabecera_estatica)

# Escribir el contenido en un archivo de texto

ruta_destino = get_parquet_path_preexport(Constantes.C_REPORTES_SUCAVE,nombre_reporte,ruta,get_last_blob(spark,origen),nombre_archivo)

write_to_gcs_txt(df_export,ruta_destino)
