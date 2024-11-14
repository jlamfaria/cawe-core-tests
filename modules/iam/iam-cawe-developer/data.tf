data "local_file" "product" {
    filename = "../product.yml"
}
data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

### Assume role policy for CAWE developer role ####
data "aws_iam_openid_connect_provider" "github" {
    count = local.is_admin_account  ? 1 : 0
  url = var.oidc_provider_url
}

data "aws_iam_policy_document" "assume_role_policy" {
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

data "aws_iam_policy_document" "assume_role_policy_oidc" {
    count = local.is_admin_account  ? 1 : 0
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
    statement {
        actions = ["sts:AssumeRoleWithWebIdentity"]
        principals {
            type        = "Federated"
            identifiers = [data.aws_iam_openid_connect_provider.github[0].arn]
        }
        condition {
            test     = "StringEquals"
            variable = "code.connected.bmw/_services/token:aud"
            values   = ["sts.amazonaws.com"]
        }
        condition {
            test     = "StringLike"
            variable = "code.connected.bmw/_services/token:sub"
            values   = [
                "repo:cicd/*:*",
                "repo:steam-roller/*:*"
            ]
        }
    }
}

data "tls_certificate" "github" {
    url = var.oidc_provider_url
}