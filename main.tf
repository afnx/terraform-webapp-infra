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

module "aws_vpc" {
  source               = "./modules/aws/vpc"
  count                = var.deploy_aws ? 1 : 0
  providers            = { aws = aws.primary }
  vpc_cidr             = var.aws_vpc_cidr
  public_subnet_cidrs  = var.aws_public_subnet_cidrs
  private_subnet_cidrs = var.aws_private_subnet_cidrs
  tags                 = var.aws_tags
}

locals {
  allow_http  = length([for c in var.aws_containers : c if c.public && lower(c.protocol) == "http"]) > 0
  allow_https = length([for c in var.aws_containers : c if c.public && lower(c.protocol) == "https"]) > 0
}

resource "aws_security_group" "alb" {
  name        = var.aws_alb_security_group_name
  description = var.aws_alb_security_group_description
  vpc_id      = module.aws_vpc[0].vpc_id

  dynamic "ingress" {
    for_each = local.allow_http ? [1] : []
    content {
      from_port = 80
      to_port   = 80
      protocol  = "tcp"
      # tfsec:ignore:aws-ec2-no-public-ingress-sgr
      cidr_blocks = var.aws_alb_ingress_cidr_blocks_http
      description = "Allow inbound HTTP traffic to ALB"
    }
  }

  dynamic "ingress" {
    for_each = local.allow_https ? [1] : []
    content {
      from_port = 443
      to_port   = 443
      protocol  = "tcp"
      # tfsec:ignore:aws-ec2-no-public-ingress-sgr
      cidr_blocks = var.aws_alb_ingress_cidr_blocks_https
      description = "Allow inbound HTTPS traffic to ALB"
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = var.aws_tags
}

module "aws_alb" {
  source                 = "./modules/aws/alb"
  count                  = var.deploy_aws ? 1 : 0
  providers              = { aws = aws.primary }
  alb_name               = var.aws_alb_name
  vpc_id                 = module.aws_vpc[0].vpc_id
  public_subnet_ids      = module.aws_vpc[0].public_subnet_ids
  certificate_arn        = module.aws_acm[0].certificate_arn
  alb_security_group_ids = [aws_security_group.alb.id]
  containers             = var.aws_containers
  tags                   = var.aws_tags
}
