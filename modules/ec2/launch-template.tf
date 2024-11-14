data "aws_caller_identity" "current" {}

data "aws_ami" "gha_runner_ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["cawe-${var.distribution}-*"]
  }

  filter {
    name   = "tag:CAWE_Release"
    values = [var.ami_version]
  }

  filter {
    name   = "tag:Arch"
    values = [var.arch]
  }
}

resource "aws_launch_template" "runner" {
  name                                 = "${var.group}-runner-launch-template-${var.arch}"
  image_id                             = data.aws_ami.gha_runner_ami.id
  instance_initiated_shutdown_behavior = "terminate"
  vpc_security_group_ids               = [aws_security_group.aws_sg_runners.id]
  update_default_version               = true

  private_dns_name_options {
    hostname_type = "resource-name"
  }

  user_data = base64encode(templatefile("../scripts/runners/runner-startup.tpl", {
    redis_url = var.redis_endpoint
    redis_port = var.redis_port
  }))

  monitoring {
    enabled = true
  }

  block_device_mappings {
    device_name = var.volume_device_name

    ebs {
      volume_size = 100
      volume_type = "gp3"
    }
  }

  iam_instance_profile {
    name = var.runner_instance_profile_name
  }

  tag_specifications {
    resource_type = "instance"
    tags          = merge(local.tags, {
      Name = "${local.name_prefix}-runner-instance",
      Type = "pool"
    })
  }

  tag_specifications {
    resource_type = "volume"
    tags          = merge(local.tags, {
      Name = "${local.name_prefix}-runner-volume"
    })
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-launch-template"
  })
}
