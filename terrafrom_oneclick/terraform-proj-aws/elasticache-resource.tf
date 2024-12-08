resource "aws_elasticache_replication_group" "redis_replication_group" {
  replication_group_id = var.escache_cluster_name 
  description = "Redis cluster for ${var.business_divsion} environment"
  node_type            = var.node_type 
  engine_version       = var.engine_version
  port                  = var.redis_port
  auto_minor_version_upgrade = false
  maintenance_window         = var.maintenance_window
  automatic_failover_enabled = true
  multi_az_enabled = true
  parameter_group_name = var.redis_parameter_group 
  subnet_group_name = aws_elasticache_subnet_group.redis_dev_subnet_group.name
  security_group_ids = [ aws_security_group.elasticache_security_group.id ]
  num_cache_clusters  = 2
  
  log_delivery_configuration {
    destination      =  aws_cloudwatch_log_group.redis_logs.name 
    destination_type = "cloudwatch-logs"
    log_format       = "json"
    log_type         = "slow-log"
  }

  tags = {
    Name ="${var.business_divsion}-${var.environment}"
    Service = "${var.environment}-${var.business_divsion}"
    DashboardName = var.dashboard_name
  }

  depends_on = [
    aws_cloudwatch_log_group.redis_logs
  ]
}


resource "aws_elasticache_subnet_group" "redis_dev_subnet_group" {
  name       = "redis-dev-subnet-group"
  subnet_ids = module.vpc.elasticache_subnets
}

resource "aws_security_group" "elasticache_security_group" {
  name = "SG-${var.environment}-${var.business_divsion}"
  vpc_id      = module.vpc.vpc_id
  ingress {
    from_port   = 0 
    to_port     = 0 
    protocol    = -1 
    cidr_blocks = [module.vpc.vpc_cidr_block]
    description = "Allow all traffic from VPC CIDR block"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1 
    self = true
    description = "Allow traffic between resources in the same security group"
  }
  description = "Created by Terraform"
}


resource "aws_cloudwatch_log_group" "redis_logs" {
  name = "/aws/${var.environment}-${var.business_divsion}/${var.escache_cluster_name}"
  retention_in_days = 14
}