# Data source to get your public IP for SSH ingress (security best practice)
data "http" "my_ip" {
  url = "http://ipv4.icanhazip.com"
}

locals {
  # Clean up the IP address fetched by the data source
  my_ip_cidr = format("%s/32", trimspace(data.http.my_ip.response_body))
}

# VPC Module
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "jenkins-vpc"
  cidr = var.vpc_cidr

  # Ensure the number of AZs matches the number of subnets
  azs             = slice(data.aws_availability_zones.azs.names, 0, length(var.public_subnets))
  public_subnets  = var.public_subnets

  public_subnet_tags = { Name = "jenkins-public-subnet" }
  igw_tags           = { Name = "jenkins-igw" }

  enable_dns_hostnames = true
  enable_nat_gateway   = false # We only need public subnets

  tags = {
    Name        = "jenkins-vpc"
    Terraform   = "true"
    Environment = "dev"
  }
}

# Security Group for Jenkins
resource "aws_security_group" "jenkins_sg" {
  name_prefix = "jenkins-sg-"
  description = "Allow SSH and Jenkins access"
  vpc_id      = module.vpc.vpc_id

  # Ingress: Allow SSH (Port 22) ONLY from your current public IP
  ingress {
    description = "SSH access from trusted IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.my_ip_cidr] # Use your current IP
  }

  # Ingress: Allow Jenkins Web UI (Port 8080) from anywhere
  ingress {
    description = "Jenkins HTTP"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress: Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins-sg"
  }
}

# EC2 Instance for Jenkins
resource "aws_instance" "jenkins_server" {
  ami                         = data.aws_ami.example.id
  instance_type               = var.instance_type
  key_name                    = "Project" # CRITICAL: Ensure this key pair exists
  monitoring                  = true
  user_data                   = file("jenkins_user_data.sh")
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]
  associate_public_ip_address = true

  tags = {
    Name        = "jenkins-server"
    Terraform   = "true"
    Environment = "dev"
  }
}