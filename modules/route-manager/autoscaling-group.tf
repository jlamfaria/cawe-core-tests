resource "aws_autoscaling_group" "asg-nginx" {
  #checkov:skip=CKV_AWS_315: we will check nginx later
  name                      = var.autoscaling_name
  health_check_grace_period = 30
  default_cooldown          = 30
  min_size                  = var.min_nginx_size
  max_size                  = var.max_nginx_size
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = toset(data.aws_subnets.subnets_vpc1.ids)
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

  lifecycle { 
    ignore_changes = [desired_capacity]
  }

}
#checkov:skip=CKV2_AWS_15: ""Ensure that auto Scaling groups that are associated with a load balancer, are using Elastic Load Balancing health checks
resource "aws_autoscaling_attachment" "nginx" {

  count = length(var.nginx_ports)

  autoscaling_group_name = var.autoscaling_name
  lb_target_group_arn    = aws_lb_target_group.nginx[count.index].arn

  depends_on = [aws_lb_target_group.nginx, aws_autoscaling_group.asg-nginx ]
}

resource "aws_autoscaling_policy" "nginx-scale-up" {
  name                   = "${var.autoscaling_name}-scale-up-policy"
  scaling_adjustment     = 2
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg-nginx.name
}

resource "aws_autoscaling_policy" "nginx-scale-down" {
  name                   = "${var.autoscaling_name}-scale-down-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg-nginx.name
}

resource "aws_cloudwatch_metric_alarm" "nginx-scale-up" {
  alarm_name          = "${var.autoscaling_name}-scale-up-alert"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  threshold           = var.nginx_scale_up_threshold

  metric_query {
    id          = "e1"
    expression  = "m1/m2"
    label       = "NetworkOut per healthy target"
    return_data = "true"
  }

  metric_query {
    id = "m1"
    metric {
      metric_name = "NetworkOut"
      namespace   = "AWS/EC2"
      period      = "300"
      stat        = "Average"

      dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.asg-nginx.name
      }
    }
  }

  metric_query {
    id = "m2"
    metric {
      metric_name = "HealthyHostCount"
      namespace   = "AWS/NetworkELB"
      period      = "300"
      stat        = "Average"
      unit        = "Count"

      dimensions ={
        LoadBalancer = aws_lb.nginx.arn_suffix
	      TargetGroup  = aws_lb_target_group.nginx[0].arn_suffix
      }
    }
  }

  alarm_description = "NetworkOut per LB target above treshold"
  alarm_actions     = [aws_autoscaling_policy.nginx-scale-up.arn]
  tags              = local.common_tags
}

resource "aws_cloudwatch_metric_alarm" "nginx-scale-down" {
  alarm_name          = "${var.autoscaling_name}-scale-down-alert"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  threshold           = var.nginx_scale_down_threshold

  metric_query {
    id          = "e1"
    expression  = "(m1/m2)"
    label       = "NetworkOut per healthy target"
    return_data = "true"
  }

  metric_query {
    id = "m1"
    metric {
      metric_name = "NetworkOut"
      namespace   = "AWS/EC2"
      period      = "300"
      stat        = "Average"

      dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.asg-nginx.name
      }
    }
  }

  metric_query {
    id = "m2"
    metric {
      metric_name = "HealthyHostCount"
      namespace   = "AWS/NetworkELB"
      period      = "300"
      stat        = "Average"
      unit        = "Count"

      dimensions = {
        LoadBalancer = aws_lb.nginx.arn_suffix
	      TargetGroup  = 	aws_lb_target_group.nginx[0].arn_suffix
    }
   }
  }

  alarm_description = "NetworkOut per LB target below treshold"
  alarm_actions     = [aws_autoscaling_policy.nginx-scale-down.arn]
  tags              = local.common_tags
}
