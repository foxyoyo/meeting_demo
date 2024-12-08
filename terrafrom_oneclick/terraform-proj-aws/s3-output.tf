

output "bucket_ids" {
  value = { for k, v in module.s3_bucket : k => v.s3_bucket_id }
}


output "s3_bucket_arn" {
  value = { for k, v in module.s3_bucket : k => v.s3_bucket_arn }
  description = "The ARN of the S3 buckets."
}


