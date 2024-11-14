data "aws_ami" "latest_amazon_linux_2023_ami" {
  most_recent = true
  owners = ["amazon"]
  name_regex = "al2023-ami-ecs-hvm-2023.*-kernel-6.1-x86_64"
}
