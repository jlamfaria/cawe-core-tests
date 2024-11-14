output "nlb_dns" {
  value = aws_lb.nginx.dns_name
}

output "zone_id_nlb" {
  value = aws_lb.nginx.zone_id
}
