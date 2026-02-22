import datetime
import os
import logging
from airflow import DAG
from composer_staging_plugins import send_email
from pathlib import Path

from airflow.providers.google.cloud.operators.bigquery import BigQueryInsertJobOperator
from airflow.providers.google.cloud.operators.dataproc import (
    DataprocCreateBatchOperator,
    DataprocListBatchesOperator,
    DataprocDeleteBatchOperator
)
from airflow.operators.python_operator import PythonOperator
from airflow.models import Connection
from airflow.settings import Session
from composer_hub_regulatorio_plugin import get_parameters, get_file_name, get_task_list,get_bq_all_failed_joboperator,get_bq_all_success_joboperator, Constantes

staging_project_id = os.environ["HR_SOURCE_STAGING_PROJECT_ID"]
ingest_project_id = os.environ["INGEST_PROJECT_ID"]
sendgrid_mail_from = os.environ["SENDGRID_MAIL_FROM"]
sendgrid_api_key_secret_id = os.environ["SENDGRID_API_KEY_SECRET_ID"]
secrets_project_id = os.environ["SECRETS_PROJECT_ID"]
mails_recipients = os.environ["MAILS_RECIPIENTS"]
env_project_id = os.environ["ENV_DESC"]

folder_dag = get_file_name(__file__)

parameters = get_parameters(folder_dag)

parameters_dag_id = parameters['dag_id'].replace("{env}",env_project_id)
impersonation_chain_sa = os.environ["SERVICE_ACCOUNT_STG"]
scripts = parameters["scripts"]
create_disposition= parameters['create_disposition']
retries = int(parameters['retries']) if "retries" in parameters else 1
retry_delay = int(parameters['retry_delay']) if "retry_delay" in parameters else 5
mails_recipients = parameters['mail_responsables']

dependencies_tables_parameter = parameters['dependencies_table']
dependencies_tables_parameter = dependencies_tables_parameter.replace("{​​project_id_raw}", ingest_project_id)
dependencies_tables = dependencies_tables_parameter.replace("{project_id_raw}", ingest_project_id)

d = datetime.datetime(2023, 11, 20, 18, 00)
yesterday = datetime.datetime.combine(d - datetime.timedelta(1),datetime.datetime.min.time())

connection_id='bigquery_stg_custom'

session = Session()
gcp_conn = Connection(
    conn_id=connection_id,
    conn_type='google_cloud_platform',
    extra='{"extra__google_cloud_platform__project": "'+staging_project_id+'" }')
if not session.query(Connection).filter(
    Connection.conn_id == gcp_conn.conn_id).first():
    session.add(gcp_conn)
    session.commit()

default_dag_args = {
    # Setting start date as yesterday starts the DAG immediately when it is
    # detected in the Cloud Storage bucket.
    'start_date': yesterday,
    # To email on failure or retry set 'email' arg to your email and enable
    # emailing here.
    'email_on_failure': False,
    'email_on_retry': False,
    # If a task fails, retry it once after waiting at least what's specified in retry_delay
    'retries': retries,
    'retry_delay': datetime.timedelta(minutes=retry_delay),
    'project_id': ingest_project_id
}

with DAG(dag_id=parameters_dag_id,
    schedule_interval="17 18 21 11 *",
    default_args=default_dag_args) as dag:
#######################
##### Define Tasks ####
#######################

    all_failed = get_bq_all_failed_joboperator(dag, dependencies_tables, create_disposition, impersonation_chain_sa,connection_id)
    all_success = get_bq_all_success_joboperator(dag, dependencies_tables, create_disposition, impersonation_chain_sa,connection_id)

    dag_error_mail = '{0}-error_mail'.format(dag.dag_id)

    task_dict = get_task_list(scripts, Constantes.C_CAPA_DELIVERY, Constantes.C_SBS)
    
    task_dict[dag_error_mail] = PythonOperator(
        task_id=dag_error_mail,
        python_callable=send_email,
        trigger_rule="one_failed",
        op_args=[sendgrid_api_key_secret_id,
                    sendgrid_mail_from,
                    secrets_project_id,
                    mails_recipients,
                    'DAG {0}, stg to univ'.format(dag.dag_id),
                    dag.dag_id,
                    'Entidades Universal',
                    "None",
                    "Triggered by dag {0}".format(dag.dag_id),
                    dag,
                    False],
        dag=dag)

task_dict[dag_error_mail] << task_dict["cobertura_fallecimiento"]

[all_failed,all_success] << task_dict["cobertura_fallecimiento"]