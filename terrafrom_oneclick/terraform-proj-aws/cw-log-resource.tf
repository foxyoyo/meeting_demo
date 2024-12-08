resource "aws_cloudwatch_log_group" "cwlog" {
  for_each = var.cw_log_paramters
    name = each.key
    retention_in_days = each.value.retention_in_days
    kms_key_id = lookup(each.value, "kms_key_id", "")
    tags = {
        Environment = "Dev"
        Name = "${each.key}"
    }
}