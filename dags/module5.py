from airflow import DAG
from datetime import timedelta,datetime

default_args={
    "owner":"module_5_etl",
    "depends_on_past": False,
    "start_date":datetime(2025,2,12),
    "email":["example@mail.com"],
    "email_on_failure": True,
    "email_on_retry":False,
    "retries":1,
    "retry_delay":timedelta(minutes=5),
}

dag= DAG(
    "module_etl",
    default_args=default_args,
    description="ETL process for module 5",
    schedule_interval=timedelta(days=1),
)