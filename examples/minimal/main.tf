provider "aws" {
  region = var.aws_region
}

module "webapp_infra" {
  source = "../../"

  deploy_aws = true

  aws_region      = var.aws_region
  aws_domain_name = var.aws_domain_name
  aws_containers  = var.aws_containers
}
