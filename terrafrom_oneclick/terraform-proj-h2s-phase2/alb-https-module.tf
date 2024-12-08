module "log_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.2.1"
  bucket = "${var.alb_log_s3}"
  acl    = "log-delivery-write"
  control_object_ownership = true
  object_ownership         = "ObjectWriter"
  attach_elb_log_delivery_policy = true # Required for ALB logs
  attach_lb_log_delivery_policy  = true # Required for ALB/NLB logs
  attach_deny_insecure_transport_policy = true
  attach_require_latest_tls_policy      = true
  tags = local.common_tags
}

module "alb" {
  source = "terraform-aws-modules/alb/aws"
  depends_on = [ module.log_bucket ]
  name    = "${local.name}-${var.alb_name}"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  # Security Group
  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_https = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      description = "HTTPS web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "10.0.0.0/16"
    }
  }

  access_logs = {
    bucket = module.log_bucket.s3_bucket_id
  }

  tags = {
    Environment = "Development"
    Project     = "Example"
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = module.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "${var.ssl_policy}"
  certificate_arn   = module.acm.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg["${var.default_targetgroup}"].arn
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = module.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}


resource "aws_lb_target_group" "alb_tg" {
  for_each = var.target_groups
  name        = each.value.name
  port        = each.value.port
  protocol    = each.value.protocol
  vpc_id      = module.vpc.vpc_id
  target_type = each.value.target_type
  load_balancing_algorithm_type = coalesce(each.value.algorithm, "round_robin")

  health_check {
    interval            = each.value.health_check.interval
    path                = each.value.health_check.path
    port                = each.value.health_check.port
    matcher             = each.value.health_check.matcher
    protocol            = each.value.health_check.protocol
    healthy_threshold   = each.value.health_check.healthy_threshold
    unhealthy_threshold = each.value.health_check.unhealthy_threshold
    timeout             = each.value.health_check.timeout
  }

  tags = each.value.tags
}


resource "aws_lb_listener_rule" "listener_https_rule" {
  depends_on = [ aws_lb_target_group.alb_tg ]
  for_each = var.alb_rules

  listener_arn = aws_lb_listener.https_listener.arn
  # priority     = each.value.priority 
  priority     = each.key

  dynamic "action" {
    for_each = each.value.type == "forward" ? [each.value.type] : []
    content {
      type             = action.value 
      target_group_arn =  aws_lb_target_group.alb_tg[each.value.name].arn
    }
  }

  dynamic "action" {
    for_each = each.value.type == "fixed-response" ? [each.value.type] : []
    content {
      type             = action.value 
      fixed_response {
        content_type = "text/plain"
        status_code  = "401"
      }     
    }
  }
  dynamic "condition" {
    for_each = can(each.value.path_condition.path_pattern) ? [each.value.path_condition.path_pattern] : []

    content {
      path_pattern {
        values = condition.value 
     }
    }
  }
  dynamic "condition" {
    for_each = can(each.value.host_condition.host_header) ? [each.value.host_condition.host_header] : []
  
    content {
      host_header {
        values = condition.value 
     }
    }
  }
  dynamic "condition" {
    for_each = can(each.value.ip_condition.source_ip) ? [each.value.ip_condition.source_ip] : []
  
    content {
      source_ip {
        values = condition.value
     }
    }
  }
}