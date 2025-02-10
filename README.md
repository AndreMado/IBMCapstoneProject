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

## **1️⃣ Deploying Services Using setup.sh (Recommended)**
The `setup.sh` script automates the deployment of all necessary services in Minikube, including:
- **MySQL and phpMyAdmin**
- **MongoDB**
- **PostgreSQL and pgAdmin**
- **Downloading required datasets**
- **Executing initial SQL scripts**

### **Run the script:**
```bash
chmod +x setup.sh
./setup.sh
```

### **What the script does:**
1. Starts **Minikube** (if not already running).
2. Deploys **MySQL** and **phpMyAdmin**.
3. Deploys **MongoDB**.
4. Deploys **PostgreSQL** and **pgAdmin**.
5. Waits for all services to be up and running.
6. Imports necessary datasets and executes SQL scripts automatically.

---

## **2️⃣ Accessing phpMyAdmin**
After running `setup.sh`, you can access phpMyAdmin using:

1. Get Minikube's IP:
```bash
minikube ip
```
2. Open the following URL in your browser:
```
http://<MINIKUBE_IP>:30001
```

### **Login Credentials**
- **Username:** `root`
- **Password:** (stored in Kubernetes Secret, default: `rootpassword`)

---

## **3️⃣ Accessing MongoDB in Minikube**

### **1. Open MongoDB shell**
```bash
kubectl exec -it $(kubectl get pod -l app=mongodb -o jsonpath="{.items[0].metadata.name}") -- mongosh -u mongoadmin -p securepass --authenticationDatabase admin
```

### **2. Verify the imported data**
```javascript
use electronics
db.electronics.find().limit(5).pretty()
```

### **3. Retrieve MongoDB credentials from Kubernetes Secret**
```bash
kubectl get secret mongodb-secret -o jsonpath="{.data.MONGO_ROOT_PASSWORD}" | base64 --decode
```

---

## **4️⃣ Connecting pgAdmin to PostgreSQL in Minikube**

### **1. Retrieve PostgreSQL Service IP**
```bash
kubectl get svc postgres-service
```
📌 **Use the `CLUSTER-IP` instead of a dynamic pod IP for stable connections.**

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

🚀 **Now PostgreSQL is accessible from pgAdmin, and all services are running automatically via `setup.sh`!** 🎯