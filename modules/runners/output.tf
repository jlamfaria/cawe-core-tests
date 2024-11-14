output "lambda_hash" {
  value = data.archive_file.lambda_zip.output_base64sha256
}

output "lambda_name" {
  value = aws_lambda_function.lambda_func.function_name
}

output "redis_endpoint" {
  value = aws_elasticache_replication_group.rg.primary_endpoint_address
}

output "redis_port" {
  value = aws_elasticache_replication_group.rg.port
}
