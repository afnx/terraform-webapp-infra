# RDS Outputs
output "rds_endpoints" {
  value       = { for k, db in aws_db_instance.rds : k => db.endpoint }
  description = "Map of RDS instance endpoints by database key"
}

output "rds_arn_map" {
  value       = { for k, db in aws_db_instance.rds : k => db.arn }
  description = "Map of RDS instance ARNs by database key"
}

output "rds_db_names" {
  value       = { for k, db in aws_db_instance.rds : k => db.db_name }
  description = "Map of RDS database names by database key"
}

# DynamoDB Outputs
output "dynamodb_table_names" {
  value       = { for k, tbl in aws_dynamodb_table.dynamodb : k => tbl.name }
  description = "Map of DynamoDB table names by database key"
}

output "dynamodb_table_arns" {
  value       = { for k, tbl in aws_dynamodb_table.dynamodb : k => tbl.arn }
  description = "Map of DynamoDB table ARNs by database key"
}

output "dynamodb_table_stream_arns" {
  value       = { for k, tbl in aws_dynamodb_table.dynamodb : k => tbl.stream_enabled == true ? tbl.stream_arn : null }
  description = "Map of DynamoDB table stream ARNs by database key (if enabled)"
}
