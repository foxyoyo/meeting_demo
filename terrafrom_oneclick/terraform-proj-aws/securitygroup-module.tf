module "public_bastion_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.2.0"

  name = "${local.name}-public-bastion-sg"
  description = "Security Group for Bastion"
  vpc_id = module.vpc.vpc_id
  # Ingress Rules & CIDR Blocks
  # ingress_rules = ["ssh-tcp"]
  # ingress_cidr_blocks = ["0.0.0.0/0"]

  # Open to CIDRs blocks (rule or from_port+to_port+protocol+description)
  ingress_with_cidr_blocks = [
    {
      from_port   = 8
      to_port     = 0
      protocol    = "icmp"
      description = "icmp ping"
      cidr_blocks = "54.238.8.72/32,203.74.120.191/32"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "ssh"
      cidr_blocks = "54.238.8.72/32,52.193.214.156/32,18.136.2.186/32,18.138.8.45/32,203.74.120.191/32"
    },
  ]

  # Only ip v4 allow outbound
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow all outbound IPv4 traffic"
    }
  ]

  # Egress Rule - all-all open (ipv4 and ipv6)
  # egress_rules = ["all-all"]

  tags = local.common_tags

}