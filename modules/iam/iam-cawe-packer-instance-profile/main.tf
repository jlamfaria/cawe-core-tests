resource "aws_iam_role" "cawe-packer-role" {
  name                 = "cawe-packer-role"
  path                 = "/cawe/"
  max_session_duration = local.max_session_duration
  description          = "Role created by Connected CICD - CAWE"
  assume_role_policy   = data.aws_iam_policy_document.assume_role_policy.json
  permissions_boundary = local.permissions_boundary
}

resource "aws_iam_policy" "cawe-packer-policy-kms" {
  name        = "${var.policy_prefix}-packer-kms"
  description = "${var.policy_prefix}-packer-kms"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ],
        Effect   = "Allow"
        Resource = var.kms_arns
      }
    ]
  })
}

resource "aws_iam_policy" "cawe-packer-policy-secretsmanager" {
  name        = "${var.policy_prefix}-packer-secretsmanager"
  description = "${var.policy_prefix}-packer-secretsmanager"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue"
        ],
        Effect   = "Allow"
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:ResourceTag/Access": "build"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "cawe-packer-policy-s3" {
  name        = "${var.policy_prefix}-packer-s3"
  description = "${var.policy_prefix}-packer-s3"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*"
        ],
        Effect   = "Allow"
        Resource = [
          var.bucket_arn,
          "${var.bucket_arn}/*",
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "cawe-packer-policy-ssm" {
  name        = "${var.policy_prefix}-packer-ssm"
  description = "${var.policy_prefix}-packer-ssm"
    #checkov:skip=CKV_AWS_288
    #checkov:skip=CKV_AWS_355
    #checkov:skip=CKV_AWS_290

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:DescribeAssociation",
          "ssm:GetDeployablePatchSnapshotForInstance",
          "ssm:GetDocument",
          "ssm:DescribeDocument",
          "ssm:GetManifest",
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:ListAssociations",
          "ssm:ListInstanceAssociations",
          "ssm:PutInventory",
          "ssm:PutComplianceItems",
          "ssm:PutConfigurePackageResult",
          "ssm:UpdateAssociationStatus",
          "ssm:UpdateInstanceAssociationStatus",
          "ssm:UpdateInstanceInformation",
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel",
          "ec2messages:AcknowledgeMessage",
          "ec2messages:DeleteMessage",
          "ec2messages:FailMessage",
          "ec2messages:GetEndpoint",
          "ec2messages:GetMessages",
          "ec2messages:SendReply"
        ]
        Resource = ["*"]
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "cawe-packer_policy-attachment-s3" {
  policy_arn = aws_iam_policy.cawe-packer-policy-s3.arn
  role       = aws_iam_role.cawe-packer-role.name
}

resource "aws_iam_role_policy_attachment" "cawe-packer_policy-attachment-ssm" {
  policy_arn = aws_iam_policy.cawe-packer-policy-ssm.arn
  role       = aws_iam_role.cawe-packer-role.name
}

resource "aws_iam_role_policy_attachment" "cawe-packer_policy-attachment-kms" {
  policy_arn = aws_iam_policy.cawe-packer-policy-kms.arn
  role       = aws_iam_role.cawe-packer-role.name
}

resource "aws_iam_role_policy_attachment" "cawe-packer_policy-attachment-secrets-manager" {
  policy_arn = aws_iam_policy.cawe-packer-policy-secretsmanager.arn
  role       = aws_iam_role.cawe-packer-role.name
}

resource "aws_iam_instance_profile" "packer_instance_profile" {
  name = "cawe-packer-instance-profile"
  role = aws_iam_role.cawe-packer-role.name

  tags = merge(local.tags, {
    Name = "cawe-packer-instance-profile"
  })
}
