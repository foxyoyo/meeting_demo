# Bastion EC2 Variables

# AWS EC2 Instance Type
variable "instance_type" {
  description = "EC2 Instance Type"
  type = string
  default = "t3.small"  
}

# AWS EC2 Instance Key Pair
variable "instance_keypair" {
  description = "AWS EC2 Key pair"
  type = string
  default = "terraform-key"
}

# AWS EC2 's instance profile's s3 permission
variable "instance_bastion_s3" {
  description = "For Bastion EC2 Acces which S3"
  type = string
  default = "terraform-proj-aws"
}

# Create eip 
variable "instance_bastion_eip" {
  description = "Enable eip or not"
  type = bool
  default = false
}

# Enable monitor 
variable "instance_bastion_monitor" {
  description = "Enable eip or not"
  type = bool
  default = false
}