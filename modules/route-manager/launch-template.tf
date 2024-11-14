data "aws_caller_identity" "current" {}

resource "aws_launch_template" "nginx" {
  name                   = "nginx-ha-launch-template"
  image_id               = data.aws_ami.nginx_ami.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [
    aws_security_group.load_balancer_nginx.id, aws_security_group.load_balancer_nginx_health_check.id
  ]
  update_default_version = true

  instance_initiated_shutdown_behavior = "terminate"

  private_dns_name_options {
    hostname_type = "resource-name"
  }

  user_data = base64encode(local.userdata)

  monitoring {
    enabled = true
  }

  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 32
      volume_type = "gp3"
    }
  }

  iam_instance_profile {
    name = var.nginx_instance_profile_name
  }

  tag_specifications {
    resource_type = "instance"
    tags          = merge(local.common_tags, {
      Name = "${local.name_prefix}-nginx-instance",
      Type = "nginx-ha"
    })
  }

  tag_specifications {
    resource_type = "volume"
    tags          = merge(local.common_tags, {
      Name = "${local.name_prefix}-nginx-ha-volume"
    })
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-launch-template"
  })
}

resource "aws_iam_instance_profile" "ssm_profile_role" {
  name = "ssm_profile_role"
  role = aws_iam_role.ssm_profile_role.name
}

resource "aws_iam_role" "ssm_profile_role" {
  name = "ssm_profile_role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ManagedInstanceCore" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.ssm_profile_role.name
}

resource "aws_iam_role_policy_attachment" "SSMAutomationRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonSSMAutomationRole"
  role       = aws_iam_role.ssm_profile_role.name
}
