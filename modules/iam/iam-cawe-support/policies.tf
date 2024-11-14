### IAM policy cawe developer

resource "aws_iam_policy" "assume_role" {
    count = local.is_admin_account ? 1 : 0

    name = "${var.policy_prefix}-asumme-role-support"

    policy = jsonencode({
        Version   = "2012-10-17"
        Statement = [
            {
                Action = [
                    "sts:AssumeRole",
                    "sts:TagSession"
                ],
                Effect   = "Allow"
                Resource = "arn:${data.aws_partition.current.partition}:iam::*:role/cawe/${var.role_name}"
            }
        ]
    })
}

resource "aws_iam_policy" "UserRODenyAccessToResources" {
    name = "${var.policy_prefix}-UserRODenyAccessToResources"

    policy = jsonencode({
        "Version" : "2012-10-17",
        "Statement" : [
            {
                "Action" : [
                    "kms:Decrypt",
                    "s3:GetObject",
                    "ssm:GetParameter*",
                    "secretsmanager:GetSecretValue",
                    "secretsmanager:DescribeSecret",
                    "dynamodb:GetItem",
                    "dynamodb:Query",
                    "dynamodb:Scan",
                    "dynamodb:BatchGetItem",
                    "dynamodb:GetRecords"
                ],
                "Resource" : "*",
                "Effect" : "Deny",
                "Sid" : "DenyAccessToResources"
            }
        ]
    })
}


resource "aws_iam_policy" "UserROPolicyDiff" {
    name = "${var.policy_prefix}-UserROPolicyDiff"

    policy = jsonencode({
        "Version" : "2012-10-17",
        "Statement" : [
            {
                "Action" : [
                    "account:ViewBilling",
                    "account:ViewUsage",
                    "access-analyzer:Get*",
                    "access-analyzer:List*",
                    "amplify:Get*",
                    "amplify:List*",
                    "ce:Get*",
                    "ce:Describe*",
                    "ce:List*",
                    "config:Select*",
                    "cur:Get*",
                    "cur:Describe*",
                    "glue:Get*",
                    "glue:List*",
                    "invoicing:Get*",
                    "invoicing:List*",
                    "network-firewall:Describe*",
                    "network-firewall:List*",
                    "organizations:Describe*",
                    "quicksight:Describe*",
                    "quicksight:List*",
                    "securityhub:BatchGet*",
                    "securityhub:Describe*",
                    "securityhub:Get*",
                    "securityhub:List*",
                    "savingsplans:Describe*",
                    "savingsplans:List*",
                    "trustedadvisor:DownloadRisk",
                    "trustedadvisor:ListRoots",
                    "trustedadvisor:ListOrganizationalUnitsForParent",
                    "trustedadvisor:ListAccountsForParent"
                ],
                "Resource" : "*",
                "Effect" : "Allow"
            }
        ]
    })
}
