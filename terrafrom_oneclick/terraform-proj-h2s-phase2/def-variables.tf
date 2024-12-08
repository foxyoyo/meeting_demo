# Input Variables
# AWS Region
variable "aws_region" {
  description = "Def Region in which AWS Resources to be created"
  type = string
  default = "ap-northeast-1"
}
# Environment Variable
variable "environment" {
  description = "Env Variable used as a prefix"
  type = string
  default = "DEV"
}
# Business Division
variable "business_divsion" {
  description = "Business Division or Country belongs"
  type = string
  default = "H2S-JP"
}

# Define Local Values in Terraform
locals {
  owners = var.business_divsion
  environment = "${var.business_divsion}-${var.environment}-${var.aws_region}"
  name = "${var.business_divsion}-${var.environment}"
  common_tags = {
    owners = local.owners
    environment = local.environment
  }
} 