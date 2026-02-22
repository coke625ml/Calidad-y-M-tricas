import functions_framework
from google.cloud import storage, secretmanager
from shareplum import Site
from shareplum import Office365
from shareplum.site import Version
import requests
import os

secrets_project_id_env = os.environ.get('SECRETS_PROJECT_ID')
sharepoint_pwd_env = os.environ.get('SHAREPOINT_PWD')
sharepoint_domain_env = os.environ.get('SHAREPOINT_DOMAIN')
project_id_env = os.environ.get('PROJECT_ID')

sharepoint_site_env = os.environ.get('SHAREPOINT_SITE')
sharepoint_url_env = os.environ.get('SHAREPOINT_URL')
sharepoint_folder_env = os.environ.get('SHAREPOINT_FOLDER')

sharepoint_folder_env_mod = sharepoint_folder_env if sharepoint_folder_env.startswith("/sites/co03/hub-regulatorio") else sharepoint_folder_env.replace("_", " ", 1)

def get_secret(secret_name):
    client = secretmanager.SecretManagerServiceClient()
    project_id = secrets_project_id_env
    name = f"projects/{project_id}/secrets/{secret_name}/versions/latest"
    response = client.access_secret_version(request={"name": name})
    return response.payload.data.decode("UTF-8")

def create_missing_folders_and_upload_file(site,file_content,file_name,sharepoint_folder):
    """
    Creates the missing folders in the specified path and uploads the file to SharePoint.
    Args:
        site (Site): Instance of the SharePoint site.
        sharepoint_folder (str): Path of the folder in SharePoint where the files will be uploaded.
        file_content (obj): Content of the file to upload to SharePoint.
        file_name (str): Name and extension of the file to upload to SharePoint.
    """
    folders = sharepoint_folder.split("/")
    current_folder = sharepoint_folder_env_mod
    
    for folder_name in folders[5:]:  # Omite los 5 primeros elementos ("/personal/xt8741_rimac_com_pe/Documents/hub_regulatorio")
        current_path = f"{current_folder}/{folder_name}"
        try:
                if folder_name != folders[-1]:
                    folder = site.Folder(current_path)
                    folder.upload_file(file_content, file_name)
                    folder.delete_file(file_name)
                    current_folder = f"{current_path}"
                else:
                    folder = site.Folder(current_path)
                    folder.upload_file(file_content, file_name)
        except requests.exceptions.HTTPError as e:
                # Ignorar error si la carpeta ya existe
                if e.response.status_code != 409:
                    raise

# Triggered by a change in a storage bucket
@functions_framework.cloud_event
def copy_to_sharepoint(cloud_event):
    """Triggered by a change to a Cloud Storage bucket.
    Args:
         cloud_event (dict): Event payload.
         cloud_event["id"] : Id for the event.
         cloud_event["type"] : type for the event.
    """
    try: 
        # Obtener información sobre el evento
        data = cloud_event.data
    
        bucket_name = data['bucket']
        full_path = data['name']
        #variables de entorno

        #project_id_raw = os.environ.get('PROJECT_ID_RAW')   
        ruta_base_input = "hub_regulatorio"
        # Imprimir información para verificar
        print('|=|=|=|=|=|=|=|=|=|=|=|=|=|')
        print('=======EVENT DETAILS=======')
        print('|=|=|=|=|=|=|=|=|=|=|=|=|=|')
        print(f"Bucket name: {bucket_name}")
        print(f"Full path: {full_path}")
        # Obtener la ruta de la carpeta en el bucket
        file_name = full_path.rsplit("/", 1)[1]  # Obtener el nombre del archivo
        folder_path = full_path.rsplit("/", 1)[0]  # Eliminar el nombre del archivo
        
        # se valida para que no se suban archivos en carpetas fuera de lugar
        flag_error_file_located=0
        try:
            version_folder = folder_path.split('/',4)[4]  # Obtener el nombre de la carpeta version
            date_folder = folder_path.split('/',4)[3]  # Obtener el nombre de la carpeta fecha
            report_folder = folder_path.split('/',4)[2]  # Obtener el nombre de la carpeta reporte
            entidad_folder = folder_path.split('/',4)[1]  # Obtener el nombre de la carpeta entidad
            print(f"archivo que activa el evento se encuentra en la direccion correcta")
            # Imprimir información para verificar
            print("Se imprimen los ficheros a participar: ")
            print(f"File name: {file_name}")
            print(f"Folder path: {folder_path}")
            print(f" Version folder: {version_folder}")
            print(f" Date folder: {date_folder}")
            print(f" Reporte folder: {report_folder}")
            print(f" Entidad folder: {entidad_folder}")
        except Exception as e:
            flag_error_file_located = 1
            print(f"Se debe subir archivos solo en las carpetas de versiones: {e}")

        #Validamos si el evento generado es por un arhivo en nuestra ruta deseada 
        print('============================================================')
        print(f'LA RUTA DEL EVENTO EXPORT A SHAREPOINT ES: {full_path}')
        print('============================================================')
        event_directory = full_path.split('/')[0]
        print(f'Proyecto --> {project_id_env}')
        if ruta_base_input == event_directory:
            if flag_error_file_located != 1:
                print(f'Folder {event_directory} asociado al cloud function. Iniciando procesamiento..')
                ## Leer el contenido del archivo CSV desde Cloud Storage
                storage_client = storage.Client()
                bucket = storage_client.bucket(bucket_name)
                blob = bucket.blob(full_path)
                file_content = blob.download_as_string()
                
                # Configurar la conexión a SharePoint
                sharepoint_site = sharepoint_site_env
                sharepoint_url = sharepoint_url_env
                sharepoint_username = sharepoint_domain_env
                # Obtén la contraseña desde Secret Manager
                sharepoint_password = get_secret(sharepoint_pwd_env)
                # Carpeta donde se copiarán los archivos  
                sharepoint_folder = f"{sharepoint_folder_env_mod}/{entidad_folder}/{report_folder}/{date_folder}/{version_folder}" 
                # Definir la variable site fuera del bloque with
                site = None
                authcookie = None
                
                # Crear la conexión al sitio de SharePoint
                try:    
                    authcookie = Office365(sharepoint_site, username=sharepoint_username, password=sharepoint_password).GetCookies()
                    site = Site(sharepoint_url, version=Version.v365, authcookie=authcookie)
                    if site is not None and authcookie is not None:
                        print(f"logeo exitoso al sharepoint : {sharepoint_url}")
                    else:
                        print("No se pudo inicializar la conexión a SharePoint.")
                    #creacion de carpetas faltantes  y subir archivo a sharepoint
                    try:
                        create_missing_folders_and_upload_file(site,file_content,file_name,sharepoint_folder)
                        print(f"creacion de carpetas faltantes y subida de archivo a sharepoint exitosa")
                    except Exception as e:
                        print(f"Error en la creacion de carpetas faltantes y subida de archivo a sharepoint: {e}")
                except Exception as e:
                    print(f"Error en la conexión a SharePoint: {e}")
            else:
                print(f"El objeto {full_path} no se encuentra dentro de las longitutes o versiones deseadas")
        else:
            print(f"El objeto {full_path} no se encuentra dentro de las limitantes( ruta base: {ruta_base_input}) para correr el cloud function ")
        print('llamada existosa completada')
    except Exception as e:
        print(f'Error al ejecutar cloud function=> {e}')