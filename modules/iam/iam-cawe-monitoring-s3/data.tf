data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "assume_role_policy_orbit" {
  statement {
    effect  = "Allow"
    sid     = "AssumeOIDC"
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]
    condition {
      test     = "StringEquals"
      values   = ["system:serviceaccount:cawe-monitoring:cawe-mimir-sa"]
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
