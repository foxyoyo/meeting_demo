variable "s3_bucket_name" {
  description = "S3"
  type = list(string)
  default = ["s3-h2-bucket1", "s3-h2-bucket2"]
}


# variable "s3_acl_config" {
#   description = "The canned ACL to apply. Conflicts with grant"
#   type = string 
#   default = "private"
# }


variable "s3_object_ownership" {
  description = "S3 Object ownership"
  type = string 
  default = "BucketOwnerEnforced"
}


variable "s3_enable_versioning" {
  description = "Enable S3 Version"
  type = bool
  default = false
}




