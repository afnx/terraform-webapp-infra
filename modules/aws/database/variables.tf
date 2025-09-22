variable "vpc_id" {
  type        = string
  description = "VPC ID for databases"
}

variable "databases" {
  type = map(object({
    engine = string
    # RDS params
    rds_instance_class              = optional(string)
    rds_engine                      = optional(string)
    rds_engine_version              = optional(string)
    rds_db_name                     = optional(string)
    rds_username                    = optional(string)
    rds_password                    = optional(string)
    rds_allocated_storage           = optional(number)
    rds_storage_type                = optional(string)
    rds_multi_az                    = optional(bool)
    rds_port                        = optional(number)
    rds_publicly_accessible         = optional(bool)
    rds_skip_final_snapshot         = optional(bool)
    rds_ingress_allowed_cidr_blocks = optional(list(string))
    rds_egress_cidr_blocks          = optional(list(string))
    # DynamoDB params
    dynamodb_table_name     = optional(string)
    dynamodb_hash_key       = optional(string)
    dynamodb_hash_key_type  = optional(string)
    dynamodb_range_key      = optional(string)
    dynamodb_range_key_type = optional(string)
    dynamodb_read_capacity  = optional(number)
    dynamodb_write_capacity = optional(number)
    dynamodb_billing_mode   = optional(string)
  }))
  description = "Map of database configurations"
}

variable "rds_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for RDS"
}

variable "ecs_tasks_security_group_ids" {
  description = "List of ECS Fargate tasks security group IDs allowed to access RDS databases"
  type        = list(string)
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
}
