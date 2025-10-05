terraform {
  backend "s3" {
    bucket = "cids-terraform-eks"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}