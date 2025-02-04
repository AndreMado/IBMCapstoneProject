# IBMCapstoneProject
This is the IBM Capstone Project, where I'll use all the technologies that I have learned throughout all the IBM courses to become a Data Engineer. You will find a complete hypothetical scenario that demonstrates the tasks and challenges a Data Engineer faces in their daily work.

# Environment:
This document introduces you to the data platform architecture of an ecommerce company named SoftCart.

SoftCart uses a hybrid architecture, with some of its databases on premises and some on cloud.

# Tools and Technologies:
OLTP database - MySQL
NoSql database - MongoDB
Production Data warehouse – DB2 on Cloud
Staging Data warehouse – PostgreSQL
Big data platform - Hadoop
Big data analytics platform – Spark
Business Intelligence Dashboard - IBM Cognos Analytics
Data Pipelines - Apache Airflow

# Process:
SoftCart's online presence is primarily through its website, which customers access using a variety of devices like laptops, mobiles and tablets.

All the catalog data of the products is stored in the MongoDB NoSQL server.

All the transactional data like inventory and sales are stored in the MySQL database server.

SoftCart's webserver is driven entirely by these two databases.

Data is periodically extracted from these two databases and put into the staging data warehouse running on PostgreSQL.

The production data warehouse is on the cloud instance of IBM DB2 server.

BI teams connect to the IBM DB2 for operational dashboard creation. IBM Cognos Analytics is used to create dashboards.

SoftCart uses Hadoop cluster as its big data platform where all the data is collected for analytics purposes.

Spark is used to analyse the data on the Hadoop cluster.

To move data between OLTP, NoSQL and the data warehouse, ETL pipelines are used and these run on Apache Airflow.

# Steps to run the project

## Installing Kubernetes with Minikube on Ubuntu(If you're other OS you can find how to install kubernetes on Google)
To run Kubernetes locally for development and testing, we will use **Minikube**, which allows us to deploy a lightweight single-node cluster.

### **1. Install Required Dependencies**
Before installing Minikube, update your package list and install necessary tools:

```bash
sudo apt update
sudo apt install -y curl wget apt-transport-https
```

### **2. Install kubectl**
`kubectl` is the command-line tool used to interact with Kubernetes clusters.

```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
```

Verify the installation:
```bash
kubectl version --client
```

### **3. Install Minikube**
Download and install Minikube:

```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

Verify the installation:
```bash
minikube version
```

### **4. Start Kubernetes with Minikube**
To start Minikube, use the following command:

```bash
minikube start --driver=docker
```

This initializes a Kubernetes cluster using **Docker** as the container runtime.

### **5. Verify the Cluster is Running**
To check if Kubernetes is running, use:

```bash
kubectl get nodes
```

If the output shows a node in **Ready** state, the cluster is successfully set up.

---


