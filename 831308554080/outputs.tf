output "tools_bucket_arn" {
  value = module.tools_bucket.bucket_arn
}

output "ecr_cawe_endpoint_monitoring_blackbox_url" {
  value = module.ecr-cawe-endpoint-monitoring-blackbox.repository_url
}

output "ecr_cawe_endpoint_monitoring_prometheus_url" {
  value = module.ecr-cawe-endpoint-monitoring-prometheus.repository_url
}

output "ecr_cawe_endpoint_monitoring_blackbox_arn" {
  value = module.ecr-cawe-endpoint-monitoring-blackbox.repository_arn
}

output "ecr_cawe_endpoint_monitoring_prometheus_arn" {
  value = module.ecr-cawe-endpoint-monitoring-prometheus.repository_arn
}

output "kms_euc1" {
  value = module.kms.key_arn
}

output "kms_euw1" {
  value = aws_kms_replica_key.kms-ireland.arn
}
