resource "aws_autoscaling_group" "asg" {
    #checkov:skip=CKV_AWS_315: we will check this later
    for_each                  = var.instance_types
    name                      = each.key
    health_check_grace_period = 30
    default_cooldown          = 30
    min_size                  = each.value.off_peak_capacity.desired_capacity
    desired_capacity          = each.value.off_peak_capacity.desired_capacity
    max_size                  = each.value.off_peak_capacity.desired_capacity
    vpc_zone_identifier       = var.vpc_private_subnets
    wait_for_capacity_timeout = 0
    enabled_metrics           = [
           "GroupInServiceCapacity",
           "GroupInServiceInstances",
           "GroupPendingCapacity",
           "GroupPendingInstances",
           "GroupTotalInstances",
        ]

    lifecycle {
        ignore_changes = [min_size, desired_capacity, max_size]
    }

    tag {
        key                 = "Name"
        propagate_at_launch = true
        value               = "pool-${each.key}"
    }

    mixed_instances_policy {
        instances_distribution {
            on_demand_percentage_above_base_capacity = 100
            spot_allocation_strategy                 = "lowest-price"
            on_demand_allocation_strategy            = "lowest-price"
        }

        launch_template {
            launch_template_specification {
                launch_template_id = aws_launch_template.runner.id
            }

            dynamic "override" {
                for_each = each.value.list
                content {
                    instance_type = override.value
                }
            }
        }
    }
}

resource "aws_autoscaling_schedule" "schedule_on_peak" {
    for_each = var.instance_types

    scheduled_action_name  = "Scale up On Peak"
    min_size               = each.value.on_peak_capacity.desired_capacity
    max_size               = each.value.on_peak_capacity.desired_capacity
    desired_capacity       = each.value.on_peak_capacity.desired_capacity
    recurrence             = "0 2 * * MON-FRI"
    time_zone              = "Etc/UTC"
    autoscaling_group_name = aws_autoscaling_group.asg[each.key].name
    lifecycle {
        ignore_changes = [start_time]
    }
}

resource "aws_autoscaling_schedule" "schedule_off_peak" {
    for_each = var.instance_types

    scheduled_action_name  = "Scale down Off Peak"
    min_size               = each.value.off_peak_capacity.desired_capacity
    max_size               = each.value.off_peak_capacity.desired_capacity
    desired_capacity       = each.value.off_peak_capacity.desired_capacity
    recurrence             = "30 18 * * MON-FRI"
    time_zone              = "Etc/UTC"
    autoscaling_group_name = aws_autoscaling_group.asg[each.key].name
    lifecycle {
        ignore_changes = [start_time]
    }
}
