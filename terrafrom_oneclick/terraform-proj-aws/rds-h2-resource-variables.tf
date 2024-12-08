
variable "allocated_storage" {
  type = number
  default = 60
}


variable "max_allocated_storage" {
  type = number
  default = 200
}

variable "storage_type" {
  type = string
  default = "gp3"
}

variable "db_engine_version" {
  type = string
  default = "12.11"
}

variable "instance_spec" {
  type = string
  default = "db.m6g.large"
}

variable "parameter_group_name" {
  type = string
  default = "prod-au-rds-pg-postgres12-debezium"
}

variable "def_db_username" {
  type = string
  default = "postgres"
  sensitive = true
}

variable "def_db_passwd" {
  type = string
  default = "Tcqg7v2ZeakJcg9FOIy"
  sensitive = true
}
