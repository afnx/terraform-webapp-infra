provider "aws" {
  region = var.aws_region
}

module "webapp_infra" {
  source = "../../"

  deploy_aws = true

  aws_region = var.aws_region
  aws_tags   = var.aws_tags

  aws_domain_name               = var.aws_domain_name
  aws_subject_alternative_names = var.aws_subject_alternative_names

  aws_vpc_cidr                  = var.aws_vpc_cidr
  aws_public_subnet_cidrs       = var.aws_public_subnet_cidrs
  aws_private_subnet_cidrs      = var.aws_private_subnet_cidrs
  aws_subnet_availability_zones = var.aws_subnet_availability_zones
  aws_vpc_flow_logs_role_name   = var.aws_vpc_flow_logs_role_name

  aws_alb_name                       = var.aws_alb_name
  aws_alb_security_group_name        = var.aws_alb_security_group_name
  aws_alb_security_group_description = var.aws_alb_security_group_description
  aws_alb_ingress_cidr_blocks_http   = var.aws_alb_ingress_cidr_blocks_http
  aws_alb_ingress_cidr_blocks_https  = var.aws_alb_ingress_cidr_blocks_https
  aws_alb_egress_cidr_blocks         = var.aws_alb_egress_cidr_blocks

  aws_ecs_cluster_name                      = var.aws_ecs_cluster_name
  aws_ecs_task_execution_role_name          = var.aws_ecs_task_execution_role_name
  aws_ecs_security_group_name               = var.aws_ecs_security_group_name
  aws_ecs_security_group_description        = var.aws_ecs_security_group_description
  aws_ecs_security_group_egress_cidr_blocks = var.aws_ecs_security_group_egress_cidr_blocks
  aws_ecs_task_definition_family_name       = var.aws_ecs_task_definition_family_name
  aws_ecs_service_name                      = var.aws_ecs_service_name

  aws_databases  = var.aws_databases
  aws_containers = var.aws_containers
}
