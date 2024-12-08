terraform {
  # required_version = ">= 1.4.2"
  required_version = ">= 1.9.0"
    backend "s3" {
    bucket = "h2s-terraform-ap-southeast-2"
    region = "ap-southeast-2"
    key = "terraform/foxtest/acm/state"
    profile = "h2s-pro"
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
  profile = "h2s-pro"
  region  = "ap-northeast-2"
}