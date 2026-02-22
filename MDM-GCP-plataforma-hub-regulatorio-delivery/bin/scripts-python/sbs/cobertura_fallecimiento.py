import pyspark
import datetime
import pyspark.sql.functions as F
from pyspark.sql.functions import broadcast,countDistinct
from pyspark.storagelevel import StorageLevel
import os
from pyspark.sql.types import StructType, StructField, IntegerType, StringType 
from io import StringIO
from google.cloud import storage, bigquery
from pyspark.sql import *
from pathlib import Path                                                                                                                                                                                                                           
from pyspark.sql.functions import *
from pyspark.sql.window import Window
from pyspark.sql.functions import broadcast
from param_cobertura_fallecimiento import PARAMETER_COBERTURA_fALLECIMIENTO
from dataproc_delivery_plugin import get_spark_session, write_to_gcs, get_parquet_path,read_table_as_df, get_parquet_path_pre_validacion
from dataproc_delivery_plugin import Constantes, get_parquet_path_validacion,read_parquet_and_create_view ,read_parquet_and_create_view_with_partitions, read_parquet_and_create_view_with_partitions_2
from dataproc_delivery_plugin import get_path_inicio, get_last_blob, validar_version, get_parquet_path
import logging
import calendar

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


nombre_reporte = "sbs"

spark = get_spark_session("hr-univ_to_dlv_sbs")

DATASET_POLIZA = 'uni_modelo_poliza'
DATASET_PERSONA = 'uni_modelo_persona'
DATASET_FINANZAS = 'uni_modelo_finanzas'

# --------------------CAMPOS UTILIZADOS PARA EL TABLON-------------------

parameters_persona = PARAMETER_COBERTURA_fALLECIMIENTO.parameteres_persona

print(parameters_persona)

exit()


parameters_persona = [
    "id_persona",
    "ape_paterno",
    "ape_materno",
    "nom_persona",
    "nom_completo"
]

parameters_persona_documento_identidad = [
    "id_persona_documento_identidad",
    "id_persona",
    "tip_documento",
    "num_documento"
]

parameters_certificado = [
    "id_certificado",
    "id_certificado_origen",
    "fec_ingreso",
    "fec_exclusion",
    "estado_certificado",
    "fec_inicio_vigencia",
    "fec_fin_vigencia",
    "id_poliza",
    "id_titular"
]

parameters_poliza = [
    "id_producto",
    "id_poliza",
    "id_poliza_origen",
    "id_estado_poliza_origen",
    "num_poliza",
    "cod_producto_origen",
    "nom_producto",
    "fec_emision",
    "fec_inicio_vigencia",
    "fec_fin_vigencia",
    "fec_anulacion",
    "id_contratante",
    "des_estado_poliza"
]

parameters_unidad_asegurable = [
    "id_certificado",
    "id_unidad_asegurable",
    "des_parentesco",
    "id_persona"
]

parameters_ramo_unidad_asegurable = [
    "id_unidad_asegurable",
    "id_ramo_unidad_asegurable",
    "des_ramo"
]

parameters_cobertura_unidad_asegurable = [
    "id_ramo_unidad_asegurable",
    "mto_suma_asegurada",
    "des_cobertura_origen",
    "id_moneda"
]

parameters_tasa_cambio = [
    "id_moneda_origen",
    "id_moneda_fin",
    "fec_tasa",
    "tip_tasa_cambio",
    "val_tasa_cambio"
]
#------------------------------------------------

#-----tipo de particiones------
particion_id_poliza = "prefijo_id_poliza"
particion_id_producto = "prefijo_id_producto"
#-------------------------------

#------- Listas de particiones -------
lista_prefijo_id_producto = [
    'AX-4065', 'AX-4132', 'AX-4133', 'AX-4140', 'AX-7901', 'AX-7902', 'AX-7906', 'AX-7910', 'AX-8001', 'AX-8003', 
    'AX-8006', 'AX-8007', 'AX-8008', 'AX-8010', 'AX-8012', 'AX-8013', 'AX-8014', 'AX-8020', 'AX-8022', 'AX-8023', 
    'AX-8024', 'AX-8025', 'AX-8027', 'AX-8028', 'AX-8029', 'AX-8030', 'AX-8031', 'AX-8035', 'AX-8036', 'AX-8038', 
    'AX-8039', 'AX-8040', 'AX-8042', 'AX-8043', 'AX-8044', 'AX-8101', 'AX-8102', 'AX-8150', 'AX-8201', 'AX-8202', 
    'AX-8301', 'AX-8302', 'AX-8303', 'AX-8305', 'AX-8307', 'AX-8308', 'AX-8401', 'AX-8403', 'AX-8404', 'AX-8601', 
    'AX-8699', 'AX-8708', 'AX-8709', 'AX-8710', 'AX-8715', 'AX-8720', 'AX-8723', 'AX-8726', 'AX-8727', 'AX-8728', 
    'AX-8730', 'AX-8731', 'AX-8734', 'AX-8735', 'AX-8736', 'AX-8737', 'AX-8738', 'AX-8740', 'AX-8742', 'AX-8743', 
    'AX-8744', 'AX-8745', 'AX-8747', 'AX-8748', 'AX-8749', 'AX-8754', 'AX-8756', 'AX-8757', 'AX-8760', 'AX-8761', 
    'AX-8762', 'AX-8763', 'AX-8764', 'AX-8765', 'AX-8767', 'AX-8769', 'AX-8770', 'AX-8771', 'AX-8772', 'AX-8773', 
    'AX-8777', 'AX-8778', 'AX-8780', 'AX-8781', 'AX-8783', 'AX-8786', 'AX-8787', 'AX-8788', 'AX-8789', 'AX-8790', 
    'AX-8792', 'AX-8794', 'AX-8796', 'AX-8813', 'AX-8814', 'AX-8815', 'AX-8817', 'AX-8818', 'AX-8819', 'AX-8820', 
    'AX-8822', 'AX-8823', 'AX-8825', 'AX-8826', 'AX-8827', 'AX-8828', 'AX-8829', 'AX-8833', 'AX-8834', 'AX-8901', 
    'AX-8917', 'AX-8918', 'AX-8919', 'AX-9002', 'AX-9003', 'AX-9004', 'AX-9005', 'AX-9008', 'AX-9013', 'AX-9016', 
    'AX-9020', 'AX-9023', 'AX-9028', 'AX-9030', 'AX-9032', 'AX-9033', 'AX-9034', 'AX-9035', 'AX-9037', 'AX-9039', 
    'AX-9040', 'AX-9042', 'AX-9044', 'AX-9045', 'AX-9046', 'AX-9049', 'AX-9051', 'AX-9101', 'AX-9202', 'AX-9255', 
    'AX-9256', 'AX-9302', 'AX-9303', 'AX-9304'
]

lista_prefijo_id_poliza = ['AE','RS', 'VU','AX']
#---------------------------------------

#--------lEYENDO PERSONA------
df_persona = read_parquet_and_create_view(
    spark,
    Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,
    Constantes.C_CAPA_UNIVERSAL,
    DATASET_PERSONA,
    "persona",  
    parameters_persona,
    "PERSONA"
)
# nfilas_persona = df_persona.count()
# logger.info(f"numero de filas personas: {nfilas_persona}")
#---------------------------------------

#--------lEYENDO PERSONA-documento-identidad------
df_persona_documento_identidad = read_parquet_and_create_view(
    spark,
    Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,
    Constantes.C_CAPA_UNIVERSAL,
    DATASET_PERSONA,
    "persona_documento_identidad",  
    parameters_persona_documento_identidad,
    "PERSONA_DOCUMENTO_IDENTIDAD"
)
# nfilas_persona = df_persona.count()
# logger.info(f"numero de filas personas: {nfilas_persona}")
#---------------------------------------

#--------lEYENDO POLIZA------
df_poliza = read_parquet_and_create_view_with_partitions_2(
    spark,
    Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,
    Constantes.C_CAPA_UNIVERSAL,
    DATASET_POLIZA,
    "poliza",  
    parameters_poliza,
    "POLIZA",
    lista_prefijo_id_poliza,
    lista_prefijo_id_producto,
    particion_id_poliza,
    particion_id_producto
)

# nfilas_poliza = df_poliza.count()
# logger.info(f"numero de filas polizas: {nfilas_poliza}")
#--------------------------------------------------------------------

# -----------------------leyendo certificado------------------------------------
df_certificado = read_parquet_and_create_view_with_partitions(
    spark, 
    Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,
    Constantes.C_CAPA_UNIVERSAL,
    DATASET_POLIZA,
    "certificado",  
    parameters_certificado,
    "CERTIFICADO",
    lista_prefijo_id_poliza,
    particion_id_poliza
)

# nfilas_certificado = df_certificado.count()
# logger.info(f"numero de filas certificado: {nfilas_certificado}")
#-----------------------------------------------

# -----------------------leyendo unidad asegurable------------------------------------
df_unidad_asegurable =  read_parquet_and_create_view(
    spark,
    Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,
    Constantes.C_CAPA_UNIVERSAL,
    DATASET_POLIZA,
    "unidad_asegurable",  
    parameters_unidad_asegurable,
    "UNIDAD_ASEGURABLE"
)

# nfilas_unidad_asegurable = df_unidad_asegurable.count()
# logger.info(f"numero de filas unidad asegurable: {nfilas_unidad_asegurable}")
#-----------------------------------------------

# -----------------------leyendo ramo unidad asegurable------------------------------------
df_ramo_unidad_asegurable =  read_parquet_and_create_view(
    spark,
    Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,
    Constantes.C_CAPA_UNIVERSAL,
    DATASET_POLIZA,
    "ramo_unidad_asegurable",  
    parameters_ramo_unidad_asegurable,
    "RAMO_UNIDAD_ASEGURABLE"
)

# nfilas_ramo_unidad_asegurable = df_ramo_unidad_asegurable.count()
# logger.info(f"numero de filas ramo unidad asegurable: {nfilas_ramo_unidad_asegurable}")
#-----------------------------------------------

# -----------------------leyendo ramo unidad asegurable------------------------------------
df_cobertura_unidad_asegurable =  read_parquet_and_create_view(
    spark,
    Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,
    Constantes.C_CAPA_UNIVERSAL,
    DATASET_POLIZA,
    "cobertura_unidad_asegurable",  
    parameters_cobertura_unidad_asegurable,
    "COBERTURA_UNIDAD_ASEGURABLE"
)

# nfilas_cobertura_unidad_asegurable = df_cobertura_unidad_asegurable.count()
# logger.info(f"numero de filas cob unidad asegurable: {nfilas_cobertura_unidad_asegurable}")
#-----------------------------------------------

# -----------------------leyendo tasa_cambio------------------------------------
df_tasa_cambio =  read_parquet_and_create_view(
    spark,
    Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,
    Constantes.C_CAPA_UNIVERSAL,
    DATASET_FINANZAS,
    "tasa_cambio",  
    parameters_tasa_cambio,
    "TASA_CAMBIO"
)

# nfilas_tasa_cambio = df_tasa_cambio.count()
# logger.info(f"numero de filas tasa de cambio: {nfilas_tasa_cambio}")
#-----------------------------------------------
#-----------------------------------------------
# ruta, inicio = get_path_inicio(Constantes.C_RPN_0004)

# logger.info(inicio)
# logger.info(ruta)

#-----------------------------------------------

#------------Tasa mensual -------------------

df_fecha_actual= spark.sql(f"""
    SELECT TO_DATE(CURRENT_DATE, 'yyyy-MM-dd') AS fec_actual;
""")

df_fecha_actual.createOrReplaceTempView("FECHA_ACTUAL")

df_tasa_cambio_moneda = spark.sql("""
  SELECT 
    (
    SELECT max(tc.val_tasa_cambio)
    FROM TASA_CAMBIO tc
    WHERE tc.tip_tasa_cambio='M'
    and tc.id_moneda_origen = 'SOL'
    and tc.id_moneda_fin='USD'
    and tc.fec_tasa = fec_actual
    ) sol_a_dolar_mes,
    (
    SELECT max(tc.val_tasa_cambio)
    FROM TASA_CAMBIO tc
    WHERE tc.tip_tasa_cambio='M'
    and tc.id_moneda_origen = 'USD'
    and tc.id_moneda_fin='SOL'
    and tc.fec_tasa = fec_actual
    ) dolar_a_sol_mes
  FROM 
    FECHA_ACTUAL
""")

df_tasa_cambio_moneda.createOrReplaceTempView("TASA_CAMBIO_MONEDA")

# nfilas_polizas_AE = df_polizas_AE.count()
# logger.info(f"numero de filas polizas AE_RS: {nfilas_polizas_AE}")
#-----------------------------------------------

#-------Creando polizas_AE------

df_polizas_AE = spark.sql("""
    select 
      p.id_producto,
      p.id_poliza,
      p.id_poliza_origen,
      p.id_estado_poliza_origen,
      p.num_poliza,
      p.cod_producto_origen,
      p.nom_producto,
      p.fec_emision,
      p.fec_inicio_vigencia AS poliza_fec_inicio_vigencia,
      p.fec_fin_vigencia AS poliza_fec_fin_vigencia,
      p.fec_anulacion,
      p.id_contratante,
      p.des_estado_poliza
      from POLIZA p
      where NOT p.id_estado_poliza_origen = 'Cotizada'
    group by 
      p.id_producto,
      p.id_poliza,
      p.id_poliza_origen,
      p.id_estado_poliza_origen,
      p.num_poliza,
      p.cod_producto_origen,
      p.nom_producto,
      p.fec_emision,
      poliza_fec_inicio_vigencia,
      poliza_fec_fin_vigencia,
      p.fec_anulacion,
      p.id_contratante,
      p.des_estado_poliza
""")

df_polizas_AE.createOrReplaceTempView("POLIZAS_AE")

# nfilas_polizas_AE = df_polizas_AE.count()
# logger.info(f"numero de filas polizas AE_RS: {nfilas_polizas_AE}")
#-----------------------------------------------

#--------creando personas documentos-------------

df_persona_documento = spark.sql("""
    select 
        per.id_persona,
        per.ape_paterno,
        per.ape_materno,
        per.nom_persona,
        per.nom_completo,
        pd.tip_documento,
        pd.num_documento
    from PERSONA per
    LEFT JOIN PERSONA_DOCUMENTO_IDENTIDAD pd
    on per.id_persona = pd.id_persona
""")

df_persona_documento.createOrReplaceTempView("PERSONA_DOCUMENTO")

nfilas_persona_documento = df_persona_documento.count()
logger.info(f"numero de filas persona doc: {nfilas_persona_documento}")
#----------------------------------------

#--------creando personas polizas AE-------------

df_personas_polizas_AE = spark.sql("""
    SELECT distinct 
        per.id_persona as id_contratante,
        per.ape_paterno as ape_pat_contratatnte,
        per.ape_materno as ape_mt_contratante,
        per.nom_persona as nom_per_contratante,
        per.nom_completo as nom_comp_contratante,
        per.tip_documento as tip_doc_contratante,
        per.num_documento as num_doc_contratante,
        p.id_producto,
        p.id_poliza,
        p.id_poliza_origen,
        p.id_estado_poliza_origen,
        p.num_poliza,
        p.cod_producto_origen,
        p.nom_producto,
        p.fec_emision,
        p.poliza_fec_inicio_vigencia,
        p.poliza_fec_fin_vigencia,
        p.fec_anulacion,
        p.des_estado_poliza
    from POLIZAS_AE p,
    PERSONA_DOCUMENTO per
    where per.id_persona = p.id_contratante
""")

df_personas_polizas_AE.createOrReplaceTempView("PERSONAS_POLIZAS_AE")

# nfilas_personas_polizas_AE = df_personas_polizas_AE.count()
# logger.info(f"numero de filas personas polizas AE_RS: {nfilas_personas_polizas_AE}")
#-----------------------------------------------

#--------creando personas certificado-------------

df_personas_certificado = spark.sql("""
    select distinct 
        per.id_persona as id_titular,
        per.ape_paterno as ape_pat_titular,
        per.ape_materno as ape_mat_titular,
        per.nom_persona as nom_titular,
        per.nom_completo as nom_comp_titular,
        per.tip_documento as tip_doc_titular,
        per.num_documento as num_doc_titular,
        c.id_certificado,
        c.id_certificado_origen as num_certificado, 
        c.fec_ingreso,
        c.fec_exclusion as fec_salida,
        c.estado_certificado,
        c.fec_inicio_vigencia AS certificado_fec_inicio_vigencia,
        c.fec_fin_vigencia AS certificado_fec_fin_vigencia ,
        c.id_poliza
    FROM CERTIFICADO c  
    left join PERSONA_DOCUMENTO per on c.id_titular = per.id_persona
""")

df_personas_certificado.createOrReplaceTempView("PERSONAS_CERTIFICADO")

# nfilas_personas_certificado = df_personas_certificado.count()
# logger.info(f"numero de filas personas certificado: {nfilas_personas_certificado}")
#-----------------------------------------------

#--------creando cobertura persona-------------

df_cobertura_persona = spark.sql("""
    select distinct 
        per.id_persona as id_afiliado,
        per.ape_paterno as ape_pat_afiliado,
        per.ape_materno as ape_mat_afiliado,
        per.nom_persona as nom_afiliado,
        per.nom_completo as nom_comp_afiliado,
        per.tip_documento as tip_doc_afiliado,
        per.num_documento as num_doc_afiliado,
        CASE 
            WHEN CUA.id_moneda = 'SOL' THEN ROUND(CUA.mto_suma_asegurada * tcm.sol_a_dolar_mes, 2)
            WHEN CUA.id_moneda = 'USD' THEN ROUND(CUA.mto_suma_asegurada, 2)
            ELSE ROUND(CUA.mto_suma_asegurada * -1, 2)
        END AS mto_suma_asegurada_usd,
        CASE 
            WHEN CUA.id_moneda = 'SOL' THEN ROUND(CUA.mto_suma_asegurada, 2)
            WHEN CUA.id_moneda = 'USD' THEN ROUND(CUA.mto_suma_asegurada * tcm.dolar_a_sol_mes, 2)
            ELSE ROUND(CUA.mto_suma_asegurada * -1, 2)
        END AS mto_suma_asegurada_soles,
        R.des_ramo,
        CUA.des_cobertura_origen,
        A.id_certificado,
        A.des_parentesco
    from    
        UNIDAD_ASEGURABLE A,
        RAMO_UNIDAD_ASEGURABLE R,
        COBERTURA_UNIDAD_ASEGURABLE CUA,
        PERSONA_DOCUMENTO per,
        TASA_CAMBIO_MONEDA tcm
    where  1 = 1
        and R.id_unidad_asegurable = A.id_unidad_asegurable
        and CUA.id_ramo_unidad_asegurable = R.id_ramo_unidad_asegurable
        and per.id_persona = A.id_persona
""")

df_cobertura_persona.createOrReplaceTempView("COBERTURA_PERSONA")

# nfilas_cobertura_persona = df_cobertura_persona.count()
# logger.info(f"numero de filas personas certificado: {nfilas_cobertura_persona}")
#-----------------------------------------------

#--------Armando tablon-------------

df_tablon = spark.sql("""
    select  
            pp.id_producto,
            pp.nom_producto,
            pp.id_poliza,
            pp.id_poliza_origen,
            pp.id_estado_poliza_origen,
            pp.num_poliza,
            pp.cod_producto_origen,
            pp.nom_comp_contratante,
            pp.tip_doc_contratante,
            pp.num_doc_contratante,
            pp.fec_emision,
            pp.poliza_fec_inicio_vigencia,
            pp.poliza_fec_fin_vigencia,
            pp.fec_anulacion,
            pp.des_estado_poliza,
            pc.nom_comp_titular,
            pc.tip_doc_titular,
            pc.num_doc_titular,
            pc.id_certificado,
            pc.num_certificado, 
            pc.fec_ingreso,
            pc.fec_salida,
            pc.estado_certificado,
            pc.certificado_fec_inicio_vigencia,
            pc.certificado_fec_fin_vigencia ,
            cp.nom_comp_afiliado,
            cp.tip_doc_afiliado,
            cp.num_doc_afiliado,
            cp.mto_suma_asegurada_usd, 
            cp.mto_suma_asegurada_soles,
            cp.des_ramo,
            cp.des_cobertura_origen,
            cp.des_parentesco
            from personas_polizas_AE pp 
    left join personas_certificado pc on pp.id_poliza = pc.id_poliza
    left join cobertura_persona cp on pc.id_certificado = cp.id_certificado
""")

# nfilas_cobertura_persona = df_cobertura_persona.count()
# logger.info(f"numero de filas personas certificado: {nfilas_cobertura_persona}")
#-----------------------------------------------

#------escritura---------------------

ruta_destino = get_parquet_path(Constantes.P_BUCKET_DELIVERY_PQT_FILES, Constantes.C_CAPA_DELIVERY, Constantes.C_BD_FALLECIDOS, nombre_reporte)
# destino_final = get_parquet_path_validacion(Constantes.C_REPORTES_SUCAVE,nombre_reporte,ruta, validar_version(get_last_blob(spark,destino)))

df_tablon.write.format(Constantes.C_FORMATO_PARQUET).mode("overwrite").save(ruta_destino)


