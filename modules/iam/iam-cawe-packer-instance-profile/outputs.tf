output "role_arn" {
  value = aws_iam_role.cawe-packer-role.arn
}
output "role_name" {
  value = aws_iam_role.cawe-packer-role.name
}

output "instance_profile_name" {
  value = aws_iam_instance_profile.packer_instance_profile.name
}
