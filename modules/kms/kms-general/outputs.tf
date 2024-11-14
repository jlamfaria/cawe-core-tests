output "key_arn" {
  value = aws_kms_key.kms.arn
}

output "key_arn_nginx" {
  value = aws_kms_key.kms.arn
}

output "kms_policy" {
  value = aws_kms_key.kms.policy
}
