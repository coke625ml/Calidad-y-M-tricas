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


nombre_reporte = "RPN0004"

spark = get_spark_session("hr-univ_to_dlv_rpn0004")

DATASET_POLIZA = 'uni_modelo_poliza'
DATASET_COMERCIAL = 'uni_modelo_comercial'
DATASET_PERSONA = 'uni_modelo_persona'
DATASET_COBRANZA = 'uni_modelo_cobranza'
DATASET_FINANZAS = 'uni_modelo_finanzas'

# --------------------CAMPOS UTILIZADOS PARA EL RPN0004-------------------

parameters_certificado = [
    "id_certificado_origen",
    "id_poliza",
    "id_certificado",
    "fec_inicio_vigencia",
    "fec_fin_vigencia"
]

parameters_certificado_clausula = [
    "id_poliza",
    "id_clausula",
    "est_clausula"
]

parameteres_ope_pol_cert = [
    "id_poliza",
    "id_certificado",
    "num_operacion",
    "id_tipo_operacion",
    "ind_anulacion",
    "fec_operacion",
    "mnt_operacion",
    "num_operacion"
]

parameters_poliza = [
    "id_producto",
    "id_poliza",
    "id_estado_poliza",
    "tip_suscripcion",
    "id_contratante",
    "cod_producto_origen",
    "num_poliza"
]

parameters_bitacora_mc_poliza = [
    "id_poliza",
    "id_bitacora_mc",
    "dsc_periodo"
]

parameters_bitacora_mc = [
    "id_bitacora_mc",
    "id_estructura_canal"
]

parameters_unidad_asegurable = [
    "id_certificado",
    "id_unidad_asegurable"
]

parameters_ramo_unidad_asegurable = [
    "id_unidad_asegurable",
    "id_ramo_unidad_asegurable"
]

parameters_cobertura_unidad_asegurable = [
    "id_ramo_unidad_asegurable",
    "mto_suma_asegurada",
    "ind_principal",
    "id_moneda"
]

parameters_recaudo_por_cobrar = [
    "id_recaudo"
]

parameters_cuenta_por_cobrar_detalle = [
    "id_recaudo",
    "id_cuenta_por_cobrar"
]

parameters_cuenta_por_cobrar = [
    "id_cuenta_por_cobrar",
    "est_cuenta_por_cobrar",
    "fec_vencimiento"
]

parameters_recibo = [
    "id_certificado",
    "id_recibo"
]

parameters_persona = [
    "id_persona"
]

parameters_persona_rol = [
    "val_etiqueta",
    "id_persona_rol",
    "cod_tip_rol"
]

parameters_recibo_recaudo = [
    "id_recibo",
    "id_recaudo"
]

parameters_intermediario = [
    "id_persona_intermediario",
    "num_id",
    "cod_sbs"
]

parameters_intermediario_mc = [
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

parameters_tasa_cambio = [
    "id_moneda_origen",
    "id_moneda_fin",
    "fec_tasa",
    "tip_tasa_cambio",
    "val_tasa_cambio"
]

# ------------------------------------------------------------------
df_certificado = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_POLIZA,'certificado/prefijo_id_poliza=AX')).select(
    *parameters_certificado
)

df_certificado_clausula = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_POLIZA,'certificado_clausula')).select(
    *parameters_certificado_clausula
)

df_operacion_poliza_certificado = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_POLIZA,'operacion_poliza_certificado/prefijo_id_poliza=AX')).select(
    *parameteres_ope_pol_cert
)

df_poliza = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_POLIZA,'poliza/prefijo_id_poliza=AX/prefijo_id_producto=AX-1201')).select(
    *parameters_poliza
)

df_bitacora_mc_poliza = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_COMERCIAL,'bitacora_mc_poliza')).select(
    *parameters_bitacora_mc_poliza
)

df_bitacora_mc = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_COMERCIAL,'bitacora_mc')).select(
    *parameters_bitacora_mc
)

df_unidad_asegurable = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_POLIZA,'unidad_asegurable')).select(
    *parameters_unidad_asegurable
)

df_ramo_unidad_asegurable = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_POLIZA,'ramo_unidad_asegurable/prefijo_id_ramo=AX-RECI')).select(
    *parameters_ramo_unidad_asegurable
)

df_cobertura_unidad_asegurable = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_POLIZA,'cobertura_unidad_asegurable/pref_id_cob_uni_aseg=AX')).select(
    *parameters_cobertura_unidad_asegurable
)

df_recaudo_por_cobrar = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_COBRANZA,'recaudo_por_cobrar/prefijo_id_origen=AX')).select(
    *parameters_recaudo_por_cobrar
)

df_cuenta_por_cobrar_detalle = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_COBRANZA,'cuenta_por_cobrar_detalle')).select(
    *parameters_cuenta_por_cobrar_detalle
)

df_cuenta_por_cobrar = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_COBRANZA,'cuenta_por_cobrar/prefijo_id_compania=AX-10/prefijo_id_origen=AX')).select(
    *parameters_cuenta_por_cobrar
)

df_recibo= spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_COBRANZA,'recibo/prefijo_id_origen=AX/prefijo_id_producto=AX-1201')).select(
    *parameters_recibo
)

df_recibo_recaudo= spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_COBRANZA,'recibo_recaudo/prefijo_id_producto=AX-1201')).select(
    *parameters_recibo_recaudo
)

df_persona  = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_PERSONA,'persona')).select(
    *parameters_persona
)

df_persona_rol  = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_PERSONA,'persona_rol')).select(
    *parameters_persona_rol
)

df_intermediario  = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_COMERCIAL,'intermediario')).select(
    *parameters_intermediario
)

df_intermediario_mc  = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_COMERCIAL,'intermediario_mc')).select(
    *parameters_intermediario_mc
)

df_modelo_comercial  = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_COMERCIAL,'modelo_comercial')).select(
    *parameters_modelo_comercial
)

df_estructura_canal  = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_COMERCIAL,'estructura_canal')).select(
    *parameters_estructura_canal
)

df_tasa_cambio = spark.read.parquet(get_parquet_path(Constantes.P_BUCKET_UNIVERSAL_PQT_FILES,Constantes.C_CAPA_UNIVERSAL,DATASET_FINANZAS,'tasa_cambio')).select(
    *parameters_tasa_cambio
)

df_operacion_poliza_certificado.createOrReplaceTempView("operacion_poliza_certificado")
df_poliza.createOrReplaceTempView("poliza")
df_certificado_clausula.createOrReplaceTempView("certificado_clausula")
df_ramo_unidad_asegurable.createOrReplaceTempView("ramo_unidad_asegurable") 
df_unidad_asegurable.createOrReplaceTempView("unidad_asegurable")
df_cobertura_unidad_asegurable.createOrReplaceTempView("cobertura_unidad_asegurable")
df_certificado.createOrReplaceTempView("certificado")
df_recaudo_por_cobrar.createOrReplaceTempView("recaudo_por_cobrar")
df_cuenta_por_cobrar.createOrReplaceTempView("cuenta_por_cobrar")
df_cuenta_por_cobrar_detalle.createOrReplaceTempView("cuenta_por_cobrar_detalle")
df_recibo.createOrReplaceTempView("recibo")
df_recibo_recaudo.createOrReplaceTempView("recibo_recaudo")

df_persona_rol.createOrReplaceTempView("PERSONA_ROL")
df_intermediario.createOrReplaceTempView("INTERMEDIARIO")
df_modelo_comercial.createOrReplaceTempView("MODELO_COMERCIAL")
df_estructura_canal.createOrReplaceTempView("ESTRUCTURA_CANAL")
df_intermediario_mc.createOrReplaceTempView("INTERMEDIARIO_MC")
df_bitacora_mc.createOrReplaceTempView("bitacora_mc")
df_bitacora_mc_poliza.createOrReplaceTempView("bitacora_mc_poliza")

df_persona_cte = df_persona
df_persona_cte.createOrReplaceTempView("PERSONA")
df_tasa_cambio.createOrReplaceTempView("tasa_cambio")

ruta, inicio = get_path_inicio(Constantes.C_RPN_0004)

# logger.info(inicio)
# logger.info(ruta)


df_periodo= spark.sql(f"""
    SELECT TO_DATE('{inicio}', 'yyyy-MM-dd') AS PERIODOINI
""")

periodo = df_periodo.selectExpr("date_format(PERIODOINI, 'yyyyMM') AS PERIODO").first()[0]

df_periodo.createOrReplaceTempView("PERIODO")
df_datos_reporte = spark.sql("""
  SELECT 
    PERIODOINI,
    DATEADD(MONTH, 1, PERIODOINI) AS PERIODOFIN,
    CAST(PERIODOINI AS TIMESTAMP) AS TIMESTAMP_PERIODOINI, 
    CAST(DATEADD(MONTH, 1, PERIODOINI) AS TIMESTAMP) AS TIMESTAMP_PERIODOFIN,
    'AX-1201' id_producto, 
    'AX-RCI037' id_clausula,
    'AX-RCI070' id_clausula_new,
    'AX-RECI' id_ramo,
    (
    SELECT max(tc.val_tasa_cambio)
    FROM tasa_cambio tc
    WHERE tc.tip_tasa_cambio='M'
    and tc.id_moneda_origen = 'SOL'
    and tc.id_moneda_fin='USD'
    and tc.fec_tasa = PERIODOINI
    ) tc_factor_mes
  FROM 
    PERIODO
""")
df_datos_reporte.show()

df_datos_reporte.createOrReplaceTempView("DATOS_REPORTE")
df_operaciones = spark.sql("""
    select pol.id_producto, ope.id_poliza, ope.id_certificado, max(ope.num_operacion) num_operacion
        from operacion_poliza_certificado ope,
                poliza pol,
                DATOS_REPORTE pe
          where ope.id_tipo_operacion = 'EMI'
            and ope.fec_operacion >= pe.TIMESTAMP_PERIODOINI --2024-02-01
            and ope.fec_operacion < pe.TIMESTAMP_PERIODOFIN  --2024-03-01
            and ope.mnt_operacion <> 0
            and coalesce(ope.ind_anulacion,'N') = 'N'
            and ope.id_poliza = pol.id_poliza
            and pol.id_producto = pe.id_producto
            and pol.id_estado_poliza <> 'ANU'
           and exists(
             select 1
               from certificado_clausula cc, DATOS_REPORTE pe
              where cc.id_poliza = pol.id_poliza
                and cc.id_clausula in (pe.id_clausula,pe.id_clausula_new)
                and cc.est_clausula not in ('ANU','EXC','INA')
           )
     group by pol.id_producto, ope.id_poliza, ope.id_certificado, num_operacion
""")
df_operaciones.createOrReplaceTempView("OPERACIONES")

df_poliza_cte = spark.sql("""
    SELECT distinct a.id_poliza, a.num_poliza, id_contratante, 
    (select count (1) from certificado c where 
    c.id_poliza = a.id_poliza) as cnt_cert,
      a.cod_producto_origen
        FROM poliza a
        inner join OPERACIONES op
        on op.id_poliza = a.id_poliza
""")
df_poliza_cte.createOrReplaceTempView("POLIZAS")


df_personas_polizas_cte = spark.sql("""
    SELECT distinct pe.id_persona, p.id_poliza , p.num_poliza 
    FROM PERSONA pe, 
    POLIZAS p
     where pe.id_persona = p.id_contratante
""")
df_personas_polizas_cte.createOrReplaceTempView("PERSONAS_POLIZAS")

# npersonas_poliza = df_personas_polizas_cte.count()
# logger.info(f"npersonas_poliza: {npersonas_poliza}")

df_indcorredor_cte = spark.sql("""
    select distinct pp.id_persona, pp.id_poliza, pr.val_etiqueta AS cod_sbs 
     from PERSONAS_POLIZAS pp, PERSONA_ROL pr
     WHERE pp.id_persona = pr.id_persona_rol
     and pr.cod_tip_rol in ('INT','REA','ASE')
     union all
     select distinct pe.id_persona, pe.id_poliza, i.cod_sbs
        from PERSONAS_POLIZAS pe, 
        INTERMEDIARIO i, 
        MODELO_COMERCIAL MC, 
        ESTRUCTURA_CANAL EC,
        INTERMEDIARIO_MC IMC
     WHERE pe.id_persona = i.id_persona_intermediario
        AND i.num_id = IMC.cod_rimac
        AND IMC.id_intermediario = MC.id_intermediario
        AND MC.id_estructura_canal = EC.id_estructura_canal
        AND EC.id_canal = 5
        AND coalesce(i.cod_sbs,'NO DETERMINADO')!= 'NO DETERMINADO'
        --dsc_periodo
""")
df_indcorredor_cte.createOrReplaceTempView("INDCORREDOR")

# nFilas_corredor = df_indcorredor_cte.count()
# logger.info(f"nFilas_corredor: {nFilas_corredor}")

periodo_bmcp = inicio.replace("-","")[:6]

df_tipo_contratacion = spark.sql(f"""
      select distinct
        CASE
            WHEN ec.id_canal = 8 THEN 'D' 
            ELSE 'I' 
        END AS tipo_contratacion, 
        CASE
          WHEN po.cnt_cert > 1  THEN 'G'
          WHEN po.cnt_cert <= 1 THEN 'I'
        END AS tipo_poliza,
        po.cod_producto_origen, po.num_poliza, po.id_poliza
        from POLIZAS po,
        bitacora_mc_poliza bmcp,
        bitacora_mc bmc,
        estructura_canal ec
        where po.id_poliza = bmcp.id_poliza
        and bmcp.id_bitacora_mc = bmc.id_bitacora_mc
        and bmc.id_estructura_canal = ec.id_estructura_canal
        and bmcp.dsc_periodo = '{periodo_bmcp}'
        --dsc_periodo
""")

df_tipo_contratacion.createOrReplaceTempView("TIPO_CONTRATACION")

df_tipo_contratacion.show()
nFilas_tipo_contra = df_tipo_contratacion.count()
logger.info(f"nFilas_tipo_contra: {nFilas_tipo_contra}")
df_certificado_operacion = spark.sql("""
    select ope.*, oped.fec_operacion fec_emision,oped.mnt_operacion primaneta
    from operacion_poliza_certificado oped
   inner join OPERACIONES ope on ope.num_operacion = oped.num_operacion
   and ope.id_poliza = oped.id_poliza
   and ope.id_certificado = oped.id_certificado
""")

# nfilas_cert_ope = df_certificado_operacion.count()
# logger.info(f"nfilas_cert_ope: {nfilas_cert_ope}")

df_certificado_operacion.createOrReplaceTempView("CERTIFICADO_OPERACION")

df_cobertura_unidad_asegurable_aux = spark.sql("""
    Select  CUA.*,
            CASE 
                WHEN CUA.id_moneda = 'SOL' THEN CUA.mto_suma_asegurada * dr.tc_factor_mes
                WHEN CUA.id_moneda = 'USD' THEN CUA.mto_suma_asegurada
                ELSE CUA.mto_suma_asegurada * -1
            END AS mto_suma_asegurada_usd
      from  cobertura_unidad_asegurable CUA,
            DATOS_REPORTE dr
     """)
df_cobertura_unidad_asegurable_aux.createOrReplaceTempView("COBERTURA_UNIDAD_ASEGURABLE_AUX")

df_rpn004_part1 = spark.sql("""
    Select distinct co.*, 
      CUA.mto_suma_asegurada,
      CASE
                WHEN CUA.mto_suma_asegurada_usd > 0 AND CUA.mto_suma_asegurada_usd < 80000 THEN '01'
                WHEN CUA.mto_suma_asegurada_usd >= 80000 AND CUA.mto_suma_asegurada_usd < 320000 THEN '02'
                WHEN CUA.mto_suma_asegurada_usd >= 320000 AND CUA.mto_suma_asegurada_usd < 800000 THEN '03'
                WHEN CUA.mto_suma_asegurada_usd >= 800000 AND CUA.mto_suma_asegurada_usd < 1200000 THEN '04'
                WHEN CUA.mto_suma_asegurada_usd >= 1200000 AND CUA.mto_suma_asegurada_usd < 5000000 THEN '05'
                ELSE '06'
      END AS categoria_mto_suma_asegurada, 
      C.id_certificado_origen as num_certificado, C.fec_inicio_vigencia, C.fec_fin_vigencia
      from    
            certificado C,
            unidad_asegurable A,
            ramo_unidad_asegurable R,
            COBERTURA_UNIDAD_ASEGURABLE_AUX CUA,
            CERTIFICADO_OPERACION co
     where  1 = 1
            and A.id_certificado = C.id_certificado
            and R.id_unidad_asegurable = A.id_unidad_asegurable
            and C.id_poliza = co.id_poliza
            and C.id_certificado = co.id_certificado
            and CUA.id_ramo_unidad_asegurable = R.id_ramo_unidad_asegurable
            and CUA.ind_principal = 'S'
 ;
            """)
df_rpn004_part1.createOrReplaceTempView("reporte4")

# nFilasrpn0004pt1 = df_rpn004_part1.count()
# logger.info(f"nFilasrpn0004pt1: {nFilasrpn0004pt1}")

df_rpn004_part1 =  spark.sql("""
      select tp.tipo_poliza, tp.cod_producto_origen, tp.num_poliza , tp.tipo_contratacion,'NA' AS NRO_COBERTURA_PROVISIONAL, I.cod_sbs, re.*
      from reporte4 re left join INDCORREDOR I
      on re.id_poliza = I.id_poliza left join TIPO_CONTRATACION tp
      on re.id_poliza = tp.id_poliza
""")

# nFilasrpn0004pt1 = df_rpn004_part1.count()
# logger.info(f"nFilasrpn0004pt1: {nFilasrpn0004pt1}")

df_rpn004_part2 = spark.sql("""
    SELECT distinct RB.id_certificado,
     CXC.fec_vencimiento  
     FROM recaudo_por_cobrar RXC,
          cuenta_por_cobrar_detalle CXCD,
          cuenta_por_cobrar CXC,
          recibo RB,
          recibo_recaudo RR
          --OPERACIONES op
      where   RB.id_recibo = RR.id_recibo
      and     RR.id_recaudo = RXC.id_recaudo
      and     CXCD.id_recaudo = RXC.id_recaudo  
      and     CXC.id_cuenta_por_cobrar = CXCD.id_cuenta_por_cobrar
      and     CXC.est_cuenta_por_cobrar <> 'ANU'
      --and     RB.id_certificado = op.id_certificado
      order by 1
""")

df_rpn004_part2.createOrReplaceTempView("rpn_parte2")

df_rpn004_part2 = spark.sql("""
    SELECT 
    id_certificado,
    MAX(CASE WHEN rn = 1 THEN fec_vencimiento END) AS fec_vencimiento1,
    MAX(CASE WHEN rn = 2 THEN fec_vencimiento END) AS fec_vencimiento2,
    MAX(CASE WHEN rn = 3 THEN fec_vencimiento END) AS fec_vencimiento3,
    MAX(CASE WHEN rn = 4 THEN fec_vencimiento END) AS fec_vencimiento4,
    MAX(CASE WHEN rn = 5 THEN fec_vencimiento END) AS fec_vencimiento5,
    MAX(CASE WHEN rn = 6 THEN fec_vencimiento END) AS fec_vencimiento6,
    MAX(CASE WHEN rn = 7 THEN fec_vencimiento END) AS fec_vencimiento7,
    MAX(CASE WHEN rn = 8 THEN fec_vencimiento END) AS fec_vencimiento8,
    MAX(CASE WHEN rn = 9 THEN fec_vencimiento END) AS fec_vencimiento9,
    MAX(CASE WHEN rn = 10 THEN fec_vencimiento END) AS fec_vencimiento10,
    MAX(CASE WHEN rn = 11 THEN fec_vencimiento END) AS fec_vencimiento11,
    MAX(CASE WHEN rn = 12 THEN fec_vencimiento END) AS fec_vencimiento12
FROM (
    SELECT 
        id_certificado,
        fec_vencimiento,
        ROW_NUMBER() OVER (PARTITION BY id_certificado ORDER BY fec_vencimiento) AS rn
    FROM 
        rpn_parte2 
) tmp
GROUP BY 
    id_certificado
""")

df_rpn004_part2.createOrReplaceTempView("rpn4pt2")

df_rpn004_part2 = spark.sql("""
    select re.* 
    from rpn4pt2 re,
    OPERACIONES op
    where op.id_certificado = re.id_certificado
""")

df_rpn004_part2.count()
# window_spec = Window.partitionBy("id_certificado").orderBy("fec_vencimiento")
# df_rpn004_part2 = df_rpn004_part2.withColumn("row_num", row_number().over(window_spec))
# df_rpn004_part2 = df_rpn004_part2.groupBy("id_certificado").pivot("row_num").agg(first("fec_vencimiento"))
# num_cols = len(df_rpn004_part2.columns)

# for i in range(1, num_cols):
#     df_rpn004_part2 = df_rpn004_part2.withColumnRenamed(str(i), f"fecha_de_vencimiento_{i}")

df_rpn004_part2 = df_rpn004_part2.withColumn(
    "fecha_pago_contado",
    when(df_rpn004_part2["fec_vencimiento2"].isNull(), df_rpn004_part2["fec_vencimiento1"]).otherwise(None)
)
df_rpn004_part2 = df_rpn004_part2.withColumn(
    "fec_vencimiento1",
    when(df_rpn004_part2["fecha_pago_contado"].isNull(), df_rpn004_part2["fec_vencimiento1"]).otherwise(None)
)
df_rpn004_part2 = df_rpn004_part2.withColumn(
    "forma_de_pago",
    when(df_rpn004_part2["fecha_pago_contado"].isNotNull(), "PC").otherwise("PF")
)

# df_rpn004_part2.show()

column_order = ["id_certificado","forma_de_pago" ,"fecha_pago_contado"] + \
               [f"fec_vencimiento{i}" for i in range(1, 13)]
df_rpn004_part2 = df_rpn004_part2.select(*column_order)

#df_rpn004_part2.show()

df_reporte4 = df_rpn004_part1.join(df_rpn004_part2, "id_certificado", "left")

logger.info(f"se imprime el dataframe antes de agregar la numeracion")
#df_reporte4.show()

windowSpec = Window.partitionBy("id_producto").orderBy("id_producto")

df_reporte4 = df_reporte4.withColumn("numero_secuencia", F.row_number().over(windowSpec))
#df_reporte4 = df_reporte4.withColumn("numero_secuencia", F.monotonically_increasing_id()+1)

df_reporte4 = df_reporte4.select(
    "numero_secuencia",
    *df_reporte4.columns[:-1]  
)

#df_reporte4.printSchema()

#df_reporte4.show()

# nfilas_re = df_reporte4.count()

# logger.info(f"nfilas_reporte_final: {nfilas_re}")

destino = get_parquet_path_pre_validacion(Constantes.C_REPORTES_SUCAVE,nombre_reporte,ruta)
destino_final = get_parquet_path_validacion(Constantes.C_REPORTES_SUCAVE,nombre_reporte,ruta, validar_version(get_last_blob(spark,destino)))

write_to_gcs(df_reporte4, destino_final) 
