module "aws_acm" {
  source                    = "./modules/aws/acm"
  count                     = var.deploy_aws ? 1 : 0
  providers                 = { aws = aws.primary }
  domain_name               = var.aws_domain_name
  subject_alternative_names = var.aws_subject_alternative_names
  tags                      = var.aws_tags
}

module "aws_route53" {
  source                    = "./modules/aws/route53"
  count                     = var.deploy_aws ? 1 : 0
  providers                 = { aws = aws.primary }
  domain_name               = var.aws_domain_name
  subject_alternative_names = var.aws_subject_alternative_names
  certificate_arn           = module.aws_acm[0].certificate_arn
  domain_validation_options = module.aws_acm[0].domain_validation_options
}
