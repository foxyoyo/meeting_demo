terraform {
  # required_version = ">= 1.4.2"
  required_version = ">= 1.9.0"
    backend "s3" {
    bucket = "fox-terrafrom"
    region = "ap-northeast-2"
    key = "terraform-proj-aws/state"
    profile = "fox-personal"
  }    
  required_providers {
    aws = {
      # version = "~> 4.0"
      version = "~> 5.0"
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = "fox-personal"
  region  = "ap-northeast-2"
}