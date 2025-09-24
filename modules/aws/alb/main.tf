resource "aws_lb" "main" {
  name = var.alb_name
  # tfsec:ignore:aws-elb-alb-not-public
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = var.alb_security_group_ids
  subnets                    = var.public_subnet_ids
  drop_invalid_header_fields = true
  tags                       = var.tags
}

resource "aws_lb_listener" "http" {
  count             = length([for c in var.containers : c if c.public]) > 0 ? 1 : 0
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
  tags = var.tags
}

locals {
  enable_https = length([for c in var.containers : c if c.public && lower(c.protocol) == "https"]) > 0
}

resource "aws_lb_listener" "https" {
  count             = local.enable_https ? 1 : 0
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-3-2021-06"
  certificate_arn   = var.certificate_arn
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
  tags = var.tags
}

resource "aws_lb_listener_rule" "http" {
  for_each     = { for k, v in var.containers : k => v if v.public && lower(v.protocol) == "http" }
  listener_arn = aws_lb_listener.http[0].arn
  priority     = 100 + index(keys(var.containers), each.key)
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.container[each.key].arn
  }
  condition {
    host_header {
      values = lookup(each.value, "domain", null) != null ? [each.value.domain] : ["*"]
    }
  }
  tags = var.tags
}

resource "aws_lb_listener_rule" "https" {
  for_each     = { for k, v in var.containers : k => v if v.public && lower(v.protocol) == "https" }
  listener_arn = aws_lb_listener.https[0].arn
  priority     = 200 + index(keys(var.containers), each.key)
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.container[each.key].arn
  }
  condition {
    host_header {
      values = lookup(each.value, "domain", null) != null ? [each.value.domain] : ["*"]
    }
  }
  tags = var.tags
}

resource "aws_lb_listener_rule" "redirect_to_https" {
  for_each = {
    for k, v in var.containers : k => v
    if v.public && lookup(v, "redirect_to_https", false) && length(aws_lb_listener.http) > 0
  }

  listener_arn = aws_lb_listener.http[0].arn
  priority     = 10 + index(keys(var.containers), each.key)

  action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
      host        = lookup(each.value, "domain", null) != null ? each.value.domain : "#{host}"
      path        = "/#{path}"
      query       = "#{query}"
    }
  }

  condition {
    host_header {
      values = lookup(each.value, "domain", null) != null ? [each.value.domain] : ["*"]
    }
  }

  tags = var.tags
}

resource "random_string" "tg_suffix" {
  for_each = { for k, v in var.containers : k => v if v.public }
  length   = 6
  upper    = false
  special  = false
}

resource "aws_lb_target_group" "container" {
  for_each    = { for k, v in var.containers : k => v if v.public }
  name        = "${each.key}-tg-${random_string.tg_suffix[each.key].result}"
  port        = each.value.port
  protocol    = upper(each.value.port_name)
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    enabled = can(trimspace(each.value.health_check)) && trimspace(each.value.health_check) != "" ? true : false
    path = (
      can(trimspace(each.value.health_check)) && trimspace(each.value.health_check) != "" && substr(trimspace(each.value.health_check), 0, 1) == "/" ?
      trimspace(each.value.health_check) :
      "/"
    )
    protocol            = upper(each.value.port_name)
    matcher             = "200-399"
    interval            = lookup(each.value, "health_check_interval", 30)
    timeout             = lookup(each.value, "health_check_timeout", 5)
    healthy_threshold   = lookup(each.value, "health_check_healthy_threshold", 5)
    unhealthy_threshold = lookup(each.value, "health_check_unhealthy_threshold", 2)
  }
  lifecycle {
    create_before_destroy = true
  }
  tags = var.tags
}
