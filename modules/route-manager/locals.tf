locals {
  common_tags = merge({
    Module = "cawe-core.route-manager"
  }, var.common_tags)

  tg_service_ports_vpc1 = flatten([
    for entry in var.target_groups_vpc1 : [
      entry.service_port,
      entry.service_port != entry.service_port ? entry.service_port : null
    ]
  ])

  tg_unique_service_ports_vpc1 = compact(local.tg_service_ports_vpc1)

  all_service_ports_vpc1 = concat(var.nginx_ports, local.tg_unique_service_ports_vpc1)

  tg_service_ports_vpc2 = flatten([
    for entry in var.target_groups_vpc2 : [
      entry.service_port,
      entry.service_port != entry.service_port ? entry.service_port : null
    ]
  ])

  tg_unique_service_ports_vpc2 = compact(local.tg_service_ports_vpc2)

  all_service_ports_vpc2 = concat(var.nginx_ports, local.tg_unique_service_ports_vpc2)

  lb_ports = var.nginx_ports

  name_prefix           = var.group
  nginx_config_template = local.transit_nginx_config_template
  log_group_name        = "nginx-${var.environment}"
  nginx_resolver_ip     = cidrhost(data.aws_vpc.vpc1.cidr_block, 2)

  transit_nginx_config_template = <<-EOF
      user www-data;
      worker_processes auto;
      worker_rlimit_nofile 5120;
      pid /run/nginx.pid;
      include /etc/nginx/modules-enabled/*.conf;
      error_log /var/log/nginx/error.log;

      events {
          worker_connections ${var.worker_connections};
      }

      stream {
          server {

            %{for port in local.lb_ports}
                listen ${port};
            %{endfor}

              resolver ${local.nginx_resolver_ip};
              proxy_connect_timeout 20s;
              proxy_pass $ssl_preread_server_name:$server_port;
              ssl_preread on;
          }
      }
  EOF

  userdata = <<-USERDATA
    #!/bin/bash
    export USER=root

    start_monitoring_services() {
      echo "Starting node_exporter and cawe-monitoring services"
      sudo systemctl enable node_exporter --now
      sudo systemctl enable cawe-monitoring --now

      echo "Starting fluent-bit service"
      sed "s/AWS_INSTANCE_ID/$aws_instance_id/" /usr/local/configs/fluent-bit.conf >/tmp/fluent-bit.conf.tmp
      mv /tmp/fluent-bit.conf.tmp /usr/local/configs/fluent-bit.conf
      sudo mv /usr/local/configs/fluent-bit.conf /etc/fluent-bit/fluent-bit.conf
      sudo systemctl restart fluent-bit
    }

    start_nginx_service() {
      echo "Starting nginx services"
      nginx -t
      sudo systemctl enable nginx --now
      sudo systemctl restart nginx
    }

    echo "=========== Nginx startup script ============"

    echo "Retrieve instance metadata from EC2 API"
    aws_token=$(curl -s --show-error -f -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 180")
    aws_region=$(curl -s --show-error -f -H "X-aws-ec2-metadata-token: $aws_token" -v http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)
    aws_instance_id=$(curl -s --show-error -f -H "X-aws-ec2-metadata-token: $aws_token" -v http://169.254.169.254/latest/meta-data/instance-id)

    echo "Setting hostname to nginx-$aws_instance_id"
    sudo hostnamectl set-hostname "nginx-$aws_instance_id"

    echo "Starting monitoring services"
    start_monitoring_services

    echo '${local.nginx_config_template}' | sudo tee /etc/nginx/nginx.conf

    start_nginx_service

   USERDATA

}