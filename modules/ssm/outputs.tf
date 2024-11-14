output "ssm_github_app_ids" {
  value = { for k, v in aws_ssm_parameter.github_app_id : k => {
    name = v.name
    arn  = v.arn
  } }
}

output "ssm_github_client_ids" {
  value = { for k, v in aws_ssm_parameter.github_client_id : k => {
    name = v.name
    arn  = v.arn
  } }
}

output "ssm_github_app_keys" {
  value = { for k, v in aws_ssm_parameter.github_app_key_base64 : k => {
    name = v.name
    arn  = v.arn
  } }
}

output "ssm_github_webhook_secrets" {
  value = { for k, v in aws_ssm_parameter.github_app_webhook_secret : k => {
    name = v.name
    arn  = v.arn
  } }
}