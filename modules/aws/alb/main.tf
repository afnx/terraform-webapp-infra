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

resource "aws_lb_target_group" "container" {
  for_each    = { for k, v in var.containers : k => v if v.public }
  name        = "${each.key}-tg"
  port        = each.value.port
  protocol    = upper(each.value.protocol)
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    path                = (upper(each.value.protocol) == "HTTP" || upper(each.value.protocol) == "HTTPS") ? lookup(each.value, "health_check", "") : null
    protocol            = upper(each.value.protocol)
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  tags = var.tags
}

resource "aws_lb_listener" "http" {
  count             = length([for c in var.containers : c if c.public && lower(c.protocol) == "http"]) > 0 ? 1 : 0
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
  depends_on = [aws_lb_target_group.container]
  tags       = var.tags
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
  depends_on = [aws_lb_target_group.container]
  tags       = var.tags
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
