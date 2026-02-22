import pyspark 
from pyspark.sql import *
import os
from google.cloud import storage, secretmanager
import argparse
import logging
import json
import datetime
from datetime import datetime
import dateutil
from dateutil.relativedelta import relativedelta
from datetime import datetime
from calendar import monthrange
import google_crc32c
import base64 as b64
import pandas as pd

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class Constantes: 
    P_ENVIRONMENT=None
    P_BUCKET_DATAPROC_FILES=None
    P_JSON_RELATIVE_PATH_SA_KEY_CREDENTIALS=None
    P_SOURCE_STAGING_PROJECT_ID=None
    P_SOURCE_ANALYTICS_PROJECT_ID=None
    P_SOURCE_RAW_PROJECT_ID=None
    P_BUCKET_UNIVERSAL_PQT_FILES=None
    P_BUCKET_DELIVERY_PQT_FILES=None
    P_PERIODO=None
    P_FECHA_ACTUAL=None
    P_SECRETS_PROJECT_ID = None
    P_SA_SECRET_ID = None   
    C_PROJECT_NAME="hub_regulatorio"
    C_CAPA_UNIVERSAL="universal"
    C_CAPA_DELIVERY="delivery"
    C_FORMATO_PARQUET="parquet"
    C_REPORTES_SUCAVE="sucave"
    C_REPORTES_MINTRA="mintra"
    C_BD_FALLECIDOS="bd_fallecidos"
    C_REPORTES_SUSALUD="susalud"
    C_CARPETA_VALIDACION="validacion"
    C_REPORTES_PREEXPORT="preexport"
    C_RPN_0005 = 5
    C_RPN_0004 = 4
    C_RPN_0050 = 50
    C_RPN_0062 = 62
    C_RPN_0063 = 63
    C_RPN_0064 = 64
    C_RPN_0065 = 65
    
    C_JSON = None

def access_secret_version_from_secret_manager(secret_id, secrets_project_id, version_id="latest"):
    # Create the Secret Manager client.
    client = secretmanager.SecretManagerServiceClient()

    # Build the resource name of the secret version.
    name = f"projects/{secrets_project_id}/secrets/{secret_id}/versions/{version_id}"

    # Access the secret version (needs Secret Manager Secret Accessor role)
    response = client.access_secret_version(request={"name": name})

    # Verify payload checksum.
    crc32c = google_crc32c.Checksum()
    crc32c.update(response.payload.data)
    if response.payload.data_crc32c != int(crc32c.hexdigest(), 16):
        print("Data corruption detected on access_secret_version_from_secret_manager.")
        return response

    print(f"{secret_id} successfully obtained from secret manager")

    # Return the decoded payload.
    return b64.b64encode(response.payload.data).decode("utf-8")

def get_spark_credentials():
    project_id = Constantes.P_SECRETS_PROJECT_ID
    secret_id  = Constantes.P_SA_SECRET_ID
    #version_id = "latest"
    return access_secret_version_from_secret_manager(secret_id,project_id)

    #bucket_dataproc_files = Constantes.P_BUCKET_DATAPROC_FILES
    #json_relative_path_sa_key_credentials = Constantes.P_JSON_RELATIVE_PATH_SA_KEY_CREDENTIALS
    #gcs_client = storage.Client()
    #bucket = gcs_client.bucket(bucket_dataproc_files)
    #json = bucket.blob(json_relative_path_sa_key_credentials)
    #json_str = json.download_as_text()
    #return b64.b64encode(json_str.encode('utf-8')).decode("utf-8")

def get_args_parser(parser):
    parser.add_argument('--P_ENVIRONMENT', type=str, help='The project ENVIRONMENT')
    parser.add_argument('--P_BUCKET_DATAPROC_FILES', type=str, help='The Dataproc bucket name')
    parser.add_argument('--P_JSON_RELATIVE_PATH_SA_KEY_CREDENTIALS', type=str, help='The relative path to json file of the sa to be used')
    parser.add_argument('--P_SOURCE_STAGING_PROJECT_ID', type=str, help='The project ID where are staging sources')
    parser.add_argument('--P_SOURCE_ANALYTICS_PROJECT_ID', type=str, help='The project ID where are analytics sources')
    parser.add_argument('--P_SOURCE_RAW_PROJECT_ID', type=str, help='The project ID where are raw sources')
    parser.add_argument('--P_BUCKET_UNIVERSAL_PQT_FILES', type=str, help='Bucket para datos de universal')
    parser.add_argument('--P_BUCKET_DELIVERY_PQT_FILES', type=str, help='Bucket para datos de delivery')
    parser.add_argument('--P_PERIODO', type=str, help='Periodo de ejecucion de job')
    parser.add_argument('--P_FECHA_ACTUAL', type=str, help='Fecha de solicitud de ejecucion')
    parser.add_argument('--P_SECRETS_PROJECT_ID', type=str, help='Proyecto donde se encuentran los secretos')
    parser.add_argument('--P_SA_SECRET_ID', type=str, help='Identificacion de secreto para service account')

    args = parser.parse_args()

    Constantes.P_ENVIRONMENT = getattr(args, "P_ENVIRONMENT")
    Constantes.P_BUCKET_DATAPROC_FILES = getattr(args, "P_BUCKET_DATAPROC_FILES")
    Constantes.P_JSON_RELATIVE_PATH_SA_KEY_CREDENTIALS = getattr(args, "P_JSON_RELATIVE_PATH_SA_KEY_CREDENTIALS")
    Constantes.P_SOURCE_STAGING_PROJECT_ID = getattr(args, "P_SOURCE_STAGING_PROJECT_ID")
    Constantes.P_SOURCE_ANALYTICS_PROJECT_ID = getattr(args, "P_SOURCE_ANALYTICS_PROJECT_ID")
    Constantes.P_SOURCE_RAW_PROJECT_ID = getattr(args, "P_SOURCE_RAW_PROJECT_ID")
    Constantes.P_BUCKET_UNIVERSAL_PQT_FILES = getattr(args, "P_BUCKET_UNIVERSAL_PQT_FILES")
    Constantes.P_BUCKET_DELIVERY_PQT_FILES = getattr(args, "P_BUCKET_DELIVERY_PQT_FILES")
    Constantes.P_BUCKET_DELIVERY_PQT_FILES = getattr(args, "P_BUCKET_DELIVERY_PQT_FILES")
    Constantes.P_PERIODO = getattr(args, "P_PERIODO")
    Constantes.P_FECHA_ACTUAL = getattr(args, "P_FECHA_ACTUAL")
    Constantes.P_SECRETS_PROJECT_ID = getattr(args, "P_SECRETS_PROJECT_ID")
    Constantes.P_SA_SECRET_ID = getattr(args, "P_SA_SECRET_ID")

def read_table_as_df(spark,project_id,dataset,table):
    return(
        spark.read.format('com.google.cloud.spark.bigquery.BigQueryRelationProvider')\
        .option('table', f"{project_id}.{dataset}.{table}")\
        .load()
    )

def write_to_gcs(df, path):
    df.write.mode("overwrite").parquet(path)

def write_to_gcs_coalesce_1(df, path):
    df.coalesce(1).write.mode("overwrite").parquet(path)

def write_to_gcs_txt(df, path):
    df_pandas = df.toPandas()
    df_pandas.to_csv(path, index=False, header=True, lineterminator="\r\n")

def upload_to_gcs(source_file_name, destination_blob_name):
    """Sube un archivo al bucket de GCS."""
    storage_client = storage.Client()
    bucket = storage_client.bucket(Constantes.P_BUCKET_DELIVERY_PQT_FILES)
    blob = bucket.blob(destination_blob_name)

    blob.upload_from_filename(source_file_name)

    print(f"Archivo {source_file_name} subido a {destination_blob_name}.")

def get_spark_session(p_appname):
    parser = argparse.ArgumentParser(description="Handle project ID argument")
    #se llenan variables de clase Constantes
    get_args_parser(parser)

    json_str = get_spark_credentials()

    spark = SparkSession\
                .builder\
                .appName(p_appname)\
                .getOrCreate()

    spark.conf.set("credentials", json_str)
    spark.conf.set("spark.sql.repl.eagerEval.enabled",True)
    spark.conf.set("spark.sql.parquet.datetimeRebaseModeInWrite", "LEGACY")
    spark.conf.set("spark.sql.parquet.int96RebaseModeInWrite", "LEGACY")
    spark.conf.set("spark.sql.legacy.timeParserPolicy", "LEGACY")

    return spark

def get_parquet_path(bucket,capa,modelo,tabla):
    return os.path.join("gs://",bucket,Constantes.C_PROJECT_NAME,capa,modelo,tabla)

def read_parquet_and_create_view(spark, bucket, capa, modelo, tabla, parameters, view_name):
    try:
        parquet_path = get_parquet_path(bucket, capa, modelo, tabla)
        df = spark.read.parquet(parquet_path).select(*parameters)
        df.createOrReplaceTempView(view_name)
        return df
    except Exception as e:
        print(f"Error al leer el parquet: {e}")
        return None


def read_parquet_and_create_view_with_partitions(spark, bucket, capa, modelo, tabla, parameters, view_name, lista_prefijo_particion1, particion1):
    dataframes = []
    
    base_path = get_parquet_path(bucket, capa, modelo, tabla)

    for prefijo_particion1 in lista_prefijo_particion1:
        try:
            particion_path = os.path.join(base_path, f"{particion1}={prefijo_particion1}")
            df = spark.read.parquet(particion_path).select(*parameters)
            dataframes.append(df)
        except Exception as e:
            print(f"Error al leer la partición {particion1}={prefijo_particion1}: {e}")
    
    if dataframes:
        df_final = dataframes[0]
        for df in dataframes[1:]:
            df_final = df_final.union(df)
    
        df_final.createOrReplaceTempView(view_name)
        return df_final
    else:
        print("No se encontraron DataFrames para las particiones especificadas.")
        return None    

def read_parquet_and_create_view_with_partitions_2(spark, bucket, capa, modelo, tabla, parameters, view_name, lista_prefijo_particion1, lista_prefijo_particion2, particion1, particion2):
    dataframes = []

    base_path = get_parquet_path(bucket,capa,modelo,tabla)

    for prefijo_particion1 in lista_prefijo_particion1:
        for prefijo_particion2 in lista_prefijo_particion2:
            try:
                # Construir el path del parquet con las particiones
                particion_path = os.path.join(base_path, f"{particion1}={prefijo_particion1}", f"{particion2}={prefijo_particion2}")
                
                # Leer el parquet y seleccionar los parámetros
                df = spark.read.parquet(particion_path).select(*parameters)
                dataframes.append(df)
            except Exception as e:
                print(f"Error al leer {particion1}={prefijo_particion1}/{particion2}={prefijo_particion2}: {e}")
    
    # Unir todos los DataFrames en uno solo
    if dataframes:
        df_final = dataframes[0]
        for df in dataframes[1:]:
            df_final = df_final.union(df)
    
        # Crear o reemplazar la vista temporal
        df_final.createOrReplaceTempView(view_name)
        return df_final
    else:
        print("No se encontraron DataFrames para las particiones especificadas.")
        return None

def get_parquet_path_pre_validacion(entidad,nombre_reporte,ruta):
     return get_parquet_path(Constantes.P_BUCKET_DELIVERY_PQT_FILES, \
                    Constantes.C_CAPA_DELIVERY, \
                    Constantes.C_CARPETA_VALIDACION, \
                    f"{entidad}/{nombre_reporte}/{ruta}/")

def get_parquet_path_validacion(entidad,nombre_reporte,periodo,version):
    return get_parquet_path(Constantes.P_BUCKET_DELIVERY_PQT_FILES, \
                    Constantes.C_CAPA_DELIVERY, \
                    Constantes.C_CARPETA_VALIDACION, \
                    f"{entidad}/{nombre_reporte}/{periodo}/{version}")

def get_parquet_path_preexport(entidad,nombre_reporte,periodo,version,filename):
    return get_parquet_path(Constantes.P_BUCKET_DELIVERY_PQT_FILES, \
                    Constantes.C_CAPA_DELIVERY, \
                    Constantes.C_REPORTES_PREEXPORT, \
                    f"{entidad}/{nombre_reporte}/{periodo}/{version}/{filename}")

def get_periodo():
    periodo = Constantes.P_FECHA_ACTUAL

    if Constantes.P_PERIODO != None and Constantes.P_PERIODO != "":
        periodo =Constantes.P_PERIODO

    return periodo

def get_path_inicio(id_reporte):
    periodo = get_periodo()
    if len(periodo) != 8: raise ValueError("El período debe tener 8 caracteres en formato 'yyyyMMdd'.")
    if id_reporte == 4:
        if periodo !=  Constantes.P_FECHA_ACTUAL:
            #scritp ruta
            ruta = periodo[:6] + "-01"
            #scritp inicio
            fecha_actual = datetime.strptime(periodo, "%Y%m%d")
            inicio = fecha_actual.replace(day=1).strftime('%Y-%m-%d')
        else:
            periodo = datetime.strptime(periodo, "%Y%m%d")
            inicio_mes_pasado = periodo - relativedelta(months=1)
            #scritp ruta
            ruta = inicio_mes_pasado.strftime("%Y%m") + "-01"
            #scritp inicio
            inicio = inicio_mes_pasado.replace(day=1).strftime('%Y-%m-%d')
        return ruta, inicio 
    if id_reporte == 5:
        #ya no se consulta si es FECHA ACTUAL(el codigo es el mismo ya sea automatico o manual)
        #scritp ruta  
        ruta = periodo[:6] + "-01"
        #scritp inicio
        fecha_actual = datetime.strptime(periodo, "%Y%m%d")
        inicio = fecha_actual.replace(day=1).strftime('%Y-%m-%d')
        return ruta, inicio
    if id_reporte == 50:
        #Ya no se valida que el periodo no sea la automatica o manual ya que es el mismo
        #scritp ruta
        ruta = periodo[:6] + "-01"   #se calcula la ruta segun la fecha manual
        #scritp inicio
        fecha_actual = datetime.strptime(periodo, "%Y%m%d")
        if 1 <= fecha_actual.day < 16:
            inicio = fecha_actual.replace(day=1).strftime('%Y-%m-%d')
            fin = fecha_actual.replace(day=15).strftime('%Y-%m-%d')
        else:
            inicio = fecha_actual.replace(day=16).strftime('%Y-%m-%d')
            fin = get_last_day(inicio).strftime('%Y-%m-%d')
            ruta = periodo[:6] + "-02" 
        return ruta, inicio, fin
    if id_reporte in (62,63,64,65):
        if periodo !=  Constantes.P_FECHA_ACTUAL:
            #scritp ruta
            ruta = periodo[:6] + "-01"
            #scritp inicio
            fecha_actual = datetime.strptime(periodo, "%Y%m%d")
            inicio = fecha_actual.replace(day=1).strftime('%Y-%m-%d')
        else:
            periodo = datetime.strptime(periodo, "%Y%m%d")
            inicio_mes_pasado = periodo - relativedelta(months=1)
            #scritp ruta
            ruta = inicio_mes_pasado.strftime("%Y%m") + "-01"
            #scritp inicio
            inicio = inicio_mes_pasado.replace(day=1).strftime('%Y-%m-%d')
        return ruta, inicio 

# funciones para formateos

def get_last_day(cod_fecha):
	año = int(cod_fecha[:4])
	mes = int(cod_fecha[5:7])
	lastdate = datetime(año, mes, monthrange(año, mes)[1])

	return lastdate

def get_last_blob(spark,folder_path): # folder_path = validacion/RPN0005/202403/(esta parte se crea)

    numeros = [str(i).zfill(2) for i in range(1, 100)]

    # Iterar sobre los números en orden inverso para encontrar la última ruta válida
    for num in reversed(numeros):
        ruta = f"{folder_path}{num}/"
        version = num
        try:
            df_validador = spark.read.parquet(ruta)
            if df_validador:
                logger.info(f"se imprime la ultima ruta existente: {ruta}")
                return version
        except Exception as e:
            #logger.error(f"Error al leer parquet desde la ruta {ruta}: {e}")
            pass
    else:
        return None

def get_last_blob_py(folder_path): # folder_path = validacion/RPN0005/202403/(esta parte se crea)

    numeros = [str(i).zfill(2) for i in range(1, 100)]

    # Iterar sobre los números en orden inverso para encontrar la última ruta válida
    for num in reversed(numeros):
        ruta = f"{folder_path}{num}/"
        version = num
        try:
            df_validador = pd.read_parquet(ruta)
            if df_validador:
                logger.info(f"se imprime la ultima ruta existente: {ruta}")
                return version
        except Exception as e:
            #logger.error(f"Error al leer parquet desde la ruta {ruta}: {e}")
            pass
    else:
        return None
    
def validar_version(version):
    if version is None:
        version = "01"
    else:   
        if len(version) != 2: raise ValueError("La version debe tener 2 caracteres como maximo")
        version = str(int(version) + 1).zfill(2)

    return version

# Función para formatear la fecha en el formato Julio 2024  y en español
def formatear_fecha(fecha):
    mes_en = fecha.strftime('%B')
    año = fecha.strftime('%Y')
    meses_en_es = {
    "January": "Enero", "February": "Febrero", "March": "Marzo",
    "April": "Abril", "May": "Mayo", "June": "Junio",
    "July": "Julio", "August": "Agosto", "September": "Septiembre",
    "October": "Octubre", "November": "Noviembre", "December": "Diciembre"
    }
    mes_es = meses_en_es[mes_en]
    return f"{mes_es} {año}"