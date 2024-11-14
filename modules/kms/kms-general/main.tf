resource "aws_kms_key" "kms" {
    multi_region            = var.kms_multi_region
    enable_key_rotation     = true
    description             = "Cawe Stack KMS Key"
    deletion_window_in_days = 30
    policy                  = jsonencode(
        {
            "Version" : "2012-10-17",
            "Id" : "key-default-1",
            "Statement" : [
                {
                    "Sid" : "Enable IAM User Permissions",
                    "Effect" : "Allow",
                    "Principal" : {
                        "AWS" : var.kms_principals

                    },
                    "Action" : "kms:*",
                    "Resource" : "*"
                },
                {
                    "Effect" : "Allow",
                    "Principal" : { "Service" : "logs.${var.region}.amazonaws.com" },
                    "Action" : [
                        "kms:Encrypt*",
                        "kms:Decrypt*",
                        "kms:ReEncrypt*",
                        "kms:GenerateDataKey*",
                        "kms:Describe*"
                    ],
                    "Resource" : "*"
                }
            ]
        }
    )
}

resource "aws_kms_alias" "b" {
    name          = var.kms_alias_name
    target_key_id = aws_kms_key.kms.key_id
}

resource "aws_kms_grant" "ami_kms_share_grant" {
    count             = local.is_admin_account ? 0 : 1
    name              = "ami-kms-grant"
    key_id            = aws_kms_key.kms.key_id
    grantee_principal = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"
    operations        = [
        "Encrypt", "Decrypt", "ReEncryptFrom", "ReEncryptTo", "GenerateDataKey", "GenerateDataKeyWithoutPlaintext",
        "DescribeKey", "CreateGrant"
    ]
}
