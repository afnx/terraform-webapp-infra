# Complete Example: Terraform Webapp Infrastructure

This example demonstrates deploying a full-featured web application infrastructure on AWS using the module. It provisions:

- VPC with public/private subnets
- Application Load Balancer (ALB)
- ECS Fargate cluster with multiple containers
- RDS (Postgres) and DynamoDB databases
- ACM certificate and Route53 DNS records

## Usage

```bash
terraform init
terraform plan
terraform apply
```