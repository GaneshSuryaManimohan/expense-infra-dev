terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.48.0"
    }
  }
  backend "s3" {
    bucket = "daws25s-vpc-s3"
    key    = "expense-dev-bastion"
    region = "us-east-1"
    dynamodb_table = "expense-vpc"
  }
}

#provide authentication here
provider "aws" {
  region = "us-east-1"
}