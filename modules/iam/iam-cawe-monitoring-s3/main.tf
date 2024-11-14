resource "aws_iam_role" "cawe-monitoring-s3-role" {
  name                 = "cawe-monitoring-s3-role"
  path                 = "/cawe/"
  max_session_duration = local.max_session_duration
  description          = "Role created by Connected CICD - CAWE"
  assume_role_policy   = data.aws_iam_policy_document.assume_role_policy_orbit.json
}

resource "aws_iam_policy" "cawe-monitoring-s3-policy-cluster" {
  name        = "${var.policy_prefix}-monitoring-s3"
  description = "${var.policy_prefix}-monitoring-s3"

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        "Sid" : "MimirS3BucketAccess",
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListObjects",
          "s3:DeleteObject",
          "s3:GetObjectTagging",
          "s3:PutObjectTagging"
        ],
        "Resource" : [
          var.bucket_arn,
          "${var.bucket_arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cawe-monitoring-s3-role-policy-attachment-cluster" {
  policy_arn = aws_iam_policy.cawe-monitoring-s3-policy-cluster.arn
  role       = aws_iam_role.cawe-monitoring-s3-role.name
}
