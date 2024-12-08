# VPC Variables
vpc_name = "VPC"
vpc_cidr_block = "172.100.0.0/16"
vpc_availability_zones = ["ap-northeast-2a", "ap-northeast-2b"]
vpc_public_subnets = ["172.100.16.0/20", "172.100.32.0/20"]
vpc_private_subnets = ["172.100.48.0/20", "172.100.64.0/20"]
vpc_database_subnets= ["172.100.80.0/20", "172.100.96.0/20"]
vpc_elasticache_subnets= ["172.100.112.0/20", "172.100.128.0/20"]
vpc_create_database_subnet_group = true 
vpc_create_database_subnet_route_table = true
vpc_create_elasticache_subnet_group = true 
vpc_create_elasticache_subnet_route_table = true  
vpc_enable_nat_gateway = true  
vpc_single_nat_gateway = true

# EC2  Variable
instance_type = "t3.micro"
instance_keypair = "terraform-fox"
instance_bastion_s3 = "terraform-proj-aws"
instance_bastion_eip = true
instance_bastion_monitor = false

# EFS
# MountTarget config ref to vpc_availability_zones
efs_name = "h2-server-efs"
efs_perf_mode = "generalPurpose"
efs_throu_mode = "bursting"
efs_encrypted = false

# S3
# s3_bucket_name = ["aws-waf-logs-h2sprod-kr", "h2-lab-prod-kr","h2-prod-kr-a1c-prediction"]
s3_bucket_name = ["s3-fox-terraform1", "s3-fox-terraform2"]
# s3_acl_config  = "private"
s3_object_ownership = "BucketOwnerEnforced"
s3_enable_versioning = true


# SNS 
# topic_lambda_map = {_
#   "h2-p-kr-alarm"    = "lambda_alarm"
#   "iso-27001-alarm" = "lambda_iso"
# }

topic_lambda_map = {
  "h2-p-kr-alarm" = {
    topic_name = "h2-p-kr-alarm"
    python_file = "lambda_alarm.py"
    description = "general sla alarm"
    SLACK_WEBHOOK_CHANNEL = "alarm-sla-critical"
    SLACK_WEBHOOK_ICON = ":firefighter:"
    SLACK_WEBHOOK_URL = "https://hooks.slack.com/services/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"
    SLACK_WEBHOOK_USERNAME = "Mr.Oh~No!"
  }

  "iso-27001" = {
    topic_name = "iso-27001"
    python_file = "lambda_iso.py"
    description = "security issue alarm"
    SLACK_WEBHOOK_CHANNEL = "iso-27001"
    SLACK_WEBHOOK_ICON = ":whale:"
    SLACK_WEBHOOK_URL = "https://hooks.slack.com/services/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"
    SLACK_WEBHOOK_USERNAME = "Mr.Testing!"
  }

}

### ACM Domain Name ###
domain_name = "healthpass.cc"
default_targetgroup = "k8s-kr-prod-h2s-nginx"
# Alb 
alb_name = "alb"

alb_log_s3 = "kr-h2-alb-s3"

### TargetGroup 
target_groups = {
  "k8s-kr-prod-h2s-nginx" = {
    name        = "k8s-kr-prod-h2s-nginx"
    port        = 80
    protocol    = "HTTP"
    target_type = "ip"
    health_check = {
      interval            = 30
      path                = "/favicon.ico"
      port                = "80"
      protocol            = "HTTP"
      healthy_threshold   = 5
      unhealthy_threshold = 2
      timeout             = 5
      matcher             = "200"
    }
    tags = {
      Environment = "prod-kr"
      Service     = "nginx"
    }
  },
  "k8s-kr-prod-admin-api" = {
    name        = "k8s-kr-prod-admin-api"
    port        = 8400
    protocol    = "HTTPS"
    target_type = "ip"
    algorithm = "least_outstanding_requests"
    health_check = {
      interval            = 60
      path                = "/probe/health"
      port                = "443"
      protocol            = "HTTPS"
      healthy_threshold   = 3
      unhealthy_threshold = 2
      timeout             = 40
    }
    tags = {
      Environment = "prod-kr"
      Service     = "admin-api"
    }
  },
  "k8s-kr-prod-h2s-apisvc" = {
    name        = "k8s-kr-prod-h2s-apisvc"
    port        = 8100
    protocol    = "HTTPS"
    target_type = "ip"
    algorithm = "least_outstanding_requests"
    health_check = {
      interval            = 60
      path                = "/probe/health"
      port                = "443"
      protocol            = "HTTPS"
      healthy_threshold   = 2
      # unhealthy_threshold = 3
      timeout             = 30
    }
    tags = {
      Environment = "prod-kr"
      Service     = "h2-api"
    }
  }
}

### Alb Rules

alb_rules = {
  100 = {
    name = "k8s-kr-prod-h2s-nginx"
    type = "forward"
    path_condition= {
      path_pattern = [
        "/wellness/signout",
        "/wellness/*_signin",
        "/wellness/redirect*",
        "/wellness/*report*"
      ]
    }
  },
  90 = {
    name = "k8s-kr-prod-admin-api"
    type = "forward"
    path_condition= {
      path_pattern = [
        "/webview*",
        "/apps*",
        "/collaboration*",
        "/sms*",
        "/social_connect/fitbit"
      ]
    }
  },
  80 = {
    name = "k8s-kr-prod-h2s-apisvc"
    type = "forward"
    path_condition= {
      path_pattern = [
        "/libreview_connect/callback",
        "/fitbit_connect/callback",
        "/peer/*"
      ]
    }
  },
}