data "aws_s3_bucket" "software-tools" {
  bucket = "software-tools-cawe"
    provider = aws.admin
}

data "aws_kms_alias" kms_key {
  name = "alias/cawe-main-key-new"
}