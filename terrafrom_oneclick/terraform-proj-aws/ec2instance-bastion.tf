module "ec2_public" {
  
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.7.1"

  # for_each = toset(["0"]) # Bastion instance count set in here
  # name                   = "${var.environment}-BastionHost-${each.key}"
  name                   = "${var.environment}-BastionHost"
  ami                    = data.aws_ami.ubuntu.id

  create_iam_instance_profile = true
  iam_role_description        = "IAM role for Bastion EC2"
  iam_role_policies = {
    # AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
    Bation-iampolicy = module.iam_policy_from_data_source.arn
  }

  create_eip             = true
  instance_type          = var.instance_type
  key_name               = var.instance_keypair
  monitoring             = var.instance_bastion_monitor
  subnet_id              = element(module.vpc.public_subnets, 0)

  vpc_security_group_ids = [module.public_bastion_sg.security_group_id]

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 10
    },
  ]

  tags = local.common_tags

}