resource "aws_autoscaling_group" "asg-nginx" {
  #checkov:skip=CKV_AWS_315: we will check nginx later
  name                      = var.autoscaling_name
  health_check_grace_period = 30
  default_cooldown          = 30
  min_size                  = var.min_nginx_size
  max_size                  = var.max_nginx_size
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = toset(data.aws_subnets.private_vpc_private_subnets.ids)
  wait_for_capacity_timeout = 0
  health_check_type         = "ELB"

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "cawe-nginx-ha"
  }
  launch_template {
    id      = aws_launch_template.nginx.id
    version = aws_launch_template.nginx.latest_version
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }
}
#checkov:skip=CKV2_AWS_15: ""Ensure that auto Scaling groups that are associated with a load balancer, are using Elastic Load Balancing health checks
resource "aws_autoscaling_attachment" "nginx" {

  count = length(var.nginx_ports)

  autoscaling_group_name = var.autoscaling_name
  lb_target_group_arn    = aws_lb_target_group.nginx[count.index].arn

  depends_on = [aws_lb_target_group.nginx, aws_autoscaling_group.asg-nginx ]
}