resource "aws_ecs_cluster" "main" {
  name = var.ecs_cluster_name
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  tags = var.tags
}

resource "aws_iam_role" "ecs_task_execution" {
  name = var.ecs_task_execution_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

locals {
  secrets_arns = flatten([
    for c in values(var.containers) : (
      c.secrets != null ?
      [for s in c.secrets : s.valueFrom] :
      []
    )
  ])
  ssm_arns            = [for arn in local.secrets_arns : arn if can(regex("^arn:aws:ssm:", arn))]
  secretsmanager_arns = [for arn in local.secrets_arns : arn if can(regex("^arn:aws:secretsmanager:", arn))]
}

resource "aws_iam_role_policy" "ecs_task_secrets_access" {
  count = (length(local.ssm_arns) > 0 || length(local.secretsmanager_arns) > 0) ? 1 : 0

  name = "${var.ecs_task_execution_role_name}SecretsAccess"
  role = aws_iam_role.ecs_task_execution.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat(
      length(local.ssm_arns) > 0 ? [{
        Effect = "Allow"
        Action = [
          "ssm:GetParameters",
          "ssm:GetParameter",
          "ssm:GetParametersByPath"
        ]
        Resource = local.ssm_arns
      }] : [],
      length(local.secretsmanager_arns) > 0 ? [{
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = local.secretsmanager_arns
      }] : []
    )
  })
}

resource "aws_security_group" "ecs_tasks" {
  name        = var.ecs_security_group_name
  description = var.ecs_security_group_description
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = true
    description = "Allow ECS tasks to communicate with each other"
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    # tfsec:ignore:aws-ec2-no-public-egress-sgr
    cidr_blocks = var.ecs_security_group_egress_cidr_blocks
    description = "Allow outbound traffic from ECS tasks"
  }
  tags = var.tags
}

resource "aws_ecs_task_definition" "container" {
  for_each                 = var.containers
  family                   = "${var.ecs_task_definition_family_name}-${each.key}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = each.value.cpu
  memory                   = each.value.memory
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  container_definitions = jsonencode([{
    name      = each.key
    image     = each.value.image
    cpu       = each.value.cpu
    memory    = each.value.memory
    essential = true
    portMappings = [{
      containerPort = each.value.port
      name          = lookup(each.value, "port_name", "http")
    }]
    healthCheck = lookup(each.value, "health_check", "") != "" ? {
      command = [
        "CMD-SHELL",
        "curl -f http://localhost:${each.value.port}${lookup(each.value, "health_check", "") != null ? lookup(each.value, "health_check", "") : ""} || exit 1"
      ]
      interval    = lookup(each.value, "health_check_interval", 30)
      timeout     = lookup(each.value, "health_check_timeout", 5)
      retries     = lookup(each.value, "health_check_retries", 3)
      startPeriod = lookup(each.value, "health_check_start_period", 0)
    } : null
    environment = lookup(each.value, "environment", null) != null ? [
      for k, v in each.value.environment : { name = k, value = v }
    ] : null
    secrets = lookup(each.value, "secrets", null) != null ? each.value.secrets : null
    logConfiguration = lookup(each.value, "enable_logs", true) == true ? {
      logDriver = "awslogs"
      options = {
        awslogs-group         = var.log_group_name
        awslogs-region        = var.region
        awslogs-stream-prefix = each.key
      }
    } : null
  }])
  tags = var.tags
}

resource "aws_ecs_service" "container" {
  for_each        = var.containers
  name            = "${var.ecs_service_name}-${each.key}"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.container[each.key].arn
  launch_type     = "FARGATE"
  desired_count   = lookup(each.value, "desired_count", 1)
  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = false
  }
  dynamic "load_balancer" {
    for_each = each.value.public ? [1] : []
    content {
      target_group_arn = var.alb_target_groups[each.key].target_group_arn
      container_name   = each.key
      container_port   = each.value.port
    }
  }
  service_connect_configuration {
    enabled   = true
    namespace = var.service_connect_namespace
    service {
      port_name      = lookup(each.value, "port_name", "http")
      discovery_name = each.key
      client_alias {
        port     = each.value.port
        dns_name = each.key
      }
    }
  }
  tags       = var.tags
  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution]
}

resource "aws_appautoscaling_target" "container" {
  for_each           = { for k, v in var.containers : k => v if v.autoscaling != null }
  max_capacity       = each.value.autoscaling.max_capacity
  min_capacity       = each.value.autoscaling.min_capacity
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.container[each.key].name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  tags               = var.tags
}

resource "aws_appautoscaling_policy" "container_cpu" {
  for_each           = { for k, v in var.containers : k => v if v.autoscaling != null }
  name               = "${each.key}-cpu-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.container[each.key].resource_id
  scalable_dimension = aws_appautoscaling_target.container[each.key].scalable_dimension
  service_namespace  = aws_appautoscaling_target.container[each.key].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = each.value.autoscaling.target_cpu
    scale_in_cooldown  = each.value.autoscaling.scale_in_cooldown
    scale_out_cooldown = each.value.autoscaling.scale_out_cooldown
  }
}
