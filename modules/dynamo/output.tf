output "dynamo_table_id" {
  description = "DynamoDB Table Id"
  value       = aws_dynamodb_table.default.id
}