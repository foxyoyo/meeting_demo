variable "alb_name" {
  description = "alb_name"
  type = string 
  default = "h2s-alb"
}

variable "alb_log_s3" {
  description = "alb_log_s3"
  type = string 
  default = "h2s-alb-s3"
}

variable "default_targetgroup" {
  description = "default-targetgroup"
  type = string 
  default = "h2s-nginx"
}

variable "ssl_policy" {
 type = string 
 default = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "target_groups" {
  description = "target groups config"
  type = map(object({
    name         = string
    port         = number
    protocol     = string
    target_type  = string
    algorithm = optional(string) 
    health_check = object({
      interval            = number
      path                = optional(string)
      matcher             = optional(string)
      port                = optional(string)
      protocol            = optional(string)
      healthy_threshold   = optional(number)
      unhealthy_threshold = optional(number)
      timeout             = optional(number)
    })
    tags = map(string)
  }))
}

variable "alb_rules" {
  type = map(object({ 
    name = string
    type = optional(string)
    ip_condition = optional(object({
      source_ip  = optional(list(string))
    }))
    path_condition = optional(object({
      path_pattern  = optional(list(string))
    }))
    host_condition = optional(object({
      host_header  = optional(list(string))
    }))
  }))
}