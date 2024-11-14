resource "aws_security_group" "ecs_security_group" {
  name        = "ecs-security-group"
  vpc_id      = var.vpc_id
  description = "ECS security group"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow egress"
  }
}

resource "aws_launch_template" "ecs_lt" {
  name          = "${var.ecs_cluster_name}-ecs-launch-template"
  image_id      = data.aws_ami.latest_amazon_linux_2023_ami.image_id
  instance_type = "t3.small"

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  vpc_security_group_ids = [aws_security_group.ecs_security_group.id]
  iam_instance_profile {
    name = var.ec2_instance_profile
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = var.ec2_disk_size
      volume_type = "gp3"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags          = {
      Name             = "ecs-instance"
      ecs_cluster_name = var.ecs_cluster_name
    }
  }

  user_data = base64encode("#!/bin/bash\necho ECS_CLUSTER=${var.ecs_cluster_name} >> /etc/ecs/ecs.config")

}

resource "aws_autoscaling_group" "ecs_asg" {
  name                = "ECS Autoscaling Group - ${var.ecs_cluster_name}"
  vpc_zone_identifier = var.subnet_list
  desired_capacity    = var.asg_desired_capacity
  max_size            = var.asg_maximum_size
  min_size            = var.asg_minimum_size

  launch_template {
    id      = aws_launch_template.ecs_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.ecs_cluster_name
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_capacity_provider" "ecs_capacity_provider" {
  name = var.ecs_cluster_name

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.ecs_asg.arn

    managed_scaling {
      maximum_scaling_step_size = 1000
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = var.asg_desired_capacity
    }
  }

}

resource "aws_ecs_cluster_capacity_providers" "cluster-cp" {
  cluster_name = aws_ecs_cluster.ecs_cluster.name

  capacity_providers = [
    aws_ecs_capacity_provider.ecs_capacity_provider.name
  ]

}

resource "aws_cloudwatch_log_group" "endpoint-monitoring_logs" {
  #checkov:skip=CKV_AWS_158
  #checkov:skip=CKV_AWS_338

  name              = "endpoint-monitoring-logs"
  kms_key_id = var.kms_arn
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "service" {
  family                = "endpoint-monitoring"
  network_mode          = "awsvpc"
  container_definitions = jsonencode([
    {
      name                   = "blackbox"
      image                  = "${var.blackbox_ecr}:${var.blackbox_tag}"
      cpu                    = 500
      memory                 = 512
      essential              = true
      readonlyRootFilesystem = true
      portMappings           = [
        {
          containerPort = 9115
          hostPort      = 9115
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options   = {
          "awslogs-group"         = aws_cloudwatch_log_group.endpoint-monitoring_logs.name
          "awslogs-region"        = "eu-central-1"
          "awslogs-stream-prefix" = "blackbox"
        }
      }
    },
    {
      name                   = "prometheus"
      image                  = "${var.prometheus_ecr}:${var.prometheus_tag}"
      cpu                    = 500
      memory                 = 512
      essential              = true
      readonlyRootFilesystem = true
      logConfiguration       = {
        logDriver = "awslogs"
        options   = {
          "awslogs-group"         = aws_cloudwatch_log_group.endpoint-monitoring_logs.name
          "awslogs-region"        = "eu-central-1"
          "awslogs-stream-prefix" = "prometheus"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "endpoint-monitoring" {
  name            = "endpoint-monitoring"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = 1

  network_configuration {
    subnets         = var.subnet_list
    security_groups = [aws_security_group.ecs_security_group.id]
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }
}
