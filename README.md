# Terraform-Jenkins-EKS

This project demonstrates how to deploy a production-ready Amazon EKS (Elastic Kubernetes Service) cluster using Terraform, with CI/CD automation via Jenkins.

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Setup Instructions](#setup-instructions)
- [Usage](#usage)
- [Directory Structure](#directory-structure)
- [Contributing](#contributing)
- [License](#license)

## Overview

This repository contains Terraform code to provision AWS infrastructure for an EKS cluster and Jenkins pipelines for automated deployments. It is designed for real-time, end-to-end DevOps workflows.

## Architecture

- **Terraform** provisions AWS resources (VPC, EKS, IAM, etc.)
- **Jenkins** automates CI/CD pipelines for application deployment to EKS

### High-Level Architecture Diagram

```
+-------------------+        +-------------------+        +-------------------+
|                   |        |                   |        |                   |
|    Developer      +------->+     Jenkins       +------->+      EKS Cluster  |
|                   |  CI/CD |                   | Deploy |                   |
+-------------------+        +-------------------+        +-------------------+
         |                                                        |
         |                                                        |
         v                                                        v
   Source Code Repo                                         AWS Infrastructure
      (GitHub)                                               (Provisioned by
                                                              Terraform)
```

## Prerequisites

- AWS account with necessary permissions
- Terraform installed (>= 1.0.0)
- kubectl installed
- Jenkins server (local or cloud)
- AWS CLI configured

## Setup Instructions

1. **Clone the repository**
```bash
git clone https://github.com/Nitesh0815/terraform-jenkins-eks.git
cd terraform-jenkins-eks
```

2. **Initialize Terraform**
```bash
terraform init
```

3. **Apply Terraform configuration**
```bash
terraform apply
```

4. **Configure kubectl**
```bash
aws eks --region <region> update-kubeconfig --name <cluster_name>
```

5. **Set up Jenkins pipelines**

   Import the provided `Jenkinsfile` or configure your own pipeline in Jenkins.

## Usage

- Modify Terraform variables as needed in `variables.tf`
- Use Jenkins to trigger deployments to EKS

## Directory Structure

```
terraform-jenkins-eks/
├── jenkins/
│   └── Jenkinsfile
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
└── README.md
```

## Contributing

Contributions are welcome! Please open issues or submit pull requests.

## License

This project is licensed under the MIT License.

