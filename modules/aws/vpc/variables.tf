variable "region" {
  type        = string
  description = "AWS region to deploy resources in"

}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of public subnet CIDRs"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of private subnet CIDRs"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones to use for subnets"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
}

variable "vpc_flow_logs_role_name" {
  type        = string
  description = "Name of the IAM role for VPC Flow Logs"
}
