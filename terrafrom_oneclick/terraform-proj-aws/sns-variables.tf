# variable "topic_lambda_map" {
#   type = map(string)
#   default = {
#     "topic_a" = "lambda_a",
#     "topic_b" = "lambda_b"
#   }
# }

variable "topic_lambda_map" {
  description = "sns's topic and lambda mapping"
  type        = map(object({
    topic_name = string
    python_file = string
    description = string
    SLACK_WEBHOOK_CHANNEL = optional(string)
    SLACK_WEBHOOK_ICON = optional(string)
    SLACK_WEBHOOK_URL = optional(string)
    SLACK_WEBHOOK_USERNAME = optional(string)
  }))
}