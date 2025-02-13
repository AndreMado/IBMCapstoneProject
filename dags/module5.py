from airflow import DAG
from datetime import timedelta, datetime
from airflow.operators.python_operator import PythonOperator
import re
import tarfile

default_args = {
    "owner": "module_5_etl",
    "depends_on_past": False,
    "start_date": datetime(2025, 2, 12),
    "email": ["example@mail.com"],
    "email_on_failure": True,
    "email_on_retry": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}

dag = DAG(
    "process_web_log",
    default_args=default_args,
    description="ETL process for module 5",
    schedule_interval=timedelta(days=1),
)

# Extract Data Function
def extract_data():
    input_log_file = "/opt/airflow/data/accesslog.txt"
    output_log_file = "/opt/airflow/data/extracted_data.txt"
    try:
        with open(input_log_file, 'r') as infile, open(output_log_file, "w") as outfile:
            for line in infile:
                match = re.search(r"\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b", line)
                if match:
                    outfile.write(match.group(0) + "\n")
        print("Extraction completed.")
    except Exception as e:
        print(f"Error processing file: {e}")

# Transform Data Function
def transform_data():
    input_file = "/opt/airflow/data/extracted_data.txt"
    output_file = "/opt/airflow/data/transformed_data.txt"
    ip_to_remove = "198.46.149.143"
    try:
        with open(input_file, "r") as infile, open(output_file, "w") as outfile:
            for line in infile:
                if ip_to_remove not in line:
                    outfile.write(line)
        print("Transformation completed.")
    except Exception as e:
        print(f"Error processing file: {e}")

# Load Data Function
def load_data():
    input_file = "/opt/airflow/data/transformed_data.txt"
    output_tar = "/opt/airflow/data/weblog.tar"

    try:
        with tarfile.open(output_tar, "w") as tar:
            tar.add(input_file, arcname="transformed_data.txt")
        print("Archiving completed successfully.")
    except Exception as e:
        print(f"Error during archiving: {e}")

# Define Tasks in Airflow
extract_data_task = PythonOperator(
    task_id="extract_data",
    python_callable=extract_data,
    dag=dag,
)

transform_data_task = PythonOperator(
    task_id="transform_data",
    python_callable=transform_data,
    dag=dag,
)

load_data_task = PythonOperator(
    task_id="load_data",
    python_callable=load_data,
    dag=dag,
)

# Task Dependencies
extract_data_task >> transform_data_task >> load_data_task
