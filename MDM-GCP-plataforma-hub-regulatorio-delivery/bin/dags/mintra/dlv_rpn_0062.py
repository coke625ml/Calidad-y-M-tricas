# import datetime
import os
import logging
from airflow import DAG
from composer_staging_plugins import send_email
from pathlib import Path
import calendar
from airflow.providers.google.cloud.operators.bigquery import BigQueryInsertJobOperator
from airflow.providers.google.cloud.operators.dataproc import (
    DataprocCreateBatchOperator,
    DataprocListBatchesOperator,
    DataprocDeleteBatchOperator
)

from airflow.operators.dagrun_operator import TriggerDagRunOperator

from airflow.operators.python_operator import PythonOperator
from airflow.operators.python import ShortCircuitOperator
from airflow.models import Connection
from airflow.settings import Session
from composer_hub_regulatorio_plugin import get_bq_all_success_joboperator, Constantes
from composer_hub_regulatorio_plugin import get_task_list,get_bq_all_failed_joboperator
from composer_hub_regulatorio_plugin import get_parameters, get_file_name
#DATAPROC OPERATOR
#dag_run.conf
from airflow.operators.python import PythonOperator
from airflow.exceptions import AirflowSkipException, AirflowFailException
from datetime import datetime, timedelta
from croniter import croniter

import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

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
sync_dag_id = "ue4_{env}_com_gco_export_001_hub_regulatorio_sync".replace("{env}",env_project_id)

impersonation_chain_sa = os.environ["SERVICE_ACCOUNT_STG"]
scripts = parameters["scripts"]
create_disposition= parameters['create_disposition']
retries = int(parameters['retries']) if "retries" in parameters else 1
retry_delay = int(parameters['retry_delay']) if "retry_delay" in parameters else 5
mails_recipients = parameters['mail_responsables']

dependencies_tables_parameter = parameters['dependencies_table']
dependencies_tables_parameter = dependencies_tables_parameter.replace("{​​project_id_raw}", ingest_project_id)
dependencies_tables = dependencies_tables_parameter.replace("{project_id_raw}", ingest_project_id)

d = datetime(2024, 6, 10, 11, 59)
yesterday = datetime.combine(d - timedelta(1), datetime.min.time())

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
    'start_date': d,
    # To email on failure or retry set 'email' arg to your email and enable
    # emailing here.
    'email_on_failure': False,
    'email_on_retry': False,
    # If a task fails, retry it once after waiting at least what's specified in retry_delay
    'retries': retries,
    'retry_delay': timedelta(minutes=retry_delay),
    'project_id': ingest_project_id
}

# periodo = "202402"

# def convert_period(period_str):
#     year = period_str[:4]
#     month = period_str[4:]
#     return datetime.date(int(year), int(month), 1).strftime("%Y-%m-%d")

# periodo = convert_period(periodo) 

# ////////////////////////

def check_date_and_schedule(cron_expression, **context):
    current_datetime = datetime.now()
    dag_run = context['dag_run']  # Get the current DAG run object

    # 1. Cron Expression Check:
    cron_iter = croniter(cron_expression, current_datetime)
    next_scheduled_run = cron_iter.get_next(datetime)

    run_id = dag_run.run_id
    if not run_id.startswith("scheduled__"):
# 2. Check for 'periodo' in dag_run.conf:
        periodo = dag_run.conf.get('periodo')

        logger.info(f"periodo : {periodo}")

        cond = (next_scheduled_run.date() != current_datetime.date()) or (
            abs(next_scheduled_run - current_datetime).total_seconds() > 60
        )
        if not periodo and cond :
            raise AirflowSkipException("DAG must be run with a 'periodo' configuration.")

# //////////////////////////

def dag_already_ran_this_period(cron_expression_v1):
    
    current_datetime = datetime.now()
    
    # 1. Cron Expression Check:
    cron_iter = croniter(cron_expression_v1, current_datetime)
    last_scheduled_run = cron_iter.get_prev(datetime)
    next_scheduled_run = cron_iter.get_next(datetime)
    
    current_datetime_cons = current_datetime.date()
    last_scheduled_run_cons = last_scheduled_run.date()
    next_scheduled_run_cons = next_scheduled_run.date()
    
    logger.info(f" current_datetime:  {current_datetime_cons}")
    logger.info(f" last_scheduled_run:  {last_scheduled_run_cons}")
    logger.info(f" last_scheduled_run:  {next_scheduled_run_cons}")
    

    if (last_scheduled_run.date() == current_datetime.date()) or (
        abs(last_scheduled_run - current_datetime).total_seconds() <= 60):
        return False # debe estar en True, por pruebas lo cambiamos a False
    elif (next_scheduled_run.date() == current_datetime.date()) or (
        abs(next_scheduled_run - current_datetime).total_seconds() <= 60):
        return False # debe estar en True, por pruebas lo cambiamos a False
    else :
        return False

        

def should_execute_dag(cron_expression_v1):
    flag = 1  # se debe cambiar con el valor de una tabla de control (mantenemos asi para que se ejecute todos los jobs)
    today = datetime.now().day

    if flag == 0:
        return False
    elif today >= 10 and today <= 15 and flag == 1:
        if dag_already_ran_this_period(cron_expression_v1):
            return False
        else:
            return True
    return True


with DAG(dag_id=parameters_dag_id,
    schedule_interval= "00 21 10,11,12,13,14,15 * *",
    catchup = False,
    default_args=default_dag_args) as dag:
#######################
##### Define Tasks ####
#######################

    check_and_execute = ShortCircuitOperator(
        task_id='check_date_and_flag',
        python_callable=should_execute_dag,
        op_kwargs={
            'cron_expression_v1': '00 21 10,11,12,13,14,15 * *',
        },
        
    )# Las tareas definidas después de check_and_execute solo se ejecutarán si check_and_execute devuelve True
    
    check_date_and_schedule_task = PythonOperator(
        task_id='check_date_and_schedule',
        python_callable=check_date_and_schedule,
        op_kwargs={
            'cron_expression': '00 21 10,11,12,13,14,15 * *',
        },
    )

    
    all_failed = get_bq_all_failed_joboperator(dag, dependencies_tables, create_disposition, impersonation_chain_sa,connection_id)
    all_success = get_bq_all_success_joboperator(dag, dependencies_tables, create_disposition, impersonation_chain_sa,connection_id)

    dag_error_mail = '{0}-error_mail'.format(dag.dag_id)
    dag_trigger_task = 'hr_trigger_export'

    task_dict = get_task_list(scripts, Constantes.C_CAPA_DELIVERY, Constantes.C_REPORTES_MINTRA)

    task_dict[dag_error_mail] = PythonOperator(
        task_id=dag_error_mail,
        python_callable=send_email,
        trigger_rule="one_failed",
        op_args=[sendgrid_api_key_secret_id,
                    sendgrid_mail_from,
                    secrets_project_id,
                    mails_recipients,
                    'DAG {0}, Univ to Deliv'.format(dag.dag_id),
                    dag.dag_id,
                    'Reportes Sucave',
                    "None",
                    "Triggered by dag {0}".format(dag.dag_id),
                    dag,
                    False],
        dag=dag)
    
    next_dag_trigger_task = TriggerDagRunOperator(
    task_id=dag_trigger_task,
    trigger_dag_id= sync_dag_id,
    dag=dag
    )

check_and_execute >> check_date_and_schedule_task >> task_dict["rpn_0062"] 

task_dict["rpn_0062"] >> task_dict["rpn_0062_exp"] >> next_dag_trigger_task

task_dict[dag_error_mail] << task_dict["rpn_0062"]

task_dict[dag_error_mail] << task_dict["rpn_0062_exp"]

task_dict[dag_error_mail] << next_dag_trigger_task

[all_failed,all_success] << next_dag_trigger_task