output "role_arn" {
  value = aws_iam_role.cawe-nginx-role.arn
}
output "role_name" {
  value = aws_iam_role.cawe-nginx-role.name
}

output "instance_profile_name" {
  value = aws_iam_instance_profile.nginx_instance_profile.name
}