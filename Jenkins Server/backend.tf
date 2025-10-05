terraform {
  backend "s3" {
    bucket = "cids-terraform-eks"
    key    = "jenkins/terraform.tfstate"
    region = "us-east-1"
  }
}