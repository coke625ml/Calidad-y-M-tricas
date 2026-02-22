from pyspark.sql import SparkSession
from pyspark.sql.functions import col, expr, lpad, lit, when, rpad, round
from dataproc_delivery_plugin import get_spark_session, get_parquet_path_validacion, get_parquet_path_preexport
from dataproc_delivery_plugin import get_parquet_path,read_table_as_df, Constantes, write_to_gcs_txt
from pyspark.sql.functions import concat_ws, regexp_replace
from dataproc_delivery_plugin import get_path_inicio,get_last_day, get_last_blob, get_parquet_path_pre_validacion
from datetime import datetime
from calendar import monthrange
from dateutil.relativedelta import relativedelta
from pyspark.sql.types import StringType
from pyspark.sql.functions import date_format, to_date

#def get_parquet_path_validacion(entidad,nombre_reporte,periodo,filename):

spark = get_spark_session("hr-dlv_to_exp_rpn0005")

ruta, inicio =get_path_inicio(Constantes.C_RPN_0004)
lastdate = get_last_day(inicio)

C_YYMMDD = lastdate.strftime('%y%m%d') #ultimo dia mes  YYMMDD
C_YYYYMMDD = lastdate.strftime('%Y%m%d')  #ultimo dia mes  YYYYMMDD

nombre_reporte = "RPN0004"
nombre_archivo = f"01{C_YYMMDD}.051"
cabecera_estatica = f"00510100050{C_YYYYMMDD}012000000000000000"

origen = get_parquet_path_pre_validacion(Constantes.C_REPORTES_SUCAVE,nombre_reporte,ruta)
ruta_parquet = get_parquet_path_validacion(Constantes.C_REPORTES_SUCAVE,nombre_reporte,ruta,get_last_blob(spark, origen))

# Leer archivos parquet y crear DataFrame
df = spark.read.parquet(ruta_parquet)

# Aplicar transformaciones de datos si es necesario
df_data_report = df.select(lpad(col("numero_secuencia"), 6, "0").alias("NUMERO_SECUENCIA"),
                           col("tipo_contratacion").alias("TIPO_CONTRATACION"), 
                           when(col("cod_sbs").isNull(), "00000").otherwise(col("cod_sbs")).alias("COD_SDS"),
                           rpad(col("tipo_poliza"),2," ").alias("TIPO_POLIZA"),
                           lpad(col("cod_producto_origen"), 9, "0").alias("COD_PRODUCTO"),
                           col("num_poliza").alias("NRO_POLIZA"),
                           lpad(col("num_certificado"), 15, "0").alias("NUM_CERTIFICADO"),
                           lit("000000000000000").alias("NRO_COBERTURA_PROVISIONAL"),
                           date_format(col("fec_emision"), 'yyyyMMdd').alias("FEC_EMISION"),
                           date_format(col("fec_inicio_vigencia"), 'yyyyMMdd').alias("FEC_INICIO_VIGENCIA"),
                           date_format(col("fec_fin_vigencia"), 'yyyyMMdd').alias("FEC_FIN_VIGENCIA"),
                           col("categoria_mto_suma_asegurada"),
                           lpad((round(col("primaneta"), 2) * 100).cast("integer").cast("string"), 18, "0").alias("PRIMA"),
                           col("forma_de_pago").alias("FORMA_DE_PAGO"), 
                           when(col("fecha_pago_contado").isNull(),"        ").otherwise(date_format(col("fecha_pago_contado"),'yyyyMMdd')).alias("FECHA_PAGO_CONTADO"),
                           when(col("fec_vencimiento1").isNull(),"        ").otherwise(date_format(col("fec_vencimiento1"),'yyyyMMdd')).alias("FECHA_DE_VENCIMIENTO_1"),
                           when(col("fec_vencimiento2").isNull(),"        ").otherwise(date_format(col("fec_vencimiento2"),'yyyyMMdd')).alias("FECHA_DE_VENCIMIENTO_2"),
                           when(col("fec_vencimiento3").isNull(),"        ").otherwise(date_format(col("fec_vencimiento3"),'yyyyMMdd')).alias("FECHA_DE_VENCIMIENTO_3"),
                           when(col("fec_vencimiento4").isNull(),"        ").otherwise(date_format(col("fec_vencimiento4"),'yyyyMMdd')).alias("FECHA_DE_VENCIMIENTO_4"),
                           when(col("fec_vencimiento5").isNull(),"        ").otherwise(date_format(col("fec_vencimiento5"),'yyyyMMdd')).alias("FECHA_DE_VENCIMIENTO_5"),
                           when(col("fec_vencimiento6").isNull(),"        ").otherwise(date_format(col("fec_vencimiento6"),'yyyyMMdd')).alias("FECHA_DE_VENCIMIENTO_6"),
                           when(col("fec_vencimiento7").isNull(),"        ").otherwise(date_format(col("fec_vencimiento7"),'yyyyMMdd')).alias("FECHA_DE_VENCIMIENTO_7"),
                           when(col("fec_vencimiento8").isNull(),"        ").otherwise(date_format(col("fec_vencimiento8"),'yyyyMMdd')).alias("FECHA_DE_VENCIMIENTO_8"),
                           when(col("fec_vencimiento9").isNull(),"        ").otherwise(date_format(col("fec_vencimiento9"),'yyyyMMdd')).alias("FECHA_DE_VENCIMIENTO_9"),
                           when(col("fec_vencimiento10").isNull(),"        ").otherwise(date_format(col("fec_vencimiento10"),'yyyyMMdd')).alias("FECHA_DE_VENCIMIENTO_10"),
                           when(col("fec_vencimiento11").isNull(),"        ").otherwise(date_format(col("fec_vencimiento11"),'yyyyMMdd')).alias("FECHA_DE_VENCIMIENTO_11"),
                           when(col("fec_vencimiento12").isNull(),"        ").otherwise(date_format(col("fec_vencimiento12"),'yyyyMMdd')).alias("FECHA_DE_VENCIMIENTO_12"))

#agrupamos los datos de las demas columnas en una sola, en una columna llamada cabecera_estatica
df_final = df_data_report.withColumn(cabecera_estatica, concat_ws("", *df_data_report.columns))
# Seleccionamos solo la cabecera estatica
df_export = df_final.select(cabecera_estatica)

# Escribir el contenido en un archivo de texto

ruta_destino = get_parquet_path_preexport(Constantes.C_REPORTES_SUCAVE,nombre_reporte,ruta,get_last_blob(spark,origen),nombre_archivo)

write_to_gcs_txt(df_export,ruta_destino)
