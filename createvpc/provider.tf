provider "aws" {
  region      = var.region
}

terraform {
  required_providers {
    awsutils = {
      source  = "cloudposse/awsutils"
      version = "0.11.1"
    }
  }
}

# Configure the AWS Provider
provider "awsutils" {
  region = var.region
}