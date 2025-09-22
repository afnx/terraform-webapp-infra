variable "aws_region" {
  type        = string
  default     = "us-west-2"
  description = "AWS region"
}

variable "aws_domain_name" {
  type        = string
  default     = "example.com"
  description = "Primary domain name"
}

variable "aws_containers" {
  type = map(object({
    image         = string
    cpu           = number
    memory        = number
    port          = number
    health_check  = optional(string)
    public        = bool
    domain        = optional(string)
    protocol      = string
    desired_count = optional(number)
    autoscaling = optional(object({
      min_capacity       = number
      max_capacity       = number
      target_cpu         = number
      scale_in_cooldown  = number
      scale_out_cooldown = number
    }))
  }))
  description = "Container configuration"
}

variable "aws_databases" {
  type = map(object({
    engine                          = string
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
    dynamodb_table_name             = optional(string)
    dynamodb_hash_key               = optional(string)
    dynamodb_hash_key_type          = optional(string)
    dynamodb_range_key              = optional(string)
    dynamodb_range_key_type         = optional(string)
    dynamodb_read_capacity          = optional(number)
    dynamodb_write_capacity         = optional(number)
    dynamodb_billing_mode           = optional(string)
  }))
  description = "Database configuration"
}
