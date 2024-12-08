# variable "efs_name" {
#   description = "EFS Name"
#   type = string 
#   default = "h2-server-efs"
# }


variable "efs_name" {
  description = "EFS Name"
  type = list(string)
  default = ["h2-server-efs"]
}

variable "efs_perf_mode" {
  description = "EFS PerfMode"
  type = string 
  default = "generalPurpose"
}


variable "efs_throu_mode" {
  description = "EFS Throughput"
  type = string 
  default = "bursting"
}

variable "efs_encrypted" {
  description = "EFS Enable encrypted"
  type = bool
  default = false
}