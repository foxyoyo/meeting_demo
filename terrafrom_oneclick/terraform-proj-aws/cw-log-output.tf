
output "cw_loggroup" {
  value = { for k, v in aws_cloudwatch_log_group.cwlog : k => v.arn }
}