provider "aws" {
  region = "us-east-1"
}

# Required for fetching your public IP address
provider "http" {}