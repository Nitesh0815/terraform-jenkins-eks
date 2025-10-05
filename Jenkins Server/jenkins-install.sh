#!/bin/bash

# Update system
sudo yum update -y

# Install Java 17 for modern Jenkins support
sudo amazon-linux-extras install java-openjdk17 -y

# Install Jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Install Git
sudo yum install git -y

# Install Terraform (using current HashiCorp repo config)
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform

# Install kubectl (dynamically fetching a recent stable version, matching or newer than EKS 1.28)
KUBECTL_VERSION="v1.28.0"
sudo curl -LO "https://dl.k8s.io/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

# Verify installations
echo "--- Installation Complete ---"
java -version
terraform -v
kubectl version --client