terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.86.0"
    }
  }
  backend "s3" {
    bucket         = "daws25s-vpc-s3"        # S3 bucket name
    key            = "expense-infra-dev-vpc" # Path/name for the state file
    region         = "us-east-1"             # AWS region for the S3 bucket
    dynamodb_table = "expense-vpc"           # DynamoDB table for state locking
  }
}
#provide authentication here:
provider "aws" {
  region = "us-east-1"
}