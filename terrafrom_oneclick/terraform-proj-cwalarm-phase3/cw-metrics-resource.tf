resource "aws_cloudwatch_metric_alarm" "p-kr-metrics-alarms" {

  tags = {
    DashboardName = var.dashboard_name
  }

  for_each = var.cw_alarms

    alarm_name          = each.key
    comparison_operator = each.value.comparison_operator
    evaluation_periods  = each.value.evaluation_periods
    datapoints_to_alarm = each.value.datapoints_to_alarm
    metric_name         = each.value.metric_name
    namespace           = each.value.namespace
    period              = each.value.period
    statistic           = each.value.statistic
    threshold           = each.value.threshold
    alarm_description   = each.value.alarm_description
    actions_enabled     = "true"
    alarm_actions       = [ var.sns-topic ]
    ok_actions          = [ var.sns-topic ]
    treat_missing_data  = each.value.treat_missing_data
    dimensions = {
          LoadBalancer   = each.value.LoadBalancer                                                                                             
          TargetGroup = each.value.TargetGroup
          Rule   = each.value.Rule, 
          Region = each.value.Region,                                                                                         
          WebACL = each.value.WebACL,
          CacheClusterId   = each.value.CacheClusterId,
          CacheNodeId = each.value.CacheNodeId,
          DBInstanceIdentifier = each.value.DBInstanceIdentifier,
          Consumer_group   = each.value.Consumer_group,                                                                                            
          Topic = each.value.Topic,
          Cluster_name = each.value.Cluster_name
        }
}
