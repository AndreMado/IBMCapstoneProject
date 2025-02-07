#!/bin/bash

set -e  # Terminar si hay un error
echo "Validating all the required data in the system"
# Ensure the data directory exists
mkdir -p data
cd data

# Download the files only if they don't exist
if [ ! -f "oltpdata.csv" ]; then
    echo "Downloading oltpdata.csv..."
    wget -q --show-progress https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0321EN-SkillsNetwork/oltp/oltpdata.csv
else
    echo "oltpdata.csv already exists, skipping download."
fi

if [ ! -f "catalog.json" ]; then
    echo "Downloading catalog.json..."
    wget -q --show-progress https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0321EN-SkillsNetwork/nosql/catalog.json
else
    echo "catalog.json already exists, skipping download."
fi

cd ..
# Verificar si Minikube está corriendo
echo "Welcome to my Capstone project :) by Andres Maldonado"
echo "Checking Minikube status..."
if ! minikube status | grep -q "Running"; then
    echo "Starting Minikube..."
    minikube start --driver=docker
fi

# Aplicar los archivos YAML de MySQL
echo "Deploying MySQL in Kubernetes..."
kubectl apply -f k8s/mysql-secret.yaml
kubectl apply -f k8s/mysql-pvc.yaml
kubectl apply -f k8s/mysql-deployment.yaml
kubectl apply -f k8s/mysql-service.yaml
kubectl apply -f k8s/phpmyadmin-deployment.yaml
kubectl apply -f k8s/phpmyadmin-service.yaml
kubectl apply -f k8s/mongodb-secret.yaml
kubectl apply -f k8s/mongodb-pvc.yaml
kubectl apply -f k8s/mongodb-deployment.yaml
kubectl apply -f k8s/mongodb-service.yaml
kubectl apply -f k8s/postgres-secret.yaml
kubectl apply -f k8s/postgres-pvc.yaml
kubectl apply -f k8s/postgres-deployment.yaml
kubectl apply -f k8s/postgres-service.yaml
kubectl apply -f k8s/pgadmin-secret.yaml
kubectl apply -f k8s/pgadmin-deployment.yaml
kubectl apply -f k8s/pgadmin-service.yaml





# Esperar a que MySQL esté listo
echo "Waiting for MySQL pod to be ready..."
kubectl wait --for=condition=ready pod -l app=mysql --timeout=120s

echo "MySQL deployment completed successfully!"

# Ejecutar script SQL en MySQL
echo "Running SQL script to create and populate the database..."
kubectl exec -it $(kubectl get pod -l app=mysql -o jsonpath="{.items[0].metadata.name}") -- \
    mysql -u root -p$(kubectl get secret mysql-secret -o jsonpath="{.data.MYSQL_ROOT_PASSWORD}" | base64 --decode) < sql/OLTPdb.sql

echo "Database and data import completed successfully!"

chmod +x datadump.sh
./datadump.sh

echo "Initializating the import of the data into MongoDB"
python3 python/fixing_catalog.py

kubectl wait --for=condition=ready pod -l app=mongodb --timeout=120s
kubectl exec -it $(kubectl get pod -l app=mongodb -o jsonpath="{.items[0].metadata.name}") -- mongosh -u mongoadmin -p securepass --authenticationDatabase admin --eval '
use catalog
db.createCollection("electronics") '
kubectl cp data/catalog_fixed.json $(kubectl get pod -l app=mongodb -o jsonpath="{.items[0].metadata.name}"):/tmp/catalog_fixed.json
kubectl exec -it $(kubectl get pod -l app=mongodb -o jsonpath="{.items[0].metadata.name}") -- mongoimport --db catalog --collection electronics --file /tmp/catalog_fixed.json --jsonArray -u mongoadmin -p securepass --authenticationDatabase admin
echo "MongoDB deployment completed successfully!"

echo "Exporting MongoDB into .csv file"
kubectl exec -it $(kubectl get pod -l app=mongodb -o jsonpath="{.items[0].metadata.name}") -- mongoexport --db catalog --collection electronics --type=csv --fields _id,type,model --out /tmp/electronics.csv -u mongoadmin -p securepass --authenticationDatabase admin
kubectl exec -it $(kubectl get pod -l app=mongodb -o jsonpath="{.items[0].metadata.name}") -- ls /tmp
kubectl cp $(kubectl get pod -l app=mongodb -o jsonpath="{.items[0].metadata.name}"):/tmp/electronics.csv outputdata/electronics.csv

kubectl wait --for=condition=ready pod -l app=postgres --timeout=120s
kubectl exec -it $(kubectl get pod -l app=postgres -o jsonpath="{.items[0].metadata.name}") -- psql -U postgres -d postgres -c "\l"
