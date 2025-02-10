# IBM Capstone Project

This is the IBM Capstone Project, where I'll use all the technologies that I have learned throughout all the IBM courses to become a Data Engineer. You will find a complete hypothetical scenario that demonstrates the tasks and challenges a Data Engineer faces in their daily work.

## 📌 Environment
This document introduces you to the data platform architecture of an eCommerce company named **SoftCart**.

SoftCart uses a **hybrid architecture**, with some of its databases on-premises and others in the cloud.

## 📌 Tools and Technologies
- **OLTP database:** MySQL
- **NoSQL database:** MongoDB
- **Production Data Warehouse:** IBM DB2 on Cloud
- **Staging Data Warehouse:** PostgreSQL
- **Big Data Platform:** Hadoop
- **Big Data Analytics:** Apache Spark
- **Business Intelligence Dashboard:** IBM Cognos Analytics
- **Data Pipelines:** Apache Airflow

## 📌 Data Processing Workflow

1. **SoftCart's website** serves customers through multiple devices like laptops, mobiles, and tablets.
2. **Product catalog data** is stored in **MongoDB**.
3. **Transactional data (inventory & sales)** is stored in **MySQL**.
4. The **web server** interacts with these two databases.
5. Data is periodically **extracted from MySQL & MongoDB** and loaded into a **PostgreSQL staging data warehouse**.
6. The **production data warehouse** is hosted on **IBM DB2 Cloud**.
7. **BI teams** use IBM DB2 for dashboard creation via **IBM Cognos Analytics**.
8. A **Hadoop cluster** collects all data for **big data analytics**.
9. **Apache Spark** analyzes data stored in Hadoop.
10. **Apache Airflow** manages ETL pipelines for data movement between all components.

---

# 🚀 Steps to Run the Project

## **1️⃣ Installing Kubernetes with Minikube on Ubuntu**
To set up Kubernetes for development and testing, we will use **Minikube**, a lightweight single-node cluster.

### **1. Install Required Dependencies**
```bash
sudo apt update
sudo apt install -y curl wget apt-transport-https
```

### **2. Install kubectl**
```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client
```

### **3. Install Minikube**
```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube version
```

### **4. Start Minikube with Docker**
```bash
minikube start --driver=docker
```

### **5. Verify Minikube is Running**
```bash
kubectl get nodes
```

---

## **2️⃣ Deploying MySQL and phpMyAdmin in Minikube**

### **1. Running the Setup Script**
A script `setup.sh` is available to automate deployment.

Run:
```bash
chmod +x setup.sh
./setup.sh
```
This will:
- Start **Minikube** (if not already running).
- Deploy **MySQL** and **phpMyAdmin**.
- Ensure MySQL is **ready** before proceeding.
- Deploy **MongoDB**.

### **2. Access phpMyAdmin**
Find Minikube's IP:
```bash
minikube ip
```
Open:
```
http://<MINIKUBE_IP>:30001
```

### **3. Login Credentials**
- **Username:** `root`
- **Password:** (stored in Kubernetes Secret, default: `rootpassword`)

---

## **3️⃣ Deploying MongoDB in Minikube**

MongoDB is automatically deployed using `setup.sh`. If needed, deploy manually:
```bash
kubectl apply -f k8s/mongodb-secret.yaml
kubectl apply -f k8s/mongodb-pvc.yaml
kubectl apply -f k8s/mongodb-deployment.yaml
kubectl apply -f k8s/mongodb-service.yaml
```

### **Verify MongoDB Deployment**
```bash
kubectl get pods
kubectl get svc
```

### **Access MongoDB Inside Kubernetes**
```bash
kubectl exec -it $(kubectl get pod -l app=mongodb -o jsonpath="{.items[0].metadata.name}") -- mongosh -u mongoadmin -p securepass --authenticationDatabase admin
```

### **List Available Databases**
```javascript
show dbs
```

### **Retrieve MongoDB Credentials from Kubernetes Secret**
```bash
kubectl get secret mongodb-secret -o jsonpath="{.data.MONGO_ROOT_PASSWORD}" | base64 --decode
```

---

## **4️⃣ Connecting pgAdmin to PostgreSQL in Minikube**

### **1. Retrieve PostgreSQL Service IP**
```bash
kubectl get svc postgres-service
```
📌 **Note the `CLUSTER-IP` and port (`5432/TCP`)**. Use the **service name (`postgres-service`)** instead of a pod IP.

### **2. Access pgAdmin**
```bash
minikube service pgadmin-service --url
```
Login with:
- **Email:** `pgadmin@example.com`
- **Password:** `securepass`

### **3. Add a New Server in pgAdmin**
1. In **pgAdmin**, right-click on **"Servers"** → **"Create" → "Server"**.
2. **General Tab** → Set **Name**: `PostgreSQL Minikube`.
3. **Connection Tab**:
   - **Host name/address:** `postgres-service` (or `CLUSTER-IP` from step 1).
   - **Port:** `5432`
   - **Maintenance database:** `staging`
   - **Username:** `admin`
   - **Password:** `securepass` (must be entered manually).
   - **Click "Save"**.

### **4. Verify the Connection**
If successful, expand **Databases → staging** in **pgAdmin**.  
If issues arise, check:
```bash
kubectl get pods -l app=postgres
kubectl get svc postgres-service
kubectl logs -l app=postgres
```

---

🚀 **Now PostgreSQL is accessible from pgAdmin!** 🎯