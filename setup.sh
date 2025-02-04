#!/bin/bash

set -e  # Terminar si hay un error
echo "Validating all the required data in the system"
if ! ls | grep -q "oltpdata.csv"; then
	echo "Downloading data"
	wget https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0321EN-SkillsNetwork/oltp/oltpdata.csv
fi
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

# Esperar a que MySQL esté listo
echo "Waiting for MySQL pod to be ready..."
kubectl wait --for=condition=ready pod -l app=mysql --timeout=120s

echo "MySQL deployment completed successfully!"
