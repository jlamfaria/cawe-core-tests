data "aws_partition" "current" {}

data "aws_iam_policy_document" "s3-policy" {
  statement {
    sid       = "AllowSSLRequestsOnly"
    actions   = ["s3:*"]
    effect    = "Deny"
    resources = [
      aws_s3_bucket.bucket.arn,
      "${aws_s3_bucket.bucket.arn}/*"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
  statement {
    sid       = "Allow from advanced accounts"
    actions   = ["s3:*"]
    effect    = "Allow"
    resources = [
      aws_s3_bucket.bucket.arn,
      "${aws_s3_bucket.bucket.arn}/*"
    ]

    dynamic "principals"{
      for_each = var.allowed_accounts
      content {
        type = "AWS"
        identifiers = ["arn:${data.aws_partition.current.partition}:iam::${principals.value}:root"]
      }
    }
  }

}
