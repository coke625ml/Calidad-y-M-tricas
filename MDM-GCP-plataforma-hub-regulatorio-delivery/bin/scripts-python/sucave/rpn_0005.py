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
from dataproc_delivery_plugin import get_spark_session, write_to_gcs, get_parquet_path,read_table_as_df, get_parquet_path_pre_validacion
from dataproc_delivery_plugin import Constantes, get_parquet_path_validacion
from dataproc_delivery_plugin import get_path_inicio, get_last_blob, validar_version
import logging
import calendar

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

nombre_reporte = "RPN0005"
spark = get_spark_session("hr-univ_to_dlv_rpn0005")

#calculo automatico
ruta, inicio = get_path_inicio(Constantes.C_RPN_0005) 
 
logger.info(inicio)
logger.info(ruta)

DATASET_POLIZA = 'uni_modelo_poliza'
DATASET_COMERCIAL = 'uni_modelo_comercial'
DATASET_PERSONA = 'uni_modelo_persona'

# ---------------CAMPOS PARA EL RPN05-------------------

parameters_certificado = [
    "id_certificado",
    "id_poliza",
    "id_certificado_origen",
    "id_titular",
    "fec_inicio_vigencia",
    "fec_fin_vigencia"
]

parameters_certificado_clausula = [
    "id_poliza",
    "id_clausula",
    "est_clausula"
]

parameters_ope_pol_cert1 = [
    "id_poliza",
    "id_certificado",
    "num_operacion",
    "fec_operacion",
    "mnt_operacion",
    "id_tipo_operacion",
    "ind_anulacion"
]

parameters_ope_pol_cert2 = [
    "id_poliza",
    "id_certificado",
    "ind_anulacion",
    "mnt_operacion",
    "fec_operacion",
    "id_tipo_operacion"
]

parameters_poliza = [
    "id_poliza",
    "num_poliza",
    "fec_inicio_vigencia",
    "fec_fin_vigencia", 
    "id_poliza_origen", 
    "id_contratante", 
    "cod_producto_origen"
]

parameters_persona = [
    "id_persona"
]

parameters_persona_rol = [
    "id_persona_rol",
    "cod_tip_rol",
    "val_etiqueta"
]

parameters_persona_bloqueo = [
    "id_persona",
    "est_bloqueo" 
]

parameters_intermediario = [
    "id_persona_intermediario",
    "num_id",
    "cod_sbs"
]

parameters_intermediariomc = [
    "cod_rimac",
    "id_intermediario"
]

parameters_modelo_comercial = [
    "id_intermediario",
    "id_estructura_canal"
]

parameters_estructura_canal = [
    "id_estructura_canal",
    "id_canal"
]

# ---------------------------------------------------

df_certificado = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_POLIZA,'certificado/prefijo_id_poliza=AX')).select(
    *parameters_certificado
)
df_certificado_clausula = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_POLIZA,'certificado_clausula')).select(
    *parameters_certificado_clausula
)


dataframe= []
dataframe1 = []

particiones_a_leer_ope1 = [
    get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_POLIZA,'operacion_poliza_certificado/prefijo_id_poliza=AX/prefijo_id_tipo_operacion=ANU'), 
    get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_POLIZA,'operacion_poliza_certificado/prefijo_id_poliza=AX/prefijo_id_tipo_operacion=EXC'),
    get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_POLIZA,'operacion_poliza_certificado/prefijo_id_poliza=AX/prefijo_id_tipo_operacion=REH')    
    ]

particiones_a_leer_ope2 = [
    get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_POLIZA,'operacion_poliza_certificado/prefijo_id_poliza=AX/prefijo_id_tipo_operacion=EMI'), 
    get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_POLIZA,'operacion_poliza_certificado/prefijo_id_poliza=AX/prefijo_id_tipo_operacion=REM'), 
    get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_POLIZA,'operacion_poliza_certificado/prefijo_id_poliza=AX/prefijo_id_tipo_operacion=MOD')
    ]

for directorio in particiones_a_leer_ope1:
    df = spark.read.parquet(directorio).select(*parameters_ope_pol_cert1)
    dataframe.append(df)

df_final = dataframe[0]
for df in dataframe[1:]:
    df_operacion_poliza_certificado1 = df_final.union(df)

for directorio1 in particiones_a_leer_ope2:
    df = spark.read.parquet(directorio1).select(*parameters_ope_pol_cert2)
    dataframe1.append(df)

df_final1 = dataframe1[0]
for df in dataframe1[1:]:
    df_operacion_poliza_certificado2 = df_final1.union(df)

# df_operacion_poliza_certificado1  = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_POLIZA,'operacion_poliza_certificado/prefijo_id_poliza=AX'))\
# .filter(
#     (col("id_tipo_operacion").isin(particiones_a_leer_ope1))
# )
# df_operacion_poliza_certificado2  = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_POLIZA,'operacion_poliza_certificado/prefijo_id_poliza=AX'))\
# .filter(
#     (col("id_tipo_operacion").isin(particiones_a_leer_ope2))
# )

df_poliza  = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_POLIZA,'poliza/prefijo_id_poliza=AX/prefijo_id_producto=AX-1201')).select(
    *parameters_poliza
)

df_persona  = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_PERSONA,'persona')).select(
    *parameters_persona
)

df_persona_bloqueo  = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_PERSONA,'persona_bloqueo')).select(
   *parameters_persona_bloqueo
)

df_persona_rol  = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_PERSONA,'persona_rol')).select(
    *parameters_persona_rol
)

df_intermediario  = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_COMERCIAL,'intermediario')).select(
    *parameters_intermediario
)

df_intermediario_mc  = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_COMERCIAL,'intermediario_mc')).select(
    *parameters_intermediariomc
)

df_modelo_comercial  = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_COMERCIAL,'modelo_comercial')).select(
    *parameters_modelo_comercial
)

df_estructura_canal  = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_COMERCIAL,'estructura_canal')).select(
    *parameters_estructura_canal
)

df_periodo = spark.sql (f"""
    SELECT
    TO_DATE('{inicio}', 'yyyy-MM-dd') AS PERIODOINI,
    CAST(PERIODOINI AS TIMESTAMP) AS TIMESTAMP_PERIODOINI,
    CAST(DATEADD(MONTH, 1, PERIODOINI) AS TIMESTAMP) AS TIMESTAMP_PERIODOFIN
""")
df_periodo.createOrReplaceTempView("PERIODO")

df_persona_cte = df_persona
df_persona_cte.createOrReplaceTempView("PERSONA")

df_poliza.createOrReplaceTempView("poliza")
df_poliza_cte = spark.sql("""
    SELECT distinct a.id_poliza, a.num_poliza, a.fec_inicio_vigencia,
          a.fec_fin_vigencia, id_poliza_origen, id_contratante, cod_producto_origen as cod_prod
        FROM poliza a
""")
df_poliza_cte.createOrReplaceTempView("POLIZAS")

df_certificado.createOrReplaceTempView("certificado")
df_certificado_cte = spark.sql("""
    select distinct b.id_certificado, b.id_poliza, b.id_certificado_origen as numCert,
              b.id_titular, b.fec_inicio_vigencia, b.fec_fin_vigencia
          from certificado as b, POLIZAS p
          where b.id_poliza = p.id_poliza
""")
df_certificado_cte.createOrReplaceTempView("CERTIFICADO")

df_operacion_poliza_certificado2.createOrReplaceTempView("operacion_poliza_certificado2")

df_operacion_emision_certificado = spark.sql("""
    select MIN(op.fec_operacion) as fecMov, op.id_poliza, op.id_certificado
    from operacion_poliza_certificado2 as op,
         CERTIFICADO ce
   where op.id_poliza = ce.id_poliza
     and op.id_certificado = ce.id_certificado
     and op.id_tipo_operacion = 'EMI'
     and op.mnt_operacion != 0
     and coalesce(op.ind_anulacion,'N') != 'S'
     GROUP BY op.id_poliza, op.id_certificado
""")

df_operacion_emision_certificado.createOrReplaceTempView("OPERACION_EMISION_CERTIFICADO")

df_personas_polizas_cte = spark.sql("""
    SELECT distinct pe.id_persona, p.id_poliza , p.num_poliza, p.cod_prod FROM PERSONA pe, POLIZAS p
     where pe.id_persona = p.id_contratante
""")
df_personas_polizas_cte.createOrReplaceTempView("PERSONAS_POLIZAS")

df_certificado_clausula.createOrReplaceTempView("certificado_clausula")
df_certificado_clausula_cte = spark.sql("""
        select distinct cc.id_poliza
        FROM certificado_clausula cc,
                polizas a1
        where cc.id_poliza = a1.id_poliza 
        and cc.id_clausula in ('AX-RCI037','AX-RCI070')
        and cc.est_clausula not in ('EXC')
        """)
df_certificado_clausula_cte.createOrReplaceTempView("CERTIFICADO_CLAUSULA")


df_persona_bloqueo.createOrReplaceTempView("PERSONA_BLOQUEO")

df_persona_rol.createOrReplaceTempView("PERSONA_ROL")

df_intermediario.createOrReplaceTempView("INTERMEDIARIO")

df_modelo_comercial.createOrReplaceTempView("MODELO_COMERCIAL")
df_estructura_canal.createOrReplaceTempView("ESTRUCTURA_CANAL")
df_intermediario_mc.createOrReplaceTempView("INTERMEDIARIO_MC")

df_indcorredor_cte = spark.sql("""
    select distinct pp.id_persona, pp.id_poliza, pp.num_poliza , pr.val_etiqueta--, 'SI' IND_CORREDOR 
     from PERSONAS_POLIZAS pp, PERSONA_ROL pr
     WHERE pp.id_persona = pr.id_persona_rol
     and pr.cod_tip_rol in ('INT','REA','ASE')
     union all
     select distinct pe.id_persona, pe.id_poliza, pe.num_poliza, i.cod_sbs--, 'SI' as IND_CORREDOR
        from PERSONAS_POLIZAS pe, 
        INTERMEDIARIO i, 
        MODELO_COMERCIAL MC, 
        ESTRUCTURA_CANAL EC,
        INTERMEDIARIO_MC IMC
     WHERE pe.id_persona = i.id_persona_intermediario
        AND i.num_id = IMC.cod_rimac
        AND IMC.id_intermediario = MC.id_intermediario
        AND MC.id_estructura_canal = EC.id_estructura_canal
        AND coalesce(i.cod_sbs,'NO DETERMINADO')!= 'NO DETERMINADO'
        AND EC.id_canal = 5;
""")

df_indcorredor_cte.createOrReplaceTempView("INDCORREDOR")

df_operacion_poliza_certificado1.createOrReplaceTempView("operacion_poliza_certificado1")

df_oper_pol_certificado_cte = spark.sql(f""" 
    SELECT
    DISTINCT m.*,
    pp.id_persona,
    pp.cod_prod
FROM (
    SELECT
        c.id_poliza,
        c.id_certificado,
        c.num_operacion,
        c.fec_operacion AS fec_mov,
        c.mnt_operacion,
        c.id_tipo_operacion,
        po.num_poliza,
        po.fec_inicio_vigencia,
        po.fec_fin_vigencia
    FROM
        operacion_poliza_certificado1 AS c
    JOIN
        POLIZAS po ON c.id_poliza = po.id_poliza,
        PERIODO pe
    WHERE
        c.id_tipo_operacion = 'ANU' -- Solo anulaciones
        AND c.fec_operacion >= pe.TIMESTAMP_PERIODOINI
        AND c.fec_operacion < pe.TIMESTAMP_PERIODOFIN
        AND COALESCE(c.ind_anulacion, 'N') != 'S'
        AND NOT EXISTS (
            SELECT 1
            FROM OPERACION_EMISION_CERTIFICADO emision
            WHERE emision.id_poliza = c.id_poliza
              AND emision.id_certificado = c.id_certificado
              AND emision.fecMov >= pe.TIMESTAMP_PERIODOINI
              AND emision.fecMov < pe.TIMESTAMP_PERIODOFIN
        )
) AS m
JOIN
    PERSONAS_POLIZAS pp ON m.id_poliza = pp.id_poliza
""")

df_oper_pol_certificado_cte.createOrReplaceTempView("OPER_POL_CERTIFICADO")

# cte_polizas_anuladas = spark.sql("""
#     select id_poliza 
#     from operacion_poliza_certificado2 op
#     where 
                    
 
# """)

df_reporte5 = spark.sql("""
SELECT DISTINCT
    A.id_poliza,
    A.id_certificado,
    A.cod_prod,
    I.val_etiqueta AS CODSBS,
    A.NUM_POLIZA AS NRO_POLIZA,
    B1.numCert AS NUM_CERTIFICADO,
    A.num_operacion,
    'NA' AS NRO_COBERTURA_PROVISIONAL,
    DATE_FORMAT(B.fecMov, 'yyyyMMdd') AS FECHA_EMISION,
    DATE_FORMAT(A.fec_inicio_vigencia, 'yyyyMMdd') AS FECHA_INICIO_VIGENCIA,
    DATE_FORMAT(A.fec_fin_vigencia, 'yyyyMMdd') AS FECHA_FIN_VIGENCIA,
    CASE WHEN A.id_tipo_operacion IN ('ANU', 'EXC') THEN '03' ELSE '02' END AS MOTIVO_REPORTE,
    DATE_FORMAT(A.fec_mov, 'yyyyMMdd') AS FECHA
FROM
    OPER_POL_CERTIFICADO AS A
INNER JOIN
    OPERACION_EMISION_CERTIFICADO AS B ON A.id_poliza = B.id_poliza AND A.id_certificado = B.id_certificado
LEFT JOIN
    INDCORREDOR AS I ON A.id_persona = I.id_persona AND A.id_poliza = I.id_poliza
INNER JOIN
    (SELECT DISTINCT id_poliza, 'SI' AS IND_CLAUSULA FROM CERTIFICADO_CLAUSULA) AS CLAUS ON A.id_poliza = CLAUS.id_poliza
LEFT JOIN
    (SELECT DISTINCT id_persona, 'SI' AS IND_BLOQUEO FROM PERSONA_BLOQUEO WHERE est_bloqueo = 'ACT') AS BLO ON A.id_persona = BLO.id_persona
LEFT JOIN
    (SELECT DISTINCT id_poliza, id_certificado, numCert FROM CERTIFICADO) AS B1 ON A.id_poliza = B1.id_poliza AND A.id_certificado = B1.id_certificado
ORDER BY A.cod_prod, NRO_POLIZA, NUM_CERTIFICADO
""")

windowSpec = Window.orderBy("cod_prod")

# Agregar el número de fila usando row_number()
df_reporte5 = df_reporte5.withColumn("numero_secuencia", F.row_number().over(windowSpec))
df_reporte5 = df_reporte5.select(
    "numero_secuencia",
    *df_reporte5.columns[:-1]  # Seleccionar todas las columnas excepto "numero_secuencia"
)

#df_reporte5.show()
# nreporte5 = df_reporte5.count()
# logger.info(f"nreporte5: {nreporte5}")


destino = get_parquet_path_pre_validacion(Constantes.C_REPORTES_SUCAVE,nombre_reporte,ruta)
destino_final = get_parquet_path_validacion(Constantes.C_REPORTES_SUCAVE,nombre_reporte,ruta, validar_version(get_last_blob(spark,destino)))

write_to_gcs(df_reporte5, destino_final)

#aqui volvemos