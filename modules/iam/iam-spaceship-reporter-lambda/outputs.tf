output "role_arn" {
  value = aws_iam_role.spaceship-reporter-lambda-role.arn
}

output "role_name" {
  value = aws_iam_role.spaceship-reporter-lambda-role.name
}
