data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

### Assume role policy for CAWE developer role ####

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
