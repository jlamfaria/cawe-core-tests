resource "aws_iam_role" "iam-cawe-user-role" {
  name                 = var.role_name
  path                 = "/cawe/"
  max_session_duration = local.max_session_duration
  description          = "Role created by Connected CICD - CAWE"
  assume_role_policy   = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_policy" "cawe-user-policy-s3" {
  name        = "${var.policy_prefix}-user-s3"
  description = "${var.policy_prefix}-user-s3"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject"
        ],
        Effect   = "Allow"
        Resource = [
          var.bucket_tools_arn,
          "${var.bucket_tools_arn}/*",
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "cawe-user-policy-ecr" {
  #checkov:skip=CKV_AWS_355
  name        = "${var.policy_prefix}-user-ecr"
  description = "${var.policy_prefix}-user-ecr"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchDeleteImage",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:DeleteRepository",
          "ecr:DeleteRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:InitiateLayerUpload",
          "ecr:ListImages",
          "ecr:PutImage",
          "ecr:SetRepositoryPolicy",
          "ecr:UploadLayerPart",
          "ecr:GetAuthorizationToken"
        ],
        Effect   = "Allow"
        Resource = [var.ecr_arn]
      },
      {
        "Action": [
            "ecr:GetAuthorizationToken",
        ],
        "Effect": "Allow",
        "Resource": "*"
    }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cawe-user_policy-attachment-s3" {
  policy_arn = aws_iam_policy.cawe-user-policy-s3.arn
  role       = aws_iam_role.iam-cawe-user-role.name
}

resource "aws_iam_role_policy_attachment" "cawe-user_policy-attachment-ecr" {
  policy_arn = aws_iam_policy.cawe-user-policy-ecr.arn
  role       = aws_iam_role.iam-cawe-user-role.name
}
