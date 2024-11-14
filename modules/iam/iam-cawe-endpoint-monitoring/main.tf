resource "aws_iam_role" "cawe-endpoint-monitoring-role" {
  name                 = "cawe-endpoint-monitoring-role"
  path                 = "/cawe/"
  max_session_duration = local.max_session_duration
  description          = "Role created by Connected CICD - CAWE"
  assume_role_policy   = data.aws_iam_policy_document.endpoint-monitoring_assume_policy.json
}

resource "aws_iam_policy" "cawe-endpoint-monitoring-policy" {
  name        = "${var.policy_prefix}-endpoint-monitoring"
  description = "${var.policy_prefix}-endpoint-monitoring"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        "Action" : [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        "Resource" : var.ecr_arn
        "Effect" : "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cawe-endpoint-monitoring-policy-attachment" {
  policy_arn = aws_iam_policy.cawe-endpoint-monitoring-policy.arn
  role       = aws_iam_role.cawe-endpoint-monitoring-role.name
}

resource "aws_iam_role_policy_attachment" "cawe-endpoint-monitoring-policy-attachment-SSM" {
  policy_arn = data.aws_iam_policy.AmazonSSMServiceRolePolicy.arn
  role       = aws_iam_role.cawe-endpoint-monitoring-role.name
}

resource "aws_iam_instance_profile" "endpoint-monitoring_instance_profile" {
  name = "endpoint-monitoring_instance_profile"
  role = aws_iam_role.cawe-endpoint-monitoring-role.name
}

resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role       = aws_iam_role.cawe-endpoint-monitoring-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}
