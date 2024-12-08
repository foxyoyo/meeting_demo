resource "aws_ssm_parameter" "h2-db-primary" {
  name        = "/terraform/${var.country}/rds/h2/master/address"
  description = "rds entrypoint created by Terraform"
  type        = "String"
  value       = aws_db_instance.shuriken.address
  tags = {
    Name = "SecurityGroup-allow-tw-ip-access-in"
    DashboardName = var.dashboard_name
  }
  depends_on = [
    aws_db_instance.shuriken
  ]
}

resource "aws_ssm_parameter" "au-h2-db-slave" {
  name        = "/terraform/au/rds/h2/slave/address"
  description = "rds entrypoint created by Terraform"
  type        = "String"
  value       = aws_db_instance.shuriken_slave.address
  tags = {
    Name = "SecurityGroup-allow-tw-ip-access-in"
    DashboardName = var.dashboard_name
  }
  depends_on = [
    aws_db_instance.shuriken_slave
  ]
}

resource "aws_ssm_parameter" "h2-db-primary-endpoint" {
  name        = "/terraform/${var.country}/rds/h2/master/entrypoint"
  description = "rds entrypoint created by Terraform"
  type        = "String"
  value       = aws_db_instance.shuriken.endpoint
  tags = {
    Name = "SecurityGroup-allow-tw-ip-access-in"
    DashboardName = var.dashboard_name
  }
  depends_on = [
    aws_db_instance.shuriken
  ]
}

resource "aws_ssm_parameter" "h2-db-slave-endpoint" {
  name        = "/terraform/${var.country}/rds/h2/slave/entrypoint"
  description = "rds entrypoint created by Terraform"
  type        = "String"
  value       = aws_db_instance.shuriken_slave.endpoint
  tags = {
    Name = "SecurityGroup-allow-tw-ip-access-in"
    DashboardName = var.dashboard_name
  }
  depends_on = [
    aws_db_instance.shuriken_slave
  ]
}


resource "aws_security_group" "sg-shuriken" {
  name = "SG-prod-shuriken"

  description = "SG for RDS postgres servers"
  vpc_id = module.vpc.vpc_id
  # vpc_id = data.aws_ssm_parameter.vpc_id.value
  # Only postgres in
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = ["${module.vpc.vpc_cidr_block}"]
  }

  # Allow all outbound traffic.
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "private-subnet-2az" {
  name       = "rds-prod-shuriken-private-subnet"
  subnet_ids =  module.vpc.database_subnets
  tags = {
    Name = "AU-Shuriken DB subnet group"
  }
}

# resource "aws_db_parameter_group" "prod-au-rds-pg-postgres12-debezium" {
#   name   = "my-pg"
#   family = "postgres13"

#   parameter {
#     name  = "log_connections"
#     value = "1"
#   }

#   parameter {
#     name  = "character_set_client"
#     value = "utf8"
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }



resource "aws_db_instance" "shuriken" {
  allocated_storage        = var.allocated_storage
  max_allocated_storage    = var.max_allocated_storage
  storage_encrypted        = true
  storage_type             = var.storage_type
  backup_retention_period  = 14   # in days
  maintenance_window       = "Sun:21:00-Sun:22:00"
  backup_window            = "22:30-23:30"
  multi_az                 = true
  db_subnet_group_name     = aws_db_subnet_group.private-subnet-2az.name  # 
  engine                   = "postgres"
  engine_version           = var.engine_version
  identifier               = "${var.country}-shuriken"  # name of the RDS instance
  instance_class           = var.instance_spec
  parameter_group_name     = var.parameter_group_name
  username                 = var.def_db_username
  password                 = var.def_db_passwd
  port                     = 5432
  # skip_final_snapshot    = true
  publicly_accessible      = false
  vpc_security_group_ids   = [ aws_security_group.sg-shuriken.id ]
  enabled_cloudwatch_logs_exports = ["postgresql"]
  # deletion_protection      = true
  auto_minor_version_upgrade = false
  ca_cert_identifier       = "rds-ca-rsa2048-g1"
  performance_insights_enabled = true
  apply_immediately = false

  tags = {
    DashboardName = "DevOps"
    RegionName = "${var.aws_region}"
  }

}

resource "aws_db_instance" "shuriken_slave" {
  identifier             = "${var.country}-shuriken-slave0"
  replicate_source_db    = aws_db_instance.shuriken.identifier ## refer to the master instance
  multi_az               = false
  # db_subnet_group_name   = aws_db_subnet_group.private-subnet-2az.name #
  storage_type           = var.storage_type
  instance_class         = var.instance_spec
  allocated_storage      = var.allocated_storage
  max_allocated_storage    = var.max_allocated_storage
  storage_encrypted        = true
  skip_final_snapshot    = true
  publicly_accessible    = false
  port                   = 5432
  vpc_security_group_ids = [ aws_security_group.sg-shuriken.id ]
  # option_group_name        = "default.postgres12"
  parameter_group_name     = var.parameter_group_name
  backup_retention_period = 0
# others
  auto_minor_version_upgrade = false
  ca_cert_identifier       = "rds-ca-rsa2048-g1"
  performance_insights_enabled = true
  apply_immediately = false
  tags = {
    DashboardName = "DevOps"
    RegionName = "${var.aws_region}"
  }

}

