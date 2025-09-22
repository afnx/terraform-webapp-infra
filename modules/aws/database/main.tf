resource "aws_security_group" "rds" {
  for_each    = { for k, db in var.databases : k => db if db.engine == "rds" }
  name        = "${each.key}-rds-sg"
  description = "Security group for RDS instance ${each.key}"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = length(var.ecs_tasks_security_group_ids) > 0 ? var.ecs_tasks_security_group_ids : []
    content {
      from_port       = lookup(each.value, "rds_port", 5432)
      to_port         = lookup(each.value, "rds_port", 5432)
      protocol        = "tcp"
      security_groups = [ingress.value]
      description     = "Allow inbound DB traffic from ECS Fargate tasks"
    }
  }

  dynamic "ingress" {
    for_each = lookup(each.value, "rds_ingress_allowed_cidr_blocks", [])
    content {
      from_port = lookup(each.value, "rds_port", 5432)
      to_port   = lookup(each.value, "rds_port", 5432)
      protocol  = "tcp"
      # tfsec:ignore:aws-ec2-no-public-ingress-sgr
      cidr_blocks = [ingress.value]
      description = "Allow inbound DB traffic from CIDR"
    }
  }

  dynamic "egress" {
    for_each = lookup(each.value, "rds_egress_cidr_blocks", ["0.0.0.0/0"])
    content {
      from_port = 0
      to_port   = 0
      protocol  = "-1"
      # tfsec:ignore:aws-ec2-no-public-egress-sgr
      cidr_blocks = [egress.value]
      description = "Allow outbound traffic to CIDR"
    }
  }

  tags = var.tags
}


resource "aws_db_subnet_group" "rds" {
  for_each   = { for k, db in var.databases : k => db if db.engine == "rds" }
  name       = "${each.key}-subnet-group"
  subnet_ids = var.rds_subnet_ids
  tags       = var.tags
}

resource "aws_db_instance" "rds" {
  for_each               = { for k, db in var.databases : k => db if db.engine == "rds" }
  identifier             = each.value.rds_db_name
  instance_class         = each.value.rds_instance_class
  engine                 = each.value.rds_engine
  engine_version         = each.value.rds_engine_version
  db_name                = each.value.rds_db_name
  username               = each.value.rds_username
  password               = each.value.rds_password
  allocated_storage      = each.value.rds_allocated_storage
  storage_type           = lookup(each.value, "rds_storage_type", "gp2")
  multi_az               = lookup(each.value, "rds_multi_az", false)
  port                   = each.value.rds_port
  publicly_accessible    = lookup(each.value, "rds_publicly_accessible", false)
  skip_final_snapshot    = lookup(each.value, "rds_skip_final_snapshot", true)
  vpc_security_group_ids = [aws_security_group.rds[each.key].id]
  db_subnet_group_name   = aws_db_subnet_group.rds[each.key].name
  tags                   = var.tags
}

resource "aws_dynamodb_table" "dynamodb" {
  for_each       = { for k, db in var.databases : k => db if db.engine == "dynamodb" }
  name           = each.value.dynamodb_table_name
  hash_key       = each.value.dynamodb_hash_key
  range_key      = each.value.dynamodb_range_key
  billing_mode   = lookup(each.value, "dynamodb_billing_mode", "PROVISIONED")
  read_capacity  = each.value.dynamodb_billing_mode == "PROVISIONED" ? each.value.dynamodb_read_capacity : null
  write_capacity = each.value.dynamodb_billing_mode == "PROVISIONED" ? each.value.dynamodb_write_capacity : null
  attribute {
    name = each.value.dynamodb_hash_key
    type = lookup(each.value, "dynamodb_hash_key_type", "S")
  }
  dynamic "attribute" {
    for_each = each.value.dynamodb_range_key != null ? [each.value.dynamodb_range_key] : []
    content {
      name = each.value.dynamodb_range_key
      type = lookup(each.value, "dynamodb_range_key_type", "S")
    }
  }
  tags = var.tags
}
