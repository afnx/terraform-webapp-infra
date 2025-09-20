module "aws_acm" {
  source                    = "./modules/aws/acm"
  providers                 = { aws = aws }
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  tags                      = var.tags
}

module "aws_route53" {
  source                    = "./modules/aws/route53"
  providers                 = { aws = aws }
  domain_name               = var.domain_name
  certificate_arn           = module.aws_acm.certificate_arn
  domain_validation_options = module.aws_acm.domain_validation_options
}
