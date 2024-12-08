output "alb_log_bucket" {
  description = "The name of the bucket."
  value       = module.log_bucket.s3_bucket_id
}

output "arn" {
  description = "The ID and ARN of the load balancer we created"
  value       = module.alb.arn
}

output "target_group_arns" {
  value = [for k, v in aws_lb_target_group.alb_tg : v.arn]
}

output "target_associated_alb" {
  value = [for k, v in aws_lb_target_group.alb_tg : v.load_balancer_arns]
}


