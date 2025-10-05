terraform {
  backend "s3" {
    bucket         = "cids-terraform-eks"
    key            = "jenkins/terraform.tfstate"
    region         = "us-east-1"
    # BEST PRACTICE: Enable state locking to prevent concurrent updates
    dynamodb_table = "terraform-lock-table" 
    encrypt        = true
  }
}