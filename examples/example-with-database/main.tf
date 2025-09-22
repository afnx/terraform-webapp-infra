provider "aws" {
  region = var.aws_region
}

module "webapp_infra" {
  source = "../../"

  aws_region      = var.aws_region
  aws_domain_name = var.aws_domain_name
  aws_containers  = var.aws_containers
  aws_databases   = var.aws_databases
}
