resource "aws_iam_role" "cawe-nginx-role" {
  name                 = "cawe-nginx-role"
  path                 = "/cawe/"
  max_session_duration = local.max_session_duration
  description          = "Role created by Connected CICD - CAWE"
  assume_role_policy   = data.aws_iam_policy_document.assume_role_policy.json
  permissions_boundary = local.permissions_boundary
}

resource "aws_iam_role_policy_attachment" "ManagedInstanceCore" {
  policy_arn = "arn:aws-cn:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.cawe-nginx-role.name
}

resource "aws_iam_role_policy_attachment" "SSMAutomationRole" {
  policy_arn = "arn:aws-cn:iam::aws:policy/service-role/AmazonSSMAutomationRole"
  role       = aws_iam_role.cawe-nginx-role.name
}

resource "aws_iam_instance_profile" "nginx_instance_profile" {
  name = "cawe-nginx-instance-profile"
  role = aws_iam_role.cawe-nginx-role.name

  tags = merge(local.tags, {
    Name = "cawe-nginx-instance-profile"
  })
}
