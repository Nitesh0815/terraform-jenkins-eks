#!/bin/bash
set -euxo pipefail

# Update system
yum update -y

# 1. Install Java 11 (Jenkins Prerequisite)
# Check if java-11 is already installed
if ! command -v java > /dev/null || ! java -version 2>&1 | grep -q "openjdk version \"11"; then
  echo "Installing OpenJDK 11..."
  amazon-linux-extras install java-openjdk11 -y
fi

# 2. Install Jenkins
echo "Installing Jenkins..."
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum install jenkins -y
systemctl enable jenkins
systemctl start jenkins

# 3. Install kubectl
echo "Installing kubectl..."
K8S_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
curl -LO "https://dl.k8s.io/release/$K8S_VERSION/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# 4. Install Git
echo "Installing Git..."
yum install git -y

# 5. Install Terraform
echo "Installing Terraform..."
yum install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
yum -y install terraform

echo "Jenkins server setup complete."