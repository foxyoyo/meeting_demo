module "lambda_sns" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "7.14.0"

  for_each = var.topic_lambda_map
  function_name = each.key
  description   = each.value.description
  handler       = "index.lambda_handler"
  runtime       = "python3.11"

  source_path = "lambda/${each.value.python_file}"

  environment_variables = {
    SLACK_WEBHOOK_CHANNEL = "${each.value.SLACK_WEBHOOK_CHANNEL}"
    SLACK_WEBHOOK_ICON = "${each.value.SLACK_WEBHOOK_ICON}"
    SLACK_WEBHOOK_URL = "${each.value.SLACK_WEBHOOK_URL}"
    SLACK_WEBHOOK_USERNAME = "${each.value.SLACK_WEBHOOK_USERNAME}"
  }

  tags = local.common_tags
}