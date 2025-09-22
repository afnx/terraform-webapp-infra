variable "aws_region" {
  type        = string
  default     = "us-west-2"
  description = "AWS region"
}

variable "aws_tags" {
  type = map(string)
  default = {
    Environment = "production"
    Owner       = "your-team"
    Project     = "webapp"
  }
  description = "Tags for AWS resources"
}

variable "aws_domain_name" {
  type        = string
  default     = "example.com"
  description = "Primary domain name"
}

variable "aws_subject_alternative_names" {
  type        = list(string)
  default     = ["www.example.com"]
  description = "Additional domain names"
}

variable "aws_vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "VPC CIDR block"
}

variable "aws_public_subnet_cidrs" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
  description = "Public subnet CIDRs"
}

variable "aws_private_subnet_cidrs" {
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
  description = "Private subnet CIDRs"
}

variable "aws_vpc_flow_logs_role_name" {
  type        = string
  default     = "VPCFlowLogsRole"
  description = "IAM role for VPC Flow Logs"
}

variable "aws_alb_name" {
  type        = string
  default     = "webapp-alb"
  description = "ALB name"
}

variable "aws_alb_security_group_name" {
  type        = string
  default     = "webapp-alb-sg"
  description = "ALB security group name"
}

variable "aws_alb_security_group_description" {
  type        = string
  default     = "Security group for the Application Load Balancer"
  description = "ALB security group description"
}

variable "aws_alb_ingress_cidr_blocks_http" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "ALB HTTP ingress CIDRs"
}

variable "aws_alb_ingress_cidr_blocks_https" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "ALB HTTPS ingress CIDRs"
}

variable "aws_alb_egress_cidr_blocks" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "ALB egress CIDRs"
}

variable "aws_ecs_cluster_name" {
  type        = string
  default     = "webapp-ecs-cluster"
  description = "ECS cluster name"
}

variable "aws_ecs_task_execution_role_name" {
  type        = string
  default     = "ECSTaskExecutionRole"
  description = "ECS task execution role name"
}

variable "aws_ecs_security_group_name" {
  type        = string
  default     = "webapp-ecs-sg"
  description = "ECS security group name"
}

variable "aws_ecs_security_group_description" {
  type        = string
  default     = "Security group for the ECS tasks"
  description = "ECS security group description"
}

variable "aws_ecs_security_group_egress_cidr_blocks" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "ECS security group egress CIDRs"
}

variable "aws_ecs_task_definition_family_name" {
  type        = string
  default     = "webapp-task-family"
  description = "ECS task definition family name"
}

variable "aws_ecs_service_name" {
  type        = string
  default     = "webapp-ecs-service"
  description = "ECS service name"
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
  description = "Database configurations"
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
  description = "Container configurations"
}
