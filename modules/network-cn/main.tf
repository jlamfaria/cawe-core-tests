resource "aws_lb" "nginx" {
  #checkov:skip=CKV_AWS_91: "Ensure the ELBv2 (Application/Network) has access logging enabled"
  #checkov:skip=CKV_AWS_150: "Ensure that Load Balancer has deletion protection enabled"
  name               = "cawe-to-intranet-nginx"
  internal           = true
  load_balancer_type = "network"
  security_groups    = [
    aws_security_group.load_balancer_nginx.id,
    aws_security_group.load_balancer_nginx_health_check.id
  ]
  subnets = toset(data.aws_subnets.private_vpc_private_subnets.ids)

  enable_cross_zone_load_balancing = true
  enable_deletion_protection       = false

  tags = merge({
    Purpose = "Forward traffic to BMW Intranet using NGINX reverse proxy"
  }, local.common_tags)
}

resource "aws_lb_target_group" "nginx" {
  count = length(var.nginx_ports)

  name_prefix = "${var.nginx_ports[count.index]}-"

  port                 = var.nginx_ports[count.index]
  protocol             = "TCP"
  target_type          = "instance"
  deregistration_delay = 600

  vpc_id = data.aws_vpc.private_vpc.id

  depends_on = [
    aws_lb.nginx
  ]

  lifecycle {
    create_before_destroy = true
  }

  tags = merge({
    TargetPort   = var.nginx_ports[count.index]
    LoadBalancer = aws_lb.nginx.name
  }, local.common_tags)

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 10
    interval            = 30
    port                = var.nginx_ports[count.index]
    protocol            = "TCP"
  }
}

resource "aws_lb_listener" "nginx" {
  count = length(var.nginx_ports)

  load_balancer_arn = aws_lb.nginx.arn

  port     = var.nginx_ports[count.index]
  protocol = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx[count.index].arn
  }
}

resource "aws_lb" "direct_vpc1" {
  #checkov:skip=CKV_AWS_91: "Ensure the ELBv2 (Application/Network) has access logging enabled"
  #checkov:skip=CKV_AWS_150: "Ensure that Load Balancer has deletion protection enabled"
  for_each = toset(var.load_balancers_vpc1)

  name               = each.key
  internal           = true
  load_balancer_type = "network"
  security_groups    = [aws_security_group.load_balancer_vpc1.id]
  subnets = toset(data.aws_subnets.private_vpc_private_subnets-1.ids)

  enable_cross_zone_load_balancing = true
  enable_deletion_protection       = false

  tags = merge({
    Purpose = "Forward traffic to BMW Intranet"
  }, local.common_tags)
}

resource "aws_lb_listener" "direct_vpc1" {
  count = length(var.target_groups_vpc1)

  load_balancer_arn = aws_lb.direct_vpc1[var.target_groups_vpc1[count.index].load_balancer].arn

  port     = var.target_groups_vpc1[count.index].service_port
  protocol = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.direct_vpc1[count.index].arn
  }
}

resource "aws_lb_target_group_attachment" "direct_vpc1" {
  count = length(var.target_groups_vpc1)

  target_group_arn = aws_lb_target_group.direct_vpc1[count.index].id
  target_id        = var.target_groups_vpc1[count.index].service_ip

  availability_zone = "all"
}

resource "aws_lb_target_group" "direct_vpc1" {
  count = length(var.target_groups_vpc1)

  name = "${var.target_groups_vpc1[count.index].service_port}-${var.target_groups_vpc1[count.index].load_balancer}"

  port        = var.target_groups_vpc1[count.index].service_port
  protocol    = "TCP"
  target_type = "ip"

  vpc_id = data.aws_vpc.private_vpc-1.id

  depends_on = [
    aws_lb.direct_vpc1
  ]
  }