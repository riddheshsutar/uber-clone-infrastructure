# 🚕 Terraform Infrastructure using AWS & Terraform

> **Fully automated AWS infrastructure setup for Uber-like applications using Terraform Infrastructure as Code (IaC).**

---

## 🏗️ Project Overview

This project provisions a **production-ready**, **highly available**, and **secure AWS infrastructure** for an Uber-like application using **Terraform**.
It automates the setup of **networking, compute, storage, and database layers** — all following AWS best practices.

---

## 🌐 Project Architecture

<img width="1014" height="670" alt="image" src="https://github.com/user-attachments/assets/c1440494-696c-4171-8883-b7a291c537bb" />

**Key AWS Components**

* **VPC:** Custom network with public, private & DB subnets
* **EC2:** Application servers in private subnets
* **ALB:** Distributes incoming traffic
* **RDS:** Multi-AZ MySQL database with read replicas
* **NAT & IGW:** Controlled outbound & inbound access
* **CloudWatch:** Monitoring and alerting
* **VPC Endpoints:** Cost-effective internal AWS access

---

## 🧱 Project Structure

```
uber-clone-infrastructure/
├── main.tf                # Root Terraform configuration
├── provider.tf            # AWS provider setup
├── variables.tf           # Input variables
├── outputs.tf             # Output values
├── terraform.tfvars       # Custom environment values
│
└── modules/               # Reusable Terraform modules
    ├── vpc/               # VPC setup
    ├── subnets/           # Public, private, and DB subnets
    ├── gateways/          # NAT & Internet Gateways
    ├── routing/           # Route tables
    ├── security/          # Security groups
    └── rds/               # RDS database configuration
```

---

## 🧰 Tools & Technologies Used

| Tool           | Purpose                            |
| -------------- | ---------------------------------- |
| **Terraform**  | Infrastructure automation (IaC)    |
| **AWS Cloud**  | Hosting and networking environment |
| **AWS CLI**    | Verifying and managing resources   |
| **CloudWatch** | Monitoring and alarms              |
| **Git/GitHub** | Version control and collaboration  |

---

## 📸 Project Screenshots

| Section                      | Screenshot                                                                                                | Description                                                  |
| ---------------------------- | --------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------ |
| **Infrastructure Dashboard** | <img width="600" src="https://github.com/user-attachments/assets/0058f594-52c5-4d62-a523-a8746dca4cb8" /> | Complete infrastructure deployed across 3 Availability Zones |
| **VPC & Networking**         | <img width="600" src="https://github.com/user-attachments/assets/bed53f7c-f5f1-4f7c-98f1-60effd5d7548" /> | VPC setup with public, private, and database subnets         |
| **Resource Map**             | <img width="400" src="https://github.com/user-attachments/assets/233bb89e-bd57-4733-8764-dfa08c92ef4c" /> | Visual representation of VPC in depth using Resource Map     |
| **RDS Database Setup**       | <img width="600" src="https://github.com/user-attachments/assets/9a7871ab-a536-4bec-bb3c-dadd8c14eadf" /> | MySQL primary instance with 2 read replicas across AZs       |
| **Security Groups**          | <img width="600" src="https://github.com/user-attachments/assets/bde8ee5e-3354-4b59-8af1-cb49ba15b808" /> | Layered network security using NACLs and SGs                 |
| **Terraform Outputs**        | <img width="400" src="https://github.com/user-attachments/assets/b6d670cc-f97a-4c91-ae09-52d0aa830ff4" /> | Terraform output summary after deployment                    |
| **Terraform Outputs**        | <img width="400" src="https://github.com/user-attachments/assets/f0e7fb60-8019-44e9-8513-162d7f23fde5" /> | Outputs showing VPC and RDS details                          |
| **Terraform Outputs**        | <img width="400" src="https://github.com/user-attachments/assets/3df4af56-9b5d-41a9-a1b0-e8582ea9cbdc" /> | Final confirmation of deployed resources                     |
| **CloudWatch Alarms**        | <img width="600" src="https://github.com/user-attachments/assets/4175bf48-f51c-4dda-b7f9-24b09a2fdf5d" /> | Monitoring dashboard showing all alarms in "OK" state        |

---

## ⚙️ Setup & Execution

### 1️⃣ Prerequisites

* Terraform ≥ 1.0
* AWS CLI configured
* Active AWS account
* Git installed

### 2️⃣ Clone Repository

```bash
git clone https://github.com/yourusername/uber-clone-infrastructure.git
cd uber-clone-infrastructure
```

### 3️⃣ Configure AWS

```bash
aws configure
```

### 4️⃣ Initialize Terraform

```bash
terraform init
```

### 5️⃣ Review Plan

```bash
terraform plan -out=tfplan
```

### 6️⃣ Apply Configuration

```bash
terraform apply tfplan
```

### 7️⃣ Verify Outputs

```bash
terraform output
```

---

## 🧩 Key Features

* **Multi-AZ high availability**
* **Modular Terraform design**
* **RDS with replication & backups**
* **CloudWatch monitoring & alarms**
* **Private networking with NAT & IGW**
* **VPC Endpoints for cost savings**
* **Encryption & security groups for isolation**

---

## 💰 Cost Optimization

| Resource      | Optimization                       |
| ------------- | ---------------------------------- |
| NAT Gateway   | Option for single NAT to save cost |
| RDS Size      | Use `t3.micro` for development     |
| VPC Endpoints | Free access to S3/DynamoDB         |
| Tagging       | Enables easy cost tracking         |

---

## 🧹 Cleanup

```bash
# Destroy all resources (use cautiously)
terraform destroy
```

---

## 👨‍💼 Author

**Riddhesh Sutar - AWS & DevOps Enthusiast**

* 🌐 GitHub: [@riddheshsutar](https://github.com/riddheshsutar)
* 💼 LinkedIn: [sutarriddhesh](https://www.linkedin.com/in/sutarriddhesh22/)
* 📧 Email: [riddheshrameshsutar@gmail.com](mailto:riddheshrameshsutar@gmail.com)

---

## ⭐ Support

If you find this project useful, please give it a **⭐ star** on GitHub and share it!

---
