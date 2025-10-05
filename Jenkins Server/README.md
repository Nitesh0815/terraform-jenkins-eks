# Terraform-Jenkins-EKS

This project demonstrates deploying a real-time, end-to-end DevOps pipeline using Terraform, Jenkins, and AWS EKS (Elastic Kubernetes Service).

## Features

- **Infrastructure as Code:** Provision AWS resources using Terraform.
- **CI/CD Pipeline:** Automate application build, test, and deployment with Jenkins.
- **Kubernetes Orchestration:** Deploy and manage containerized applications on EKS.

## Prerequisites

- AWS Account
- Terraform installed
- Jenkins installed (locally or on a server)
- AWS CLI configured
- kubectl installed

## Project Structure

```
terraform-jenkins-eks/
├── jenkins/                # Jenkins pipeline scripts and configuration
├── terraform/              # Terraform modules and configuration files
├── manifests/              # Kubernetes manifests for application deployment
└── README.md
```

## Getting Started

1. **Clone the repository:**
    ```bash
    git clone <repository-url>
    cd terraform-jenkins-eks
    ```

2. **Provision AWS Infrastructure:**
    ```bash
    cd terraform
    terraform init
    terraform apply
    ```

3. **Configure Jenkins:**
    - Set up credentials for AWS.
    - Create a pipeline using the provided Jenkinsfile.

4. **Deploy Application:**
    - Jenkins pipeline will build, test, and deploy your application to EKS.

## Useful Commands

- Check EKS cluster:
  ```bash
  aws eks --region <region> update-kubeconfig --name <cluster_name>
  kubectl get nodes
  ```

## License

This project is licensed under the MIT License.

## Author

[Your Name]