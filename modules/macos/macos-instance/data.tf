data "aws_ami" "macos-13" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn-ec2-macos-13*"] # get latest 13 AMI
  }
}