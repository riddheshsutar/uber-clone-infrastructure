# 🚕 Uber Clone Infrastructure - AWS Terraform IaC
> **Production-ready, highly-available AWS infrastructure automation for Uber-like applications using Terraform Infrastructure as Code (IaC)**

This project demonstrates **enterprise-grade infrastructure design** with multi-AZ deployment, automatic failover, and security best practices.

---

## 📸 Project Screenshots

### Infrastructure Dashboard

<img width="1637" height="729" alt="Screenshot 2025-10-18 204222" src="https://github.com/user-attachments/assets/0058f594-52c5-4d62-a523-a8746dca4cb8" />
*Complete infrastructure deployed across 3 availability zones*

### VPC & Networking

<img width="1919" height="778" alt="Screenshot 2025-10-18 204441" src="https://github.com/user-attachments/assets/bed53f7c-f5f1-4f7c-98f1-60effd5d7548" />
*VPC with public, private, and database subnets*

<img width="873" height="578" alt="Screenshot 2025-10-18 205045" src="https://github.com/user-attachments/assets/233bb89e-bd57-4733-8764-dfa08c92ef4c" />
*Resource Map View*

### RDS Database Setup

<img width="1919" height="667" alt="Screenshot 2025-10-18 204600" src="https://github.com/user-attachments/assets/9a7871ab-a536-4bec-bb3c-dadd8c14eadf" />
*MySQL primary with 2 read replicas across AZs*

### Security Groups

<img width="1919" height="723" alt="Screenshot 2025-10-18 204803" src="https://github.com/user-attachments/assets/bde8ee5e-3354-4b59-8af1-cb49ba15b808" />
*Layered security with NACLs and security groups*

### Terraform Outputs 

<img width="962" height="754" alt="Screenshot 2025-10-18 205728" src="https://github.com/user-attachments/assets/b6d670cc-f97a-4c91-ae09-52d0aa830ff4" />
<img width="960" height="784" alt="Screenshot 2025-10-18 205756" src="https://github.com/user-attachments/assets/f0e7fb60-8019-44e9-8513-162d7f23fde5" />
<img width="966" height="903" alt="Screenshot 2025-10-18 205818" src="https://github.com/user-attachments/assets/3df4af56-9b5d-41a9-a1b0-e8582ea9cbdc" />
*Successful deployment of all resources*

### CloudWatch Alarms

<img width="1919" height="762" alt="Screenshot 2025-10-18 213236" src="https://github.com/user-attachments/assets/4175bf48-f51c-4dda-b7f9-24b09a2fdf5d" />
*Alarms State with "OK"*

---

## 🏗️ Architecture Overview

### System Design Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        AWS Cloud (us-east-1)                   │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ VPC (10.0.0.0/16)                                        │  │
│  │                                                          │  │
│  │  ┌─────────────────────────────────────────────────┐   │  │
│  │  │ INTERNET                                        │   │  │
│  │  │   ↓                                             │   │  │
│  │  │ [Internet Gateway]                             │   │  │
│  │  │   ↓                                             │   │  │
│  │  │ [Public Route Table: 0.0.0.0/0 → IGW]        │   │  │
│  │  └────────────────────┬────────────────────────────┘   │  │
│  │                       ↓                                 │  │
│  │  ┌──────────────────────────────────────────────────┐  │  │
│  │  │ PUBLIC SUBNETS (3x AZ)                           │  │  │
│  │  │                                                  │  │  │
│  │  │ AZ-1              AZ-2              AZ-3        │  │  │
│  │  │ ┌────────────┐   ┌────────────┐   ┌────────────┐│  │  │
│  │  │ │ Load       │   │ NAT GW-1   │   │ NAT GW-2   ││  │  │
│  │  │ │ Balancer   │   │ (EIP)      │   │ (EIP)      ││  │  │
│  │  │ │ SG: 80,443 │   │            │   │            ││  │  │
│  │  │ └────────────┘   └────────────┘   └────────────┘│  │  │
│  │  └──────────────────────────────────────────────────┘  │  │
│  │                       ↓                                 │  │
│  │  ┌──────────────────────────────────────────────────┐  │  │
│  │  │ PRIVATE ROUTE TABLE: 0.0.0.0/0 → NAT           │  │  │
│  │  └────────────────────┬─────────────────────────────┘  │  │
│  │                       ↓                                 │  │
│  │  ┌──────────────────────────────────────────────────┐  │  │
│  │  │ PRIVATE SUBNETS (3x AZ) - Application Tier     │  │  │
│  │  │                                                  │  │  │
│  │  │ AZ-1              AZ-2              AZ-3        │  │  │
│  │  │ ┌────────────┐   ┌────────────┐   ┌────────────┐│  │  │
│  │  │ │ App Server │   │ App Server │   │ App Server ││  │  │
│  │  │ │ SG: 8080   │   │ SG: 8080   │   │ SG: 8080   ││  │  │
│  │  │ └────────────┘   └────────────┘   └────────────┘│  │  │
│  │  │        ↓                ↓               ↓        │  │  │
│  │  │ ┌────────────┐   ┌────────────┐   ┌────────────┐│  │  │
│  │  │ │   Cache    │   │   Cache    │   │   Cache    ││  │  │
│  │  │ │  Redis SG: │   │  Redis SG: │   │  Redis SG: ││  │  │
│  │  │ │    6379    │   │    6379    │   │    6379    ││  │  │
│  │  │ └────────────┘   └────────────┘   └────────────┘│  │  │
│  │  └──────────────────────────────────────────────────┘  │  │
│  │                       ↓                                 │  │
│  │  ┌──────────────────────────────────────────────────┐  │  │
│  │  │ DATABASE ROUTE TABLE: Internal Only             │  │  │
│  │  └────────────────────┬─────────────────────────────┘  │  │
│  │                       ↓                                 │  │
│  │  ┌──────────────────────────────────────────────────┐  │  │
│  │  │ DATABASE SUBNETS (3x AZ) - Database Tier        │  │  │
│  │  │                                                  │  │  │
│  │  │ AZ-1              AZ-2              AZ-3        │  │  │
│  │  │ ┌────────────┐   ┌────────────┐   ┌────────────┐│  │  │
│  │  │ │ RDS Primary│   │   RDS Read │   │   RDS Read ││  │  │
│  │  │ │ MySQL 8.0  │   │  Replica   │   │  Replica   ││  │  │
│  │  │ │ Multi-AZ   │   │   MySQL    │   │   MySQL    ││  │  │
│  │  │ │ SG: 3306   │   │  SG: 3306  │   │  SG: 3306  ││  │  │
│  │  │ └────────────┘   └────────────┘   └────────────┘│  │  │
│  │  │                                                  │  │  │
│  │  │ Backup: 7-day retention                         │  │  │
│  │  │ Monitoring: CloudWatch + Performance Insights   │  │  │
│  │  │ Encryption: Enabled at rest                     │  │  │
│  │  └──────────────────────────────────────────────────┘  │  │
│  │                                                          │  │
│  │  VPC Endpoints:                                         │  │
│  │  ✓ S3 Gateway (Cost: Free)                             │  │
│  │  ✓ DynamoDB Gateway (Cost: Free)                       │  │
│  │                                                          │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                 │
│  SECURITY LAYERS:                                             │
│  1. Network ACLs (Stateless) - CIDR-based filtering           │
│  2. Security Groups (Stateful) - Instance-level control       │
│  3. VPC Flow Logs - Network monitoring                        │
│  4. Encryption - In-transit & At-rest                         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## ✨ Key Features

### 🏗️ High Availability
- **Multi-AZ Deployment** across 3 availability zones
- **RDS Multi-AZ** with automatic failover
- **2 Read Replicas** for geographic distribution
- **3 NAT Gateways** (one per AZ) for network redundancy
- **Automatic Backups** with 7-day retention

### 🔒 Security Best Practices
- **Multi-layered Security**: NACLs + Security Groups + Encryption
- **Principle of Least Privilege**: Restrictive ingress/egress rules
- **Network Isolation**: Private subnets unreachable from internet
- **Encryption at Rest**: RDS storage encryption enabled
- **VPC Flow Logs**: Network traffic monitoring
- **CloudWatch Alarms**: CPU, connections, storage, replication lag

### 📈 Scalability
- **Modular Design**: Easy to add resources
- **Auto-scaling Ready**: Supports elastic load balancing
- **Read Replica Scaling**: Distribute read queries
- **VPC Endpoints**: Cost-optimized AWS service access

### 💰 Cost Optimization
- **VPC Endpoints**: Free gateway endpoints for S3/DynamoDB
- **Right-sizing**: t3.micro instances for development
- **Single NAT Option**: Can be configured for cost savings
- **Resource Tagging**: Easy cost allocation

### 🚀 Production Ready
- **Infrastructure as Code**: Version-controlled, reproducible
- **Modular Modules**: VPC, Subnets, Gateways, Routing, Security, RDS
- **Comprehensive Documentation**: Comments and README files
- **Monitoring & Alerts**: CloudWatch integration

---

## 📊 Infrastructure Statistics

| Component | Count | Details |
|-----------|-------|---------|
| VPCs | 1 | 10.0.0.0/16 CIDR |
| Availability Zones | 3 | us-east-1a, us-east-1b, us-east-1c |
| Subnets | 9 | 3 Public, 3 Private, 3 Database |
| Internet Gateways | 1 | - |
| NAT Gateways | 3 | One per AZ |
| Elastic IPs | 3 | For NAT Gateways |
| Route Tables | 3+ | Public, Private, Database |
| Network ACLs | 3 | Public, Private, Database |
| Security Groups | 5 | ALB, App, Cache, DB, Internal |
| RDS Instances | 3 | 1 Primary + 2 Read Replicas |
| CloudWatch Alarms | 4 | CPU, Connections, Storage, Replication |
| VPC Endpoints | 2 | S3, DynamoDB |

---

## 🚀 Quick Start

### Prerequisites

- **Terraform** >= 1.0 ([Install](https://www.terraform.io/downloads))
- **AWS CLI** >= 2.0 ([Install](https://aws.amazon.com/cli/))
- **AWS Account** with appropriate permissions
- **Git** for version control

### 1️⃣ Clone the Repository

```bash
# Clone the project
git clone https://github.com/yourusername/uber-clone-infrastructure.git
cd uber-clone-infrastructure

# List all files
ls -la

# Navigate to project root
pwd
```

### 2️⃣ Configure AWS Credentials

```bash
# Configure AWS CLI with your credentials
aws configure

# When prompted, enter:
# AWS Access Key ID: [your-access-key]
# AWS Secret Access Key: [your-secret-key]
# Default region: us-east-1
# Default output format: json

# Verify credentials
aws sts get-caller-identity

# Expected output:
# {
#     "UserId": "...",
#     "Account": "123456789012",
#     "Arn": "arn:aws:iam::123456789012:user/your-user"
# }
```

### 3️⃣ Initialize Terraform

```bash
# Initialize Terraform (downloads providers)
terraform init

# Expected output:
# Terraform has been successfully initialized!
```

### 4️⃣ Configure Variables

```bash
# Edit terraform.tfvars with your values
cat terraform.tfvars

# Update database password and other sensitive values
# ⚠️ IMPORTANT: Use strong, unique password!
```

### 5️⃣ Review Infrastructure Plan

```bash
# Create and review deployment plan
terraform plan -out=tfplan

# Expected: Shows ~50-60 resources to be created
```

### 6️⃣ Deploy Infrastructure

```bash
# Deploy all resources to AWS
terraform apply tfplan

# ⏱️ Expected time: 10-15 minutes
# (Most time spent waiting for RDS creation)

# After completion, you'll see:
# Apply complete! Resources: X added, 0 changed, 0 destroyed.
```

### 7️⃣ Verify Deployment

```bash
# Get all outputs
terraform output

# Get specific information
terraform output vpc_id
terraform output rds_summary
terraform output security_groups_summary

# Verify in AWS Console
# Visit: https://console.aws.amazon.com/
```

---

## 📋 Project Structure

```
uber-clone-infrastructure/
├── provider.tf                 # AWS provider configuration
├── main.tf                     # Root module orchestration
├── variables.tf                # Input variable definitions
├── terraform.tfvars            # Variable values (customize this)
├── outputs.tf                  # Output definitions
├── .gitignore                  # Git ignore configuration
├── README.md                   # This file
├── LICENSE                     # MIT License
│
└── modules/                    # Terraform modules (reusable)
    ├── vpc/                    # VPC & Networking
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── subnets/                # Subnets & NACLs
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── gateways/               # IGW & NAT Gateways
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── routing/                # Route Tables
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── security/               # Security Groups
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── rds/                    # RDS Database
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

---

## 🔧 Customization

### Change AWS Region

```hcl
# In terraform.tfvars
aws_region = "ap-south-1"  # Change to desired region
```

### Adjust Resource Sizing

```hcl
# In terraform.tfvars
db_instance_class = "db.t3.small"      # Upgrade from db.t3.micro
allocated_storage = 50                 # Increase storage from 20GB
db_backup_retention = 30               # Increase retention from 7 days
```

### Cost Optimization (Single NAT)

```hcl
# In terraform.tfvars
single_nat_gateway = true    # Use 1 NAT instead of 3 (save ~$21/month)
```

### Environment-Specific Config

```bash
# Create environment-specific tfvars
cp terraform.tfvars terraform.prod.tfvars

# Deploy to production
terraform apply -var-file="terraform.prod.tfvars"
```

---

## 🔍 Verification Commands

### Check Infrastructure Health

```bash
# Get all outputs
terraform output

# Verify VPC
aws ec2 describe-vpcs \
  --filters "Name=cidr,Values=10.0.0.0/16" \
  --region ap-south-1

# Check subnets
aws ec2 describe-subnets \
  --filters "Name=vpc-id,Values=$(terraform output -raw vpc_id)" \
  --region ap-south-1

# Verify RDS instance
aws rds describe-db-instances \
  --db-instance-identifier uber-clone-primary-dev \
  --region ap-south-1

# Check security groups
aws ec2 describe-security-groups \
  --filters "Name=vpc-id,Values=$(terraform output -raw vpc_id)" \
  --region ap-south-1
```

### Database Connection Test

```bash
# Get database endpoint
DB_ENDPOINT=$(terraform output -raw primary_db_address)
echo "Database: $DB_ENDPOINT"

# Connect to database (requires MySQL client)
mysql -h $DB_ENDPOINT -u admin -p -D uberdb -e "SELECT 1;"
```

---

## 📊 Cost Estimation

### Monthly Breakdown (Approximate)

| Component | Cost |
|-----------|------|
| NAT Gateways (3x) | $32.40 |
| Data Transfer | $5-15 |
| RDS Instances (3x) | $75 |
| RDS Storage (60GB) | $14.40 |
| Backup Storage | $10 |
| CloudWatch Logs | $0.50-2 |
| **TOTAL** | **~$137-149/month** |

**Save ~$21/month**: Use single NAT gateway (`single_nat_gateway = true`)

---

## 🛠️ Common Operations

### Update Infrastructure

```bash
# Plan changes
terraform plan -out=tfplan

# Apply changes
terraform apply tfplan

# Destroy specific resource
terraform destroy -target=module.rds.aws_db_instance.primary
```

### Backup & Recovery

```bash
# Backup Terraform state
terraform state pull > terraform.state.backup

# List resources
terraform state list

# Show resource details
terraform state show module.rds.aws_db_instance.primary
```

### Scaling Database

```bash
# Change RDS instance size
terraform apply -var="db_instance_class=db.t3.small"

# Increase storage
terraform apply -var="db_storage=50"
```

---

## 🗑️ Cleanup

### Destroy All Resources

```bash
# ⚠️ WARNING: This will delete all AWS resources!

# Backup state before destroying
terraform state pull > terraform.state.final.backup

# Destroy all resources
terraform destroy

# Confirm by typing: yes
```

### Partial Cleanup

```bash
# Destroy only RDS
terraform destroy -target=module.rds

# Destroy only security groups
terraform destroy -target=module.security
```

---

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📝 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file for details.

---

## 👨‍💼 Author

**Riddhesh Sutar - AWS Fresher**
- GitHub: [@riddheshsutar](https://github.com/riddheshsutar)
- LinkedIn: [sutarriddhesh](https://www.linkedin.com/in/sutarriddhesh22/)
- Email: riddheshrameshsutar@gmail.com

---

## 🙏 Acknowledgments

- [Terraform Documentation](https://www.terraform.io/docs)
- [AWS Best Practices](https://docs.aws.amazon.com/prescriptive-guidance/)
- [Cloud Architecture Best Practices](https://aws.amazon.com/architecture/)

---

## ⭐ Show Your Support

If you found this project helpful, please give it a ⭐ star!

---

## 📞 Support

For issues, questions, or suggestions:
- Open an [Issue](https://github.com/yourusername/uber-clone-infrastructure/issues)
- Start a [Discussion](https://github.com/yourusername/uber-clone-infrastructure/discussions)
- Email: riddheshrameshsutar@gmail.com

---

**Happy Deploying! 🚀**
