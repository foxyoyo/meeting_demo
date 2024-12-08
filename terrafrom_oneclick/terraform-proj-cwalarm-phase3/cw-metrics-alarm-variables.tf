

variable "sns-topic" {
  type = string
  default = "arn:aws:sns:ap-northeast-1:xxxxxxx:h2-p-aws-alarm"
}

variable "dashboard_name" {
  type = string
  default = "DevOps"
}

variable "cw_alarms" {
    type = map(object({
        # Common 
        comparison_operator = string,
        evaluation_periods = number,
        datapoints_to_alarm = number,
        metric_name         = string,
        namespace           = string,
        period              = number,
        statistic           = string,
        threshold           = number,
        alarm_description   = string,
        treat_missing_data  = string,
        # Common - Optional
        actions_enabled     = optional(string),
        alarm_actions       = optional(list(string)),
        ok_actions          = optional(list(string)),
        # TargetGroup Dimensions
        LoadBalancer   = optional(string),                                                                                           
        TargetGroup = optional(string),
        # WAF Dimensions
        Rule   = optional(string), 
        Region = optional(string),                                                                                         
        WebACL = optional(string),
        # Redis Cluster Dimensions 
        CacheClusterId   = optional(string), 
        CacheNodeId = optional(string),
        # RDS Dimensions
        DBInstanceIdentifier = optional(string),
        # Kafka Dimensions
        Consumer_group   = optional(string),                                                                                              
        Topic = optional(string),
        Cluster_name = optional(string)
    }))
}
