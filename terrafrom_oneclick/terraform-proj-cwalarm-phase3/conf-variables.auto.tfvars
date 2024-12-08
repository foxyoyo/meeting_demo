# Metrics Alarm for TargetGroup


sns-topic = "arn:aws:sns:ap-northeast-1:xxxxxxxxxx:h2-p-kr-alarm"


### Metrics Alarm
# TargetGroup Block #
cw_alarms = {
  p-tg-responsetime-k8s-prod-h2s-api-st = {
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods = 3
    datapoints_to_alarm = 2
    metric_name         = "TargetResponseTime"
    namespace           = "AWS/ApplicationELB"
    period              = 60
    statistic           = "Average"
    threshold           = 5
    alarm_description   = "Target Response Time for monitor TG:k8s-prod-h2s-api-st"
    treat_missing_data  = "notBreaching"
    LoadBalancer = "app/h2-server-lb/489712807999a451"                                                                                             
    TargetGroup = "targetgroup/k8s-prod-h2s-api-st/55098ae1f4c7af0a"
  },
  p-tg-responsetime-k8s-prod-h2s-wellness-st = {
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods = 5
    datapoints_to_alarm = 3
    metric_name         = "TargetResponseTime"
    namespace           = "AWS/ApplicationELB"
    period              = 60
    statistic           = "Average"
    threshold           = 5
    alarm_description   = "Target Response Time for monitor TG:k8s-prod-wellness-st"
    treat_missing_data  = "notBreaching"
    LoadBalancer = "app/h2-server-lb/489712807999a451"                                                                                             
    TargetGroup = "targetgroup/k8s-prod-h2s-wellness-st/63e2bf8bdd333c8d"
  },
# WaF Rule Block 
  p-waf-CrossSiteScript_Body = {
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods = 1
    datapoints_to_alarm = 3
    metric_name         = "CountedRequests"
    namespace           = "AWS/WAFV2"
    period              = 300
    statistic           = "Average"
    threshold           = 3
    alarm_description   = "Count of WAF Rules for Rule=CrossSiteScripting_BODY"
    treat_missing_data  = "notBreaching"
    Rule   = "CrossSiteScripting_BODY"                                                                                      
    Region = "ap-northeast-2"
    WebACL = "PROD-WAF-ACL"   
  },
# Redis Node Block 
    p-terraform-redis-cluster-st-service-Db-Mem-UsagePercent = {
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = 2
      datapoints_to_alarm = 2
      metric_name         = "DatabaseMemoryUsagePercentage"
      namespace           = "AWS/ElastiCache"
      period              = 60
      statistic           = "Average"
      threshold           = 90
      alarm_description   = "Mem usage percent of redis-pord-st-cluster "
      treat_missing_data  = "missing"
      CacheClusterId      = "prod-redis-st-prod-001",                                                                                    
      CacheNodeId          = "0001"
    },
    p-terraform-redis-cluster-st-service_FreeableMemory = {
      comparison_operator = "LessThanThreshold"
      evaluation_periods  = 3
      datapoints_to_alarm = 3
      metric_name         = "FreeableMemory"
      namespace           = "AWS/ElastiCache"
      period              = 300
      statistic           = "Average"
      threshold           = 1200000000
      alarm_description   = "FreeableMemory of redis-pord-st-cluster "
      treat_missing_data  = "missing"
      CacheClusterId      = "prod-redis-st-prod-001",                                                                                    
      CacheNodeId          = "0001"
    },
    p-terraform-redis-cluster-st-service_EngineCPUUtilization = {
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = 3
      datapoints_to_alarm = 3
      metric_name         = "EngineCPUUtilization"
      namespace           = "AWS/ElastiCache"
      period              = 300
      statistic           = "Average"
      threshold           = 90
      alarm_description   = "CPUUtilization of redis-pord-st-cluster "
      treat_missing_data  = "missing"
      CacheClusterId      = "prod-redis-st-prod-001",                                                                                    
      CacheNodeId          = "0001"
    },
    p-terraform-redis-cluster-pm_Evictions = {
      comparison_operator = "GreaterThanOrEqualToThreshold"
      evaluation_periods  = 1
      datapoints_to_alarm = 1
      metric_name         = "Evictions"
      namespace           = "AWS/ElastiCache"
      period              = 300
      statistic           = "Average"
      threshold           = 1
      alarm_description   = "Node eviction happened of redis-pord-cluster "
      treat_missing_data  = "missing"
      CacheClusterId      = "prod-redis-st-prod-001",                                                                                    
      CacheNodeId          = "0001"
    },
# Redis Cluster Block
    p-terraform-redis-cluster-st-MemoryUsagePercentage = {
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = 5
      datapoints_to_alarm = 5
      metric_name         = "DatabaseMemoryUsagePercentage"
      namespace           = "AWS/ElastiCache"
      period              = 60
      statistic           = "Average"
      threshold           = 70
      alarm_description   = "FreeableMemory of redis-pord-st-cluster "
      treat_missing_data  = "missing"
      CacheClusterId      = "prod-redis-st-prod-001"                                                                                 
    },
    p-terraform-redis-cluster-st-FreeableMemory = {
      comparison_operator = "LessThanThreshold"
      evaluation_periods  = 5
      datapoints_to_alarm = 5
      metric_name         = "FreeableMemory"
      namespace           = "AWS/ElastiCache"
      period              = 60
      statistic           = "Average"
      threshold           = 700
      alarm_description   = "FreeableMemory of redis-pord-st-cluster "
      treat_missing_data  = "missing"
      CacheClusterId      = "prod-redis-st-prod-001"                                                                                 
    },
    p-terraform-redis-cluster-st-service-CPUUtilization = {
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = 5
      datapoints_to_alarm = 5
      metric_name         = "CPUUtilization"
      namespace           = "AWS/ElastiCache"
      period              = 60
      statistic           = "Average"
      threshold           = 70
      alarm_description   = "CPUUtilization of redis-pord-st-cluster "
      treat_missing_data  = "missing"
      CacheClusterId      = "prod-redis-st-prod-001"                                                                                 
    },
# RDS Block
    p-terraform-etl-db-instance-master_CPUUtilization = {
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = 5
      datapoints_to_alarm = 5
      metric_name         = "CPUUtilization"
      namespace           = "AWS/RDS"
      period              = 60
      statistic           = "Average"
      threshold           = 70
      alarm_description   = "CPUUtilization of RDS"
      treat_missing_data  = "missing"                                                                                 
      DBInstanceIdentifier          = "etl-db-instance-master"
    },
    p-terraform-etl-db-instance-master_FreeableMemory = {
      comparison_operator = "LessThanThreshold"
      evaluation_periods  = 4
      datapoints_to_alarm = 4
      metric_name         = "FreeableMemory"
      namespace           = "AWS/RDS"
      period              = 300
      statistic           = "Average"
      threshold           = 800000000
      alarm_description   = "FreeableMemory of RDS"
      treat_missing_data  = "missing"                                                                                 
      DBInstanceIdentifier          = "etl-db-instance-master"
    },
    p-terraform-mazu_FreeStorageSpace = {
      comparison_operator = "LessThanThreshold"
      evaluation_periods  = 6
      datapoints_to_alarm = 6
      metric_name         = "FreeStorageSpace"
      namespace           = "AWS/RDS"
      period              = 300
      statistic           = "Average"
      threshold           = 5000000000
      alarm_description   = "FreeStorageSpace of RDS"
      treat_missing_data  = "missing"                                                                                 
      DBInstanceIdentifier          = "mazu"
    },
    p-terraform-shuriken_BurstBalance = {
      comparison_operator = "LessThanOrEqualToThreshold"
      evaluation_periods  = 3
      datapoints_to_alarm = 2
      metric_name         = "BurstBalance"
      namespace           = "AWS/RDS"
      period              = 300
      statistic           = "Average"
      threshold           = 95
      alarm_description   = "BurstBalance of RDS"
      treat_missing_data  = "missing"                                                                                 
      DBInstanceIdentifier          = "shuriken"
    },
    p-terraform-microservice-db-ReadIOPS = {
      comparison_operator = "GreaterThanOrEqualToThreshold"
      evaluation_periods  = 3
      datapoints_to_alarm = 3
      metric_name         = "ReadIOPS"
      namespace           = "AWS/RDS"
      period              = 300
      statistic           = "Average"
      threshold           = 1000
      alarm_description   = "ReadIOPS of RDS"
      treat_missing_data  = "missing"                                                                                 
      DBInstanceIdentifier          = "microservice-db"
    },
    p-terraform-microservice-db-WriteIOPS = {
      comparison_operator = "GreaterThanOrEqualToThreshold"
      evaluation_periods  = 3
      datapoints_to_alarm = 3
      metric_name         = "ReadIOPS"
      namespace           = "AWS/RDS"
      period              = 300
      statistic           = "Average"
      threshold           = 1000
      alarm_description   = "WriteIOPS of RDS"
      treat_missing_data  = "missing"                                                                                 
      DBInstanceIdentifier          = "microservice-db"
    },
    p-terraform-microservice-db-OldestReplicationSlotLag = {
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = 3
      datapoints_to_alarm = 2
      metric_name         = "OldestReplicationSlotLag"
      namespace           = "AWS/RDS"
      period              = 600
      statistic           = "Average"
      threshold           = 12000000000
      alarm_description   = "OldestReplicationSlotLag of RDS"
      treat_missing_data  = "missing"                                                                                 
      DBInstanceIdentifier          = "microservice-db"
    },
    p-terraform-shuriken-slave-0-db-SwapUsage = {
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = 4
      datapoints_to_alarm = 4
      metric_name         = "SwapUsage"
      namespace           = "AWS/RDS"
      period              = 300
      statistic           = "Average"
      threshold           = 200000000
      alarm_description   = "SwapUsage of RDS"
      treat_missing_data  = "missing"                                                                                 
      DBInstanceIdentifier          = "shuriken-slave-0"
    },
    p-terraform-microservice-db-DatabaseConnections = {
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = 5
      datapoints_to_alarm = 5
      metric_name         = "DatabaseConnections"
      namespace           = "AWS/RDS"
      period              = 60
      statistic           = "Average"
      threshold           = 800
      alarm_description   = "DatabaseConnections of RDS"
      treat_missing_data  = "breaching"                                                                                 
      DBInstanceIdentifier          = "microservice-db"
    },
### Kafka Topic 
  p-kafka-consumer_gp_pm-service-SumOffsetLag = {
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods = 4
    datapoints_to_alarm = 4
    metric_name         = "SumOffsetLag"
    namespace           = "AWS/Kafka"
    period              = 300
    statistic           = "Maximum"
    threshold           = 80
    alarm_description   = "Offsetlag count of Topic:physiological_data.public.smbg "
    treat_missing_data  = "missing"
    Consumer_group   = "pm-service"
    Region = "ap-northeast-1"                                                                                            
    Topic = "physiological_data.public.smbg"
    Cluster_name = "kafka"
  }
}

# 