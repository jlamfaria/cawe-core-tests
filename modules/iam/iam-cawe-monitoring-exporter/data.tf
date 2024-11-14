data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "assume_role_policy_stack" {
  statement {
    sid     = "STSAssume"
    actions = [
      "sts:AssumeRole",
      "sts:SetSourceIdentity",
      "sts:TagSession"
    ]
    principals {
      type        = "AWS"
      identifiers = var.trusted_entities
    }
  }
}

data "aws_iam_policy_document" "assume_role_policy_orbit" {
  statement {
    effect  = "Allow"
    sid     = "AssumeOIDC"
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]
    condition {
      test     = "StringEquals"
      values   = ["system:serviceaccount:cawe-monitoring:cawe-monitoring-exporter-sa"]
      variable = "${var.cluster_oidc}:sub"
    }
    principals {
      type        = "Federated"
      identifiers = [
        var.cluster_oidc_arn
      ]
    }
  }
}

data "tls_certificate" "eks_oidc" {
  count = local.is_stack_account
  url   = "https://${var.cluster_oidc}"
}
