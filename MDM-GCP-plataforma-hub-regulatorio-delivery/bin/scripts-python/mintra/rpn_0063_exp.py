from pyspark.sql import SparkSession
from pyspark.sql.functions import col, expr, lpad, lit, when, rpad, udf
from dataproc_delivery_plugin import get_spark_session, get_parquet_path_validacion, get_parquet_path_preexport, get_parquet_path_pre_validacion
from dataproc_delivery_plugin import get_parquet_path,read_table_as_df, Constantes, write_to_gcs_txt
from dataproc_delivery_plugin import get_last_day, get_path_inicio, Constantes, get_last_blob_py, upload_to_gcs
from pyspark.sql.functions import concat_ws
from pyspark.sql.types import StringType
from pyspark.sql.functions import date_format
import re
from datetime import datetime
from calendar import monthrange
from dateutil.relativedelta import relativedelta
import logging
import pandas as pd
from reportlab.lib.pagesizes import letter
from reportlab.platypus import SimpleDocTemplate, Table, TableStyle
from reportlab.lib import colors

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

#def get_parquet_path_validacion(entidad,nombre_reporte,periodo,filename):

ruta, inicio, lastdate = get_path_inicio(Constantes.C_RPN_0063)

C_YYMMDD = lastdate.replace("-","")[2:]  #ultimo dia mes formato  YYMMDD
C_YYYYMMDD = lastdate.replace("-","")  #ultimo dia mes formato  YYYYMMDD
C_YYYY = lastdate.split("-")[0]  #ultimo dia mes formato  YYYY
#Calcula en que quarter del año esta segun la fecha que se encuentra en lastdate, por ejemplo si tengo lastdate = 2023-09-30, entonces C_QUARTER = 3
C_QUARTER = str((datetime.strptime(lastdate, '%Y-%m-%d').month - 1) // 3 + 1)

nombre_reporte = "RPN0063"

# Nombre del archivo PDF de salida
file_name = f"Trimestral SOAT - Primas por Departamento y Provincia {C_QUARTER}Q{C_YYYY}.pdf"

origen = get_parquet_path_pre_validacion(Constantes.C_REPORTES_MINTRA,nombre_reporte,ruta)
ruta_parquet = get_parquet_path_validacion(Constantes.C_REPORTES_MINTRA,nombre_reporte,ruta,get_last_blob_py(origen))

# Leer datos del archivo Parquet
df = pd.read_parquet(ruta_parquet)

# Generar Titulo

# Definir los datos como un diccionario
datos_titulo = {
    'PRIMAS POR DEPARTAMENTO Y PROVINCIA': [''],
}
data_1 = [list(pd.DataFrame(datos_titulo))] + ['                          ']

# Convertir el DataFrame a una lista de listas para ReportLab
data_2 = [list(df.columns)] + df.reset_index(drop=True).values.tolist()

# Generar leyenda
datos_leyenda = {
    '''
* Son primas comerciales acumuladas desde el inicio del año hasta el cierre del periodo.
* Todos los montos están expresados en nuevos soles. 
* Las provincias del país están según el código de ubigeo del INEI
''': [''],
}

data_3 = [list(pd.DataFrame(datos_leyenda))] + ['                          ']


# Crear documento PDF
pdf = SimpleDocTemplate(file_name, pagesize=letter)

# Configurar estilo del titulo
table_style_1 = TableStyle([
    ('BACKGROUND', (0, 0), (-1, 0), colors.red),
    ('TEXTCOLOR', (0, 0), (-1, 0), colors.white),
    ('ALIGN', (0, 0), (0, -1), 'CENTER'),   # Alinear la primera columna a la izquierda
    #('ALIGN', (1, 0), (-1, -1), 'RIGHT'), # Alinear las demás columnas a la derecha
    ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
    ('BOTTOMPADDING', (0, 0), (-1, 0), 20),
    ('COLUMNWIDTHS', (0,0), (-1,-1), [400]),  # Ejemplo de ajuste de anchos de columna
    ('FONTSIZE', (0,0), (-1, 0), 14),
    #('BACKGROUND', (0, 1), (-1, -1), colors.white),
    #('GRID', (0, 0), (-1, -1), 0, colors.white),  # Eliminar las líneas internas
    ('BOX', (0, 0), (-1, 0), 2, colors.red),   # Establecer el borde externo grueso
    #('LINEBEFORE', (1, 0), (-1, -1), 1, colors.black),  # Líneas que separan las columnas
    #('LINEAFTER', (0, 0), (-2, -1), 1, colors.black)    # Líneas que separan las columnas
])

# Crear objeto de tabla y aplicar estilo  - titulo
title = Table(data_1)
title.setStyle(table_style_1)
# Ajustar la posición de la tabla a la izquierda
title.hAlign = 'LEFT'

# Configurar estilo de la tabla
table_style_2 = TableStyle([
    ('BACKGROUND', (0, 0), (-1, 0), colors.red),
    ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
    ('ALIGN', (0, 0), (0, -1), 'LEFT'),   # Alinear la primera columna a la izquierda
    ('ALIGN', (1, 0), (-1, -1), 'RIGHT'), # Alinear las demás columnas a la derecha
    ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
    ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
    ('BACKGROUND', (0, 1), (-1, -1), colors.white),
    ('FONTSIZE', (0,0), (-1, -1), 9),
    ('BOTTOMPADDING', (0, 0), (-1, -1), 0),
    ('GRID', (0, 0), (-1, -1), 0, colors.white),  # Eliminar las líneas internas
    ('BOX', (0, 0), (-1, -1), 2, colors.black),   # Establecer el borde externo grueso
    ('LINEBEFORE', (1, 0), (-1, -1), 1, colors.black),  # Líneas que separan las columnas
    ('LINEAFTER', (0, 0), (-2, -1), 1, colors.black)    # Líneas que separan las columnas
])

# Crear objeto de tabla y aplicar estilo  - tabla
table = Table(data_2)
table.setStyle(table_style_2)
# Ajustar la posición de la tabla a la izquierda
table.hAlign = 'LEFT'

# Configurar estilo de la Leyenda
table_style_3 = TableStyle([
    ('BACKGROUND', (0, 0), (-1, 0), colors.white),
    ('TEXTCOLOR', (0, 0), (-1, 0), colors.black),
    ('ALIGN', (0, 0), (0, -1), 'LEFT'),   # Alinear la primera columna a la izquierda
    #('ALIGN', (1, 0), (-1, -1), 'RIGHT'), # Alinear las demás columnas a la derecha
    ('FONTNAME', (0, 0), (-1, 0), 'Helvetica'),
    #('BOTTOMPADDING', (0, 0), (-1, 0), 12),
    #('BACKGROUND', (0, 1), (-1, -1), colors.white),
    #('GRID', (0, 0), (-1, -1), 0, colors.white),  # Eliminar las líneas internas
    #('BOX', (0, 0), (-1, -1), 2, colors.black),   # Establecer el borde externo grueso
    #('LINEBEFORE', (1, 0), (-1, -1), 1, colors.black),  # Líneas que separan las columnas
    #('LINEAFTER', (0, 0), (-2, -1), 1, colors.black)    # Líneas que separan las columnas
])
# Crear objeto de tabla y aplicar estilo  - Leyenda
legend = Table(data_3)
legend.setStyle(table_style_3)
# Ajustar la posición de la tabla a la izquierda
legend.hAlign = 'LEFT'

# Construir el PDF
elems = []
elems.extend([title, table, legend])

pdf.build(elems)

print(f"PDF generado: {file_name}")

# Escribir el contenido en un archivo de texto 

ruta_destino = get_parquet_path_preexport(Constantes.C_REPORTES_MINTRA,nombre_reporte,ruta,get_last_blob_py(origen),file_name)

upload_to_gcs(file_name,ruta_destino)
