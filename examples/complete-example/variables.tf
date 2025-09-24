variable "deploy_aws" {
  type        = bool
  description = "Whether to deploy AWS resources."
  default     = false
}

variable "aws_region" {
  description = "Region to deploy AWS resources."
  type        = string
  default     = "us-west-2"
}

variable "aws_tags" {
  description = "Tags to apply to resources."
  type        = map(string)
  default = {
    Environment = "production"
    Owner       = "your-team"
    Project     = "webapp"
  }
}

variable "aws_domain_name" {
  type        = string
  description = "The primary domain name for the ACM certificate."
}

variable "aws_subject_alternative_names" {
  type        = list(string)
  description = "A list of additional domain names for the ACM certificate. Domain names could be subdomains."
  default     = []
}

variable "aws_vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "aws_public_subnet_cidrs" {
  type        = list(string)
  description = "List of public subnet CIDRs"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "aws_private_subnet_cidrs" {
  type        = list(string)
  description = "List of private subnet CIDRs"
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "aws_subnet_availability_zones" {
  type        = list(string)
  description = "List of availability zones to use for subnets"
  default     = ["us-west-2a", "us-west-2b"]
}

variable "aws_vpc_flow_logs_role_name" {
  type        = string
  description = "Name of the IAM role for VPC Flow Logs"
  default     = "VPCFlowLogsRole"
}

variable "aws_alb_name" {
  type        = string
  description = "Name of the ALB"
  default     = "webapp-alb"
}

variable "aws_alb_security_group_name" {
  type        = string
  description = "Name for the ALB security group"
  default     = "webapp-alb-sg"
}

variable "aws_alb_security_group_description" {
  type        = string
  description = "Description for the ALB security group"
  default     = "Security group for the Application Load Balancer"
}

variable "aws_alb_ingress_cidr_blocks_http" {
  type        = list(string)
  description = "List of CIDR blocks allowed to access ALB on HTTP (port 80)"
  default     = ["0.0.0.0/0"]
}

variable "aws_alb_ingress_cidr_blocks_https" {
  type        = list(string)
  description = "List of CIDR blocks allowed to access ALB on HTTPS (port 443)"
  default     = ["0.0.0.0/0"]
}

variable "aws_alb_egress_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks allowed for ALB egress"
  default     = ["0.0.0.0/0"]
}

variable "aws_ecs_cluster_name" {
  type        = string
  description = "Name of the ECS cluster"
  default     = "webapp-ecs-cluster"
}

variable "aws_ecs_task_execution_role_name" {
  type        = string
  description = "Name of the ECS task execution role"
  default     = "ECSTaskExecutionRole"
}

variable "aws_ecs_security_group_name" {
  type        = string
  description = "Name for the ECS tasks security group"
  default     = "webapp-ecs-sg"
}

variable "aws_ecs_security_group_description" {
  type        = string
  description = "Description for the ECS tasks security group"
  default     = "Security group for the ECS tasks"
}

variable "aws_ecs_security_group_egress_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks for egress rules in the ECS tasks security group"
  default     = ["0.0.0.0/0"]
}

variable "aws_ecs_task_definition_family_name" {
  type        = string
  description = "Family name for the ECS task definition"
  default     = "webapp-task-family"
}

variable "aws_ecs_service_name" {
  type        = string
  description = "Name of the ECS service"
  default     = "webapp-ecs-service"
}

variable "aws_service_connect_namespace" {
  type        = string
  description = "The Service Connect namespace for the ECS cluster"
  default     = "webapp-service-connect"
}

variable "aws_service_connect_namespace_description" {
  type        = string
  description = "Description for the Service Connect namespace"
  default     = "Namespace for the webapp service connect"
}

variable "aws_cloudwatch_log_group_name" {
  type        = string
  description = "Name of the CloudWatch log group for ECS tasks"
  default     = "webapp-ecs-log-group"
}

variable "aws_databases" {
  type = map(object({
    engine                          = string
    rds_instance_class              = optional(string)
    rds_engine                      = optional(string)
    rds_engine_version              = optional(string)
    rds_db_name                     = optional(string)
    rds_username                    = optional(string)
    rds_password_arn                = optional(string)
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
  description = "Map of database configurations"
  default     = {}
}

variable "aws_containers" {
  type = map(object({
    image                            = string
    cpu                              = number
    memory                           = number
    port                             = number
    health_check                     = optional(string)
    health_check_interval            = optional(number)
    health_check_timeout             = optional(number)
    health_check_retries             = optional(number)
    health_check_start_period        = optional(number)
    health_check_healthy_threshold   = optional(number)
    health_check_unhealthy_threshold = optional(number)
    public                           = bool
    domain                           = optional(string)
    protocol                         = string
    port_name                        = optional(string)
    desired_count                    = optional(number)
    environment                      = optional(map(string))
    enable_logs                      = optional(bool, true)
    redirect_to_https                = optional(bool, false)
    secrets = optional(list(object({
      name      = string
      valueFrom = string
    })))
    autoscaling = optional(object({
      min_capacity       = number
      max_capacity       = number
      target_cpu         = number
      scale_in_cooldown  = number
      scale_out_cooldown = number
    }))
  }))
  description = "Map of containers to deploy"
  default     = {}
}
