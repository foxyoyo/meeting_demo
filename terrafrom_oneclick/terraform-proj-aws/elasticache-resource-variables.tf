variable "redis_port" {
  type = number
  default = 6379
}

variable "escache_cluster_name" {
  type = string
  default = "h2-dev-redis-cluster"
}

variable "dashboard_name" {
  type = string
  default = "DevOps"
}

variable "engine_version" {
  type = string
  default = "6.0"
}

variable "redis_parameter_group" {
  type = string
  default = "default.redis6.x"
}

variable "node_type" {
  type = string
  default = "cache.t2.micro" 
}

variable "maintenance_window" {
  type = string
  default = "sat:23:00-sun:00:00" 
}

