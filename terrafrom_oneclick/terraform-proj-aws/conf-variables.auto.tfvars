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
# efs_name = "xxxx-server-efs"
efs_name = ["xxxx-server-efs"]
efs_perf_mode = "generalPurpose"
efs_throu_mode = "bursting"
efs_encrypted = false

# S3
# s3_bucket_name = ["aws-waf-logs-xxxxstest-kr", "xxxx-lab-test-kr","xxxx-test-kr-a1c-prediction"]
s3_bucket_name = ["s3-fox-terraform1", "s3-fox-terraform2"]
# s3_acl_config  = "private"
s3_object_ownership = "BucketOwnerEnforced"
s3_enable_versioning = true

# MSK-Kafka
kafka_version = "3.5.1"
enhanced_monitoring = "PER_TOPIC_PER_BROKER" # (DEFAULT, PER_BROKER, PER_TOPIC_PER_BROKER, or PER_TOPIC_PER_PARTITION)
kafka_instance_type = "kafka.t3.small"
kafka_ebs_storage = 200
encrypt_in_transit = "TLS_PLAINTEXT" # (TLS, TLS_PLAINTEXT)
encrypt_in_cluster = true

# MSK-Kafka - ServerProperty Config
auto_create_topics_enable=true
default_replication_factor=2
min_insync_replicas=2
num_io_threads=8
num_network_threads=5
num_partitions=1
num_replica_fetchers=2
socket_request_max_bytes=104857600
unclean_leader_election_enable=true
message_max_bytes=104857600

# Redis Cluster
escache_cluster_name = "kr-redis-cluster"
node_type = "cache.t2.micro"
engine_version = "7.1"
redis_port = 6379
maintenance_window = "sat:23:00-sun:00:00"
redis_parameter_group = "default.redis7"


# RDS - xxxx 
allocated_storage = 60
max_allocated_storage = 200
storage_type = "gp3"
db_engine_version = "12.11"
instance_spec = "db.m6g.large"
parameter_group_name = "test-au-rds-pg-postgres12-debezium"
def_db_username = "username"
def_db_passwd = "xxxxxxxxxxxxxx"

# RDS - test


# SNS & Lambda
topic_lambda_map = {
  "xxxx-p-kr-alarm" = {
    topic_name = "xxxx-p-kr-alarm"
    python_file = "lambda_alarm.py"
    description = "general sla alarm"
    SLACK_WEBHOOK_CHANNEL = "alarm-sla-critical"
    SLACK_WEBHOOK_ICON = ":firefighter:"
    SLACK_WEBHOOK_URL = "https://hooks.slack.com/services/xxxxxxxxxxxxxx"
    SLACK_WEBHOOK_USERNAME = "Mr.Oh~No!"
  }

  "iso-27001" = {
    topic_name = "iso-27001"
    python_file = "lambda_iso.py"
    description = "security issue alarm"
    SLACK_WEBHOOK_CHANNEL = "iso-27001"
    SLACK_WEBHOOK_ICON = ":whale:"
    SLACK_WEBHOOK_URL = "https://hooks.slack.com/services/xxxxxxxxxxxxx"
    SLACK_WEBHOOK_USERNAME = "Mr.Testing!"
  }

}


# CloudWatch Log
cw_log_paramters = {
    P-kr-k8s-xxxx-api = {
      # kms_key_id = "kms-id-12345678",
      retention_in_days = 90
    },
    P-kr-k8s-xxxx-admin-api = {
      # kms_key_id = "kms-id-12345678",
      retention_in_days = 90
    }
}

# ParameterStores
paramstores = {

  "/test/xxxx-data/trino/user_name" = {
    value       = "xxxxdata"
    secure_type = true
  } 

    "/test/xxxx-server/openai/token" = {
    value       = "kkkkkkabc123456"
    secure_type = true
  } 

  "/test/xxxx-data/trino/host" = {
    description = "test-jp"
    value       = "trino-srv.healtxxxxsync.com"
  }

  "/test/xxxx-data/trino/port" = {
    description = "test-jp"
    value       = "443"
  }

}


### ACM Domain Name ###
# domain_name = "xxxxxxx.cc"
# default_targetgroup = "k8s-kr-test-xxxxs-nginx"

# Alb 
# alb_name = "alb"
# alb_log_s3 = "kr-xxxx-alb-s3"

### TargetGroup 
# target_groups = {
#   "k8s-kr-test-xxxxs-nginx" = {
#     name        = "k8s-kr-test-xxxxs-nginx"
#     port        = 80
#     protocol    = "HTTP"
#     target_type = "ip"
#     health_check = {
#       interval            = 30
#       path                = "/favicon.ico"
#       port                = "80"
#       protocol            = "HTTP"
#       healthy_threshold   = 5
#       unhealthy_threshold = 2
#       timeout             = 5
#       matcher             = "200"
#     }
#     tags = {
#       Environment = "test-kr"
#       Service     = "nginx"
#     }
#   },
#   "k8s-kr-test-admin-api" = {
#     name        = "k8s-kr-test-admin-api"
#     port        = 8400
#     protocol    = "HTTPS"
#     target_type = "ip"
#     algorithm = "least_outstanding_requests"
#     health_check = {
#       interval            = 60
#       path                = "/probe/health"
#       port                = "443"
#       protocol            = "HTTPS"
#       healthy_threshold   = 3
#       unhealthy_threshold = 2
#       timeout             = 40
#     }
#     tags = {
#       Environment = "test-kr"
#       Service     = "admin-api"
#     }
#   },
#   "k8s-kr-test-xxxxs-apisvc" = {
#     name        = "k8s-kr-test-xxxxs-apisvc"
#     port        = 8100
#     protocol    = "HTTPS"
#     target_type = "ip"
#     algorithm = "least_outstanding_requests"
#     health_check = {
#       interval            = 60
#       path                = "/probe/health"
#       port                = "443"
#       protocol            = "HTTPS"
#       healthy_threshold   = 2
#       # unhealthy_threshold = 3
#       timeout             = 30
#     }
#     tags = {
#       Environment = "test-kr"
#       Service     = "xxxx-api"
#     }
#   }
# }

### Alb Rules

# alb_rules = {
#   100 = {
#     name = "k8s-kr-test-xxxxs-nginx"
#     type = "forward"
#     path_condition= {
#       path_pattern = [
#         "/wellness/signout",
#         "/wellness/*_signin",
#         "/wellness/redirect*",
#         "/wellness/*report*"
#       ]
#     }
#   },
#   90 = {
#     name = "k8s-kr-test-admin-api"
#     type = "forward"
#     path_condition= {
#       path_pattern = [
#         "/webview*",
#         "/apps*",
#         "/collaboration*",
#         "/sms*",
#         "/social_connect/fitbit"
#       ]
#     }
#   },
#   80 = {
#     name = "k8s-kr-test-xxxxs-apisvc"
#     type = "forward"
#     path_condition= {
#       path_pattern = [
#         "/libreview_connect/callback",
#         "/fitbit_connect/callback",
#         "/peer/*"
#       ]
#     }
#   },
# }

