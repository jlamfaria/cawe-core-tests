resource "aws_iam_role" "cawe-monitoring-exporter-role" {
  name                 = "cawe-monitoring-exporter-role"
  path                 = "/cawe/"
  max_session_duration = local.max_session_duration
  description          = "Role created by Connected CICD - CAWE"
  assume_role_policy   = local.is_stack_account == 1 ? data.aws_iam_policy_document.assume_role_policy_stack.json : data.aws_iam_policy_document.assume_role_policy_orbit.json
}

resource "aws_iam_policy" "cawe-monitoring-exporter-policy-advanced" {
  count       = local.is_stack_account
  name        = "${var.policy_prefix}-monitoring-exporter"
  description = "${var.policy_prefix}-monitoring-exporter"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        "Action" : [
          "cloudwatch:ListMetrics",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:GetMetricData"
        ]
        "Resource" : "*"
        "Effect" : "Allow"
      }
    ]
  })
}

resource "aws_iam_policy" "cawe-monitoring-exporter-policy-cluster" {
  count       = local.is_orbit_account
  name        = "${var.policy_prefix}-monitoring-exporter"
  description = "${var.policy_prefix}-monitoring-exporter"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        "Action" : [
          "sts:AssumeRole"
        ]
        "Resource" : var.adv_role
        "Effect" : "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cawe-monitoring-exporter-role-policy-attachment-cluster" {
  count      = local.is_orbit_account
  policy_arn = aws_iam_policy.cawe-monitoring-exporter-policy-cluster[count.index].arn
  role       = aws_iam_role.cawe-monitoring-exporter-role.name
}

resource "aws_iam_role_policy_attachment" "cawe-monitoring-exporter-role-policy-attachment-advanced" {
  count      = local.is_stack_account
  policy_arn = aws_iam_policy.cawe-monitoring-exporter-policy-advanced[count.index].arn
  role       = aws_iam_role.cawe-monitoring-exporter-role.name
}

resource "aws_iam_openid_connect_provider" "oidc" {
  count           = local.is_stack_account
  url             = "https://${var.cluster_oidc}"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_oidc[count.index].certificates[0].sha1_fingerprint]
}


