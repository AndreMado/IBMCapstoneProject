#!/bin/bash

set -e

echo "Exporting sales_data table to sales_data.sql..."

#I'm using kubernetes in my local machine, that's why the code is it different from a simple exporting mysql code
db_pod=$(kubectl get pod -l app=mysql -o jsonpath="{.items[0].metadata.name}")

mysql_password=$(kubectl get secret mysql-secret -o jsonpath="{.data.MYSQL_ROOT_PASSWORD}" | base64 --decode)

kubectl exec -it "$db_pod" -- mysqldump -u root -p"$mysql_password" sales sales_data > exsql/sales_data.sql

echo "Export completed! File saved as exsql/sales_data.sql"
