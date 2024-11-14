resource "aws_lb" "nlb" {
  #checkov:skip=CKV_AWS_91: TODO: we will enable the access logs later
  for_each           = var.targets
  name               = "nlb-${each.key}"
  load_balancer_type = "network"
  subnets            = var.subnets_id
  internal           = true

  enable_cross_zone_load_balancing = true
  enable_deletion_protection       = true

  tags = {
    Name : "nlb"
  }
}

resource "aws_lb_listener" "target" {

  for_each = var.targets

  load_balancer_arn = aws_lb.nlb[each.key].arn
  port              = each.value.listener_port
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg[each.key].arn
  }
}

resource "aws_lb_target_group" "lb_tg" {

  for_each = var.targets

  name        = "lb-tg-${each.key}"
  port        = each.value.target_service_port
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  depends_on = [aws_lb.nlb]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group_attachment" "tg_attachment" {

  for_each = var.targets

  target_group_arn  = aws_lb_target_group.lb_tg[each.key].arn
  target_id         = each.value.target_service_ip
  availability_zone = "all"
  port              = each.value.target_service_port
}

#vpc peering to be used when/if account permissions allow us in the future
/*
 resource "aws_vpc_peering_connection" "peering_to_vpc" {
   peer_owner_id = var.peer_owner_id
   peer_vpc_id   = var.vpc_peer_id
   vpc_id        = var.vpc_id
 }
*/