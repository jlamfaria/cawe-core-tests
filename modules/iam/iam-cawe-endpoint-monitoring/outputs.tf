output "role_arn" {
  value = aws_iam_role.cawe-endpoint-monitoring-role.arn
}

output "role_name" {
  value = aws_iam_role.cawe-endpoint-monitoring-role.name
}

output "instance_profile" {
  value = aws_iam_instance_profile.endpoint-monitoring_instance_profile
}
