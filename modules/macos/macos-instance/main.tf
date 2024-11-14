#resource "aws_ec2_host" "macos-dh" {
#  instance_type     = "mac2.metal"
#  availability_zone = "eu-west-1a"
#  tags              = local.tags
#}
#
#resource "aws_instance" "mac_instance" {
#  monitoring             = true
#  ebs_optimized          = true
#  ami                    = data.aws_ami.macos-13.id
#  instance_type          = "mac2.metal"
#  key_name               = var.ssh_key_name
#  availability_zone      = "eu-west-1a"
#  host_id                = aws_ec2_host.macos-dh.id
#  subnet_id              = var.subnet_id
#  vpc_security_group_ids = [aws_security_group.main.id]
#
#  iam_instance_profile = var.runner_instance_profile_name
#
#  root_block_device {
#    encrypted = true
#    volume_size = 300
#  }
#
#  metadata_options {
#    http_endpoint = "enabled"
#    http_tokens   = "required"
#  }
#
#  tags = local.tags
#
#}


resource "aws_security_group" "main" {
  name        = "macOS"
  description = "sg-macOS"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH "
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks      = ["213.205.68.220/32","88.157.222.244/32"]
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks      = [var.vpc_cidr_range,var.vpc_cidr_range_IRL]
  }

  egress {
    description      = "Default"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = local.tags
}
