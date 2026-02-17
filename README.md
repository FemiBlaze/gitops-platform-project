# GitOps Platform Project

---

## Overview

This project demonstrates a production-style GitOps-driven Kubernetes platform built on AWS.

It provisions cloud infrastructure using Terraform, deploys a containerized application to Amazon EKS, and manages workloads using Argo CD with automated synchronization from Git.

The platform is fully reproducible — infrastructure, cluster, workloads, and cost governance are all defined as code.

---

## What This Project Demonstrates

* Infrastructure as Code using Terraform
* Remote state management with S3 + DynamoDB locking
* Managed Kubernetes cluster using Amazon EKS
* CI automation with GitHub Actions
* Container image build & push workflow
* GitOps-based deployment using Argo CD
* Self-healing Kubernetes workloads
* Cloud cost governance using AWS Budgets
* Full platform teardown and rebuild validation

This project was intentionally destroyed and rebuilt to validate reproducibility.

---

## Architecture

The system is layered into infrastructure, CI, GitOps, and runtime components.

### High-level flow:

1. Developer pushes code to GitHub.
2. GitHub Actions builds Docker image and pushes to Docker Hub.
3. Terraform provisions AWS infrastructure (VPC, IAM, EKS).
4. Argo CD monitors Git repository for Kubernetes manifests.
5. Argo CD syncs application manifests into the EKS cluster.
6. Kubernetes runs the application pods.
7. AWS Budget monitors cloud spend and sends alerts.

All components are declaratively managed.

---

## Tools & Technologies Used

| Tool                | Purpose                        |
| ------------------- | ------------------------------ |
| Terraform           | Infrastructure provisioning    |
| AWS (EKS, VPC, IAM) | Cloud infrastructure           |
| S3                  | Remote Terraform state storage |
| DynamoDB            | Terraform state locking        |
| GitHub Actions      | CI automation                  |
| Docker              | Containerization               |
| Docker Hub          | Container registry             |
| Kubernetes          | Container orchestration        |
| Argo CD             | GitOps synchronization         |
| AWS Budgets         | Cost governance                |

---

## Project Structure

```text
gitops-platform-project/
├── app/                    # Application source code
│   ├── src/
│   ├── Dockerfile
│   ├── package.json
│   └── README.md
│
├── terraform/              # AWS infrastructure
│   ├── backend.tf
│   ├── providers.tf
│   ├── networking.tf
│   ├── eks.tf
│   ├── iam.tf
│   ├── budgets.tf
│   └── outputs.tf
│
├── k8s/                    # Kubernetes + GitOps
│   ├── base/
│   │   ├── namespace.yml
│   │   ├── deployment.yml
│   │   └── service.yml
│   └── argocd-app.yml
│
├── .github/workflows/
│   ├── terraform.yml       # Infra automation
│   └── app-ci.yml          # Docker build & push
│
└── README.md
```

---

## How the Automation Works

### 1. Infrastructure Automation

* Terraform uses a remote backend (S3 + DynamoDB).
* `terraform plan` validates infrastructure changes.
* `terraform apply` provisions AWS resources.
* Provider version is pinned to avoid schema drift.

---

### 2. CI Automation (GitHub Actions)

App CI:

* Triggered on changes to `app/**`
* Builds Docker image
* Pushes image with `latest` and commit SHA tags

Terraform CI:

* Triggered on changes to `terraform/**`
* Runs:

  * terraform init
  * terraform fmt
  * terraform validate
  * terraform plan

---

### 3. GitOps Workflow (Argo CD)

* Argo CD watches the repository path `k8s/base`.
* Auto-sync enabled.
* Self-heal enabled.
* Prune enabled.

If a Kubernetes resource is deleted manually, Argo CD restores it automatically.

This eliminates manual `kubectl apply` workflows.

---

## How to Run the Project

### 1. Bootstrap Backend (One-Time)

Create:

* S3 bucket (with versioning)
* DynamoDB lock table

Update backend configuration in `backend.tf`.

---

### 2. Initialize Terraform

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

---

### 3. Configure kubectl

```bash
aws eks update-kubeconfig --region us-east-1 --name gitops-cluster
kubectl get nodes
```

---

### 4. Install Argo CD

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Apply GitOps application:

```bash
kubectl apply -f k8s/argocd-app.yml
```

---

### 5. Access Argo CD UI

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Open:

```
https://localhost:8080
```

---

## Screenshots

Add the following screenshots:

* Terraform apply success output
* GitHub Actions successful pipeline runs
* Argo CD “Synced” and “Healthy” status
* Application topology view
* AWS Budget dashboard

These visually validate the platform.

---

## Cleanup (IMPORTANT)

To prevent unnecessary cloud costs:

```bash
terraform destroy
```

If state corruption occurs:

* Manually delete EKS cluster
* Delete IAM roles
* Verify no EC2 instances remain
* Confirm no NAT Gateway exists

Always confirm in AWS Console that no billable resources remain.

---

## Conclusion

This project demonstrates how to:

* Design reproducible cloud infrastructure
* Implement GitOps-based Kubernetes deployment
* Integrate CI pipelines with container workflows
* Enforce infrastructure safety through remote state locking
* Apply cost governance in cloud engineering

It bridges foundational DevOps knowledge with platform-level engineering practices.

The entire system can be destroyed and restored from source code — validating true infrastructure reproducibility.
