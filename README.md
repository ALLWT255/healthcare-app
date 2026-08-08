# 🏥 Secure Healthcare Application on AWS

A containerized healthcare application and cloud infrastructure project built to demonstrate **secure, scalable, and automated AWS architecture** using Terraform, Docker, Flask, PostgreSQL, and AWS services.

The architecture was designed with **HIPAA-aligned security practices** in mind, including network isolation, encryption, least-privilege access, secrets management, monitoring, and layered application security.

> **Note:** This is an educational portfolio project demonstrating technical controls that can support a HIPAA-aligned architecture. It does not claim full HIPAA compliance, which also requires organizational, administrative, and operational controls.

---

## 🎯 Business Problem

Healthcare applications can process highly sensitive patient information.

The goal of this project was to answer:

**How can a healthcare organization deploy a containerized application in AWS while reducing public exposure, protecting sensitive information, maintaining availability, and managing infrastructure consistently through code?**

Instead of simply deploying an application, the infrastructure was designed around:

- Security
- Availability
- Network isolation
- Encryption
- Least-privilege access
- Monitoring
- Infrastructure automation

---

## 🏗️ Project Architecture
![Healthcare AWS Architecture](images/health-app%20archuitre%20diagram.png)

### Request Flow

```text
User
 ↓
Amazon Route 53
 ↓
AWS WAF
 ↓
HTTPS / AWS Certificate Manager
 ↓
Application Load Balancer
 ↓
Amazon ECS / Fargate
 ↓
Flask REST API
 ↓
Amazon RDS PostgreSQL
```

Application workloads are designed to run inside **private subnets across multiple Availability Zones**, while the Application Load Balancer acts as the controlled public entry point.

Supporting services include:

- Amazon ECR for container images
- AWS Secrets Manager for sensitive configuration
- IAM task and execution roles
- Amazon CloudWatch for monitoring
- NAT Gateway for controlled outbound connectivity
- Multi-AZ VPC networking

---

## 🔐 Security & HIPAA-Aligned Design

### Network Isolation

The VPC separates public-facing infrastructure from private application and database workloads.

ECS workloads and the database are designed to remain within **private subnets**, reducing direct internet exposure.

### AWS WAF

AWS WAF provides an additional security layer in front of the application and is associated with the Application Load Balancer.

AWS managed rules help protect against common malicious web requests.

### Encryption in Transit

AWS Certificate Manager supports **HTTPS/TLS encryption** between users and the application entry point.

### Secrets Management

Sensitive configuration is designed to be stored in **AWS Secrets Manager** instead of being hard-coded into application or Terraform source code.

### Least-Privilege IAM

Separate ECS task and execution roles are used to limit the permissions available to the application and container runtime.

### Monitoring

Amazon CloudWatch provides centralized logging and monitoring to improve visibility into application and infrastructure behavior.

---

## 🐳 Containerized Application

The local application uses Docker Compose with three primary services:

```text
Frontend (NGINX)
      ↓
Flask REST API
      ↓
PostgreSQL
```

The Flask API uses parameterized SQL queries to reduce SQL injection risk and implements soft deletion for patient records.

---

## 🔌 API Endpoints

| Method | Endpoint | Purpose |
|---|---|---|
| GET | `/api/health` | API health check |
| GET | `/api/patients` | Retrieve active patients |
| POST | `/api/patients` | Create patient |
| GET | `/api/patients/<id>` | Retrieve patient |
| PUT | `/api/patients/<id>` | Update patient |
| DELETE | `/api/patients/<id>` | Soft-delete patient |

---

## 🏗️ Infrastructure as Code

Terraform defines the AWS infrastructure, including:

- VPC
- Public and private subnets
- Route tables
- Internet Gateway
- NAT Gateway
- Security groups
- Application Load Balancer
- ECS / Fargate
- Amazon RDS
- Amazon ECR
- IAM roles and policies
- AWS WAF
- AWS Secrets Manager
- Route 53
- ACM
- CloudWatch

Terraform state files, environment files, and local Terraform directories are excluded from source control.

---

## ⚙️ CI/CD

GitHub Actions is included as part of the Infrastructure-as-Code workflow.

The pipeline helps automate validation and provides a foundation for repeatable infrastructure deployment.

---

## 💻 Local Development

Start the application:

```bash
docker compose up -d
```

Check the containers:

```bash
docker compose ps
```

Test the Flask API:

```bash
curl http://localhost:5000/api/health
```

Test database connectivity:

```bash
curl http://localhost:5000/api/patients
```

---

## 🧰 Technology Stack

**Cloud:** AWS

**Infrastructure as Code:** Terraform

**Containers:** Docker, Docker Compose, ECS/Fargate

**Backend:** Python, Flask, REST API

**Frontend:** NGINX

**Database:** PostgreSQL / Amazon RDS

**Security:** AWS WAF, IAM, Secrets Manager, Security Groups, ACM

**Monitoring:** Amazon CloudWatch

**Automation:** GitHub Actions

---

## 📚 What I Learned

One of the biggest lessons from this project was that cloud engineering isn't simply about getting an application running.

Every infrastructure component should solve a requirement involving:

**Security • Availability • Scalability • Reliability • Observability • Automation**

This project strengthened my understanding of the complete request flow from the public edge, through security and load-balancing controls, into private application workloads, and finally into the database layer.

---

## 🔜 What's Next?

The next stage of my portfolio will continue using a **business-problem-first approach**.

Upcoming areas include:

- Secure banking / financial-services architecture
- FedRAMP-oriented cloud security concepts
- Kubernetes container orchestration
- Amazon S3
- Advanced CI/CD
- Observability
- IAM and cloud security automation

The question moving forward isn't simply:

**“What technology can I learn next?”**

It's:

### **“What business problem can I solve with it?”**