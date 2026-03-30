🟣Architecture
<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/8dcdcbb6-ea13-40b1-8473-b5cc0933400c" />



📌 Corelia Microservices Deployment 


🟦 Overview

Corelia is a microservices-based web application deployed on AWS using a fully automated CI/CD pipeline.
The solution is designed to be:
Scalable
Secure
Cost-optimized
Automatically deployed
Managed entirely using Infrastructure as Code (Terraform)

This document explains the full architecture, infrastructure design, deployment steps, and CI/CD automation.



🟩 Architecture Overview

Components:
API Load Balancer (ALB)
ECS Fargate Cluster running 3 microservices:
-User Service
-Order Service
-Payment Service
Elastic Container Registry (ECR) for storing Docker images
Amazon RDS (MySQL) in Private Subnets
VPC with Public & Private Subnets
Security Groups
GitHub Actions CI/CD pipeline
Terraform IaC for provisioning all AWS resources



🟨 Microservices

Each service is containerized using Docker:
services/
    user-services/
    order-services/
    payment-services/

Each service includes:
Node.js application
Dockerfile
Exposed application port (3000)



🟥 Infrastructure as Code (Terraform)

Terraform provisions:
VPC (CIDR + Subnets)
Internet Gateway / NAT Gateway
Route Tables
ECS Cluster
ECR Repositories
Task Definitions
ALB, Listener, Target Groups
RDS MySQL
IAM Roles
Security Groups
Auto-scaling configuration

Commands used:
terraform init
terraform plan
terraform apply -auto-approve



🟪 CI/CD Pipeline (GitHub Actions)

Pipeline steps:
Checkout the repository
Configure AWS credentials
Login to ECR
Build Docker images for 3 microservices
Push images to ECR
Install Terraform
Run terraform init
Run terraform apply
ECS automatically updates the running tasks
Workflow File:
.github/workflows/deploy.yml



🟧 Cost Optimization Features

Fargate instead of EC2 (no servers to manage)
RDS in a small instance class
Only 1 NAT Gateway
Load Balancer shared across services using listener rules
Auto-scaling depending on usage
Pay-as-you-go model
No unused infrastructure
Images stored in ECR (cheaper than S3 for containers)



🟫 How to Deploy the Project

1. Clone Repository
git clone <https://github.com/reem-elmezain/corelia-project>
2. Push to Main Branch
Every push triggers CI/CD automatically.
3. GitHub Actions Does:
Build
Push
Provision infra
Deploy microservices

No manual steps required.



🔵 Outputs

After deployment:
ALB DNS → exposed as application entrypoint
All services accessible through routing rules:
/user
/order
/payment



🟣 Conclusion

This project provides:
Fully automated deployments
Secure & scalable microservices foundation
Cost-optimized AWS architecture
Easy updates via CI/CD
Infrastructure managed entirely as code
