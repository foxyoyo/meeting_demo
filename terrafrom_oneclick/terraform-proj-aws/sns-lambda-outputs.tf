# Lambda Function
output "lambda_output_arn" {
  description = "The ARN of the Lambda Function"
  # value       = module.lambda_function.lambda_function_arn
  value = { for k, v in module.lambda_sns : k => v.lambda_function_arn }
}


# #
# output "topic_lambda_map" {
#   value = "${zipmap(module.users.topic_user, module.topics.sns_topics)}"
# }