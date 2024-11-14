data "aws_caller_identity" "current"{}

data "aws_ami" "gha_runner_macOS_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["hypervisor-mac-arm64-*"]
  }
  owners = [data.aws_caller_identity.current.account_id]
}


resource "aws_launch_template" "runner-MACOS" {
  name                                 = "${var.group}-macOS-launch-template"
  image_id                             = data.aws_ami.gha_runner_macOS_ami.id
  instance_initiated_shutdown_behavior = "terminate"
  vpc_security_group_ids               = [aws_security_group.main.id]
  update_default_version               = true

  instance_type = "mac2.metal"
  user_data = base64encode(file("../scripts/runners/macos-hypervisor-startup.tpl"))



  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 800
      iops        = 10000
      throughput  = 700
      volume_type = "gp3"
    }
  }

  placement {
    tenancy = "host"
  }

  monitoring {
    enabled = true
  }

  iam_instance_profile {
    name = var.runner_instance_profile_name
  }


  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

}
