output "runner_instance_profile_name" {
  value = aws_iam_instance_profile.runner_instance_profile.name
}

output "lambda_role_arn" {
  value = aws_iam_role.lambda_role.arn
}

output "runner_role_arn" {
  value = aws_iam_role.runner_role.arn
}
output "lambda_name" {
  value = var.lambda_function_name
}
