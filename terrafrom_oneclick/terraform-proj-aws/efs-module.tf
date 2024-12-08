# data "aws_availability_zones" "available" {
#   all_availability_zones = true

#   filter {
#     name   = "opt-in-status"
#     # values = ["not-opted-in", "opted-in"]
#     values = ["opted-in"]
#   }
# }

locals {
  # azs = slice(data.aws_availability_zones.available.names, 0, 3)
  # azs = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  azs = var.vpc_availability_zones
}

module "efs" {
  source  = "terraform-aws-modules/efs/aws"
  version = "1.6.4"
  for_each = toset(var.efs_name)
  name = "${each.key}"
  # name           = var.efs_name
  performance_mode = var.efs_perf_mode
  throughput_mode  = var.efs_throu_mode
  encrypted      = var.efs_encrypted

  # Mount targets 
  mount_targets  = { for k, v in zipmap(local.azs, module.vpc.private_subnets) : k => { subnet_id = v } }
  security_group_description = "EFS security group"
  security_group_vpc_id      = module.vpc.vpc_id
  security_group_rules = {
    vpc = {
      # relying on the defaults provdied for EFS/NFS (2049/TCP + ingress)
      description = "NFS ingress from VPC private subnets"
      # cidr_blocks = ["10.99.3.0/24", "10.99.4.0/24", "10.99.5.0/24"]
      cidr_blocks = module.vpc.private_subnets_cidr_blocks
    }
  }

}