
# data "aws_kms_key" "s3" {
#   key_id = "alias/aws/s3"
# }
# data "aws_kms_key" "s3_encryption_key" {
#   key_id = data.aws_kms_key.s3.key_id
# }


module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.2.1"

  for_each = toset(var.s3_bucket_name)
  bucket = "${each.key}"
  # acl    = var.s3_acl_config

  object_ownership = var.s3_object_ownership

  # server_side_encryption_configuration = [
  #   {
  #     apply_server_side_encryption_by_default = {
  #       kms_master_key_id = data.aws_kms_key.s3_encryption_key.key_id
  #       sse_algorithm = "AES256"
  #     }
  #   }
  # ]

  versioning = {
    enabled = true
  }

}