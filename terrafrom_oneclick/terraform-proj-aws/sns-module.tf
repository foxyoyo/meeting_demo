

locals {

  lambda_endpoint = values({ for k, v in module.lambda_sns : k => v.lambda_function_arn })
  topic_name = [for v in var.topic_lambda_map : v.topic_name]
                
}

module "sns" {
  source  = "terraform-aws-modules/sns/aws"
  version = "6.1.1"
  depends_on = [module.lambda_sns]

  # for_each = var.topic_lambda_map
  # name  = each.value.topic_name

  count = length(local.lambda_endpoint)
  name = element(local.topic_name, count.index)

  subscriptions = {
    sqs = {
      protocol = "lambda"
      endpoint =  element(local.lambda_endpoint, count.index)
    }
  }

  tags = local.common_tags

}