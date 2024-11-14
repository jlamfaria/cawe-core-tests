### IAM policy cawe developer
resource "aws_iam_policy" "EC2" {
    #checkov:skip=CKV_AWS_290
    #checkov:skip=CKV_AWS_355
    count       = local.is_admin_account ? 1 : 0
    name        = "${var.policy_prefix}-EC2"
    description = "${var.policy_prefix}-EC2"

    policy = jsonencode({
        Version   = "2012-10-17"
        Statement = [
            {
                Action = [
                    "ec2:CopyImage",
                    "ec2:CopySnapshot",
                    "ec2:CreateImage",
                    "ec2:CreateKeyPair",
                    "ec2:CreateSecurityGroup",
                    "ec2:CreateTags",
                    "ec2:DeleteKeyPair",
                    "ec2:DeleteResourcePolicy",
                    "ec2:DeleteSecurityGroup",
                    "ec2:DeleteSnapshot",
                    "ec2:DeleteTags",
                    "ec2:DeregisterImage",
                    "ec2:DescribeAccountAttributes",
                    "ec2:DescribeAddresses",
                    "ec2:DescribeAvailabilityZones",
                    "ec2:DescribeCustomerGateways",
                    "ec2:DescribeDhcpOptions",
                    "ec2:DescribeEgressOnlyInternetGateways",
                    "ec2:DescribeFastSnapshotRestores",
                    "ec2:DescribeFlowLogs",
                    "ec2:DescribeHosts",
                    "ec2:DescribeImageAttribute",
                    "ec2:DescribeImages",
                    "ec2:DescribeInstanceAttribute",
                    "ec2:DescribeInstanceCreditSpecifications",
                    "ec2:DescribeInstanceStatus",
                    "ec2:DescribeInstanceTypeOfferings",
                    "ec2:DescribeInstanceTypes",
                    "ec2:DescribeInstances",
                    "ec2:DescribeInternetGateways",
                    "ec2:DescribeKeyPairs",
                    "ec2:DescribeLaunchTemplates",
                    "ec2:DescribeNatGateways",
                    "ec2:DescribeNetworkAcls",
                    "ec2:DescribeNetworkInterfaces",
                    "ec2:DescribePlacementGroups",
                    "ec2:DescribeRegions",
                    "ec2:DescribeReplaceRootVolumeTasks",
                    "ec2:DescribeRouteTables",
                    "ec2:DescribeSecurityGroupRules",
                    "ec2:DescribeSecurityGroups",
                    "ec2:DescribeSnapshotAttribute",
                    "ec2:DescribeSnapshotTierStatus",
                    "ec2:DescribeSnapshots",
                    "ec2:DescribeSubnets",
                    "ec2:DescribeTags",
                    "ec2:DescribeVolumeStatus",
                    "ec2:DescribeVolumes",
                    "ec2:DescribeVolumesModifications",
                    "ec2:DescribeVpcAttribute",
                    "ec2:DescribeVpcClassicLink",
                    "ec2:DescribeVpcClassicLinkDnsSupport",
                    "ec2:DescribeVpcEndpointServiceConfigurations",
                    "ec2:DescribeVpcEndpoints",
                    "ec2:DescribeVpcPeeringConnections",
                    "ec2:DescribeVpcs",
                    "ec2:DescribeVpnConnections",
                    "ec2:DescribeVpnGateways",
                    "ec2:GetEbsDefaultKmsKeyId",
                    "ec2:GetEbsEncryptionByDefault",
                    "ec2:GetLaunchTemplateData",
                    "ec2:GetResourcePolicy",
                    "ec2:GetSubnetCidrReservations",
                    "ec2:ModifyImageAttribute",
                    "ec2:PutResourcePolicy",
                    "ec2:RunInstances",
                    "ec2:StopInstances",
                    "ec2:TerminateInstances"
                ],
                Effect   = "Allow"
                Resource = "*"
            },
            {
                Action = [
                    "autoscaling:*",
                ],
                Effect   = "Allow"
                Resource = "*"
            }
        ]
    })
}

resource "aws_iam_policy" "Reduced_Power_User" {
    #checkov:skip=CKV_AWS_287
    #checkov:skip=CKV_AWS_288
    #checkov:skip=CKV_AWS_289
    #checkov:skip=CKV_AWS_290
    #checkov:skip=CKV_AWS_355
    count       = local.is_admin_account ? 1 : 0
    name        = "${var.policy_prefix}-Reduced-Power-User"
    description = "${var.policy_prefix}-Reduced-Power-User"

    policy = jsonencode({
        Version   = "2012-10-17"
        Statement = [
            {
                "Action" : [
                    "access-analyzer:*",
                    "application-autoscaling:*",
                    "autoscaling:*",
                    "aws-marketplace:*",
                    "billing:*",
                    "ce:*",
                    "cloudtrail:*",
                    "cloudwatch:*",
                    "compute-optimizer:*",
                    "dax:*",
                    "dynamodb:*",
                    "ecr-public:*",
                    "ecr:*",
                    "eks:*",
                    "elasticloadbalancing:*",
                    "events:*",
                    "imagebuilder:*",
                    "inspector2:*",
                    "lambda:GetAccountSettings",
                    "lambda:InvokeAsync",
                    "lambda:InvokeFunction",
                    "lambda:InvokeFunctionUrl",
                    "lambda:ListFunctions",
                    "lambda:UpdateFunctionCodeSigningConfig",
                    "resource-groups:*",
                    "route53resolver:*",
                    "s3:BypassGovernanceRetention",
                    "s3:CreateBucket",
                    "s3:DeleteObject",
                    "s3:DeleteObjectTagging",
                    "s3:DeleteObjectVersion",
                    "s3:DeleteObjectVersionTagging",
                    "s3:GetAccelerateConfiguration",
                    "s3:GetAccountPublicAccessBlock",
                    "s3:GetAnalyticsConfiguration",
                    "s3:GetBucketAcl",
                    "s3:GetBucketCORS",
                    "s3:GetBucketLogging",
                    "s3:GetBucketNotification",
                    "s3:GetBucketObjectLockConfiguration",
                    "s3:GetBucketOwnershipControls",
                    "s3:GetBucketPolicy",
                    "s3:GetBucketPolicyStatus",
                    "s3:GetBucketPublicAccessBlock",
                    "s3:GetBucketRequestPayment",
                    "s3:GetBucketTagging",
                    "s3:GetBucketVersioning",
                    "s3:GetBucketWebsite",
                    "s3:GetEncryptionConfiguration",
                    "s3:GetIntelligentTieringConfiguration",
                    "s3:GetInventoryConfiguration",
                    "s3:GetLifecycleConfiguration",
                    "s3:GetObject",
                    "s3:GetObjectAcl",
                    "s3:GetObjectAttributes",
                    "s3:GetObjectLegalHold",
                    "s3:GetObjectRetention",
                    "s3:GetObjectTagging",
                    "s3:GetObjectTorrent",
                    "s3:GetObjectVersion",
                    "s3:GetObjectVersionAcl",
                    "s3:GetObjectVersionAttributes",
                    "s3:GetObjectVersionForReplication",
                    "s3:GetObjectVersionTagging",
                    "s3:GetObjectVersionTorrent",
                    "s3:GetReplicationConfiguration",
                    "s3:GetStorageLensConfiguration",
                    "s3:GetStorageLensDashboard",
                    "s3:InitiateReplication",
                    "s3:ListAccessPoints",
                    "s3:ListAllMyBuckets",
                    "s3:ListBucket",
                    "s3:ListBucketVersions",
                    "s3:ListMultiRegionAccessPoints",
                    "s3:ListMultipartUploadParts",
                    "s3:ObjectOwnerOverrideToBucketOwner",
                    "s3:PutAccessPointPublicAccessBlock",
                    "s3:PutAnalyticsConfiguration",
                    "s3:PutBucketCORS",
                    "s3:PutBucketPublicAccessBlock",
                    "s3:PutBucketTagging",
                    "s3:PutBucketVersioning",
                    "s3:PutEncryptionConfiguration",
                    "s3:PutIntelligentTieringConfiguration",
                    "s3:PutInventoryConfiguration",
                    "s3:PutLifecycleConfiguration",
                    "s3:PutMetricsConfiguration",
                    "s3:PutObject",
                    "s3:PutObjectAcl",
                    "s3:PutObjectLegalHold",
                    "s3:PutObjectRetention",
                    "s3:PutObjectTagging",
                    "s3:PutObjectVersionAcl",
                    "s3:PutObjectVersionTagging",
                    "s3:PutReplicationConfiguration",
                    "s3:ReplicateDelete",
                    "s3:ReplicateObject",
                    "s3:ReplicateTags",
                    "s3:RestoreObject",
                    "secretsmanager:*",
                    "securityhub:*",
                    "servicecatalog:*",
                    "sqs:*",
                    "sts:*",
                    "support:*",
                    "tag:*",
                    "tax:*"
                ],
                "Effect" : "Allow",
                "Resource" : "*"
            },
            {
                "Action" : [
                    "account:ListRegions",
                    "iam:ListRoles",
                    "organizations:DescribeOrganization"
                ],
                "Effect" : "Allow",
                "Resource" : "*"
            }
        ]
    })
}

resource "aws_iam_policy" "SSM" {
    #checkov:skip=CKV_AWS_290
    #checkov:skip=CKV_AWS_355
    count       = local.is_admin_account ? 1 : 0
    name        = "${var.policy_prefix}-SSM"
    description = "${var.policy_prefix}-SSM"

    policy = jsonencode({
        Version   = "2012-10-17"
        Statement = [
            {
                "Action" : [
                    "cloudwatch:PutMetricData",
                    "ec2:DescribeInstanceStatus",
                    "logs:*",
                    # "ssm:*"
                ],
                "Effect" : "Allow",
                "Resource" : "*"
            },
            {
                "Action" : [
                    "iam:GetServiceLinkedRoleDeletionStatus"
                ],
                "Effect" : "Allow",
                "Resource" : "arn:${data.aws_partition.current.partition}:iam::*:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM*"
            }
        ]
    })
}

data "aws_iam_policy_document" "iam_manager" {
    count = local.is_admin_account  ? 0 : 1
    #checkov:skip=CKV_AWS_109: This is needed since we need to manage permissions
    #checkov:skip=CKV_AWS_110: This is needed since we need to manage other roles within our stack
    #checkov:skip=CKV_AWS_356
    statement {
        sid     = "AllowManagingRolesWithBoundary"
        actions = [
            "iam:AttachRolePolicy",
            "iam:CreateRole",
            "iam:DeleteRolePolicy",
            "iam:DetachRolePolicy",
            "iam:PutRolePermissionsBoundary",
            "iam:PutRolePolicy",
        ]
        resources = [
            "*"
        ]
    }

    statement {
        sid     = "AllowManagingOIDCProvider"
        actions = [
            "iam:AddClientIDToOpenIDConnectProvider",
            "iam:CreateOpenIDConnectProvider",
            "iam:DeleteOpenIDConnectProvider",
            "iam:GetOpenIDConnectProvider",
            "iam:RemoveClientIDFromOpenIDConnectProvider",
            "iam:TagOpenIDConnectProvider",
            "iam:UntagOpenIDConnectProvider",
            "iam:UpdateOpenIDConnectProviderThumbprint",
        ]
        resources = [
            "arn:${data.aws_partition.current.partition}:iam::*:oidc-provider/oidc.*"
        ]
    }

    statement {
        sid     = "AllowReadingIdentityProvider"
        actions = [
            "iam:ListOpenIDConnectProviders",
            "iam:ListSAMLProviders",
            "iam:ListOpenIDConnectProviderTags",
            "iam:GetOpenIDConnectProvider"
        ]
        resources = [
            "*"
        ]
    }

    statement {
        sid     = "AllowManagingRoles"
        actions = [
            "iam:DeleteRole",
            "iam:GetRole",
            "iam:GetRolePolicy",
            "iam:ListAttachedRolePolicies",
            "iam:ListInstanceProfilesForRole",
            "iam:ListRolePolicies",
            "iam:ListRoleTags",
            "iam:ListRoles",
            "iam:PassRole",
            "iam:TagRole",
            "iam:UntagRole",
            "iam:UpdateAssumeRolePolicy",
            "iam:UpdateRole",
            "iam:UpdateRoleDescription",
        ]
        resources = [
            "*"
        ]
    }

    statement {
        sid     = "AllowManagingGroups"
        actions = [
            "iam:GetGroup",
            "iam:GetGroupPolicy",
            "iam:DeleteGroup",
            "iam:DetachGroupPolicy",
            "iam:ListAttachedGroupPolicies",
            "iam:ListGroups",
            "iam:ListGroupPolicies",
            "iam:RemoveUserFromGroup"
        ]
        resources = [
            "*"
        ]
    }

    statement {
        sid     = "AllowManagingUsersWithBoundary"
        actions = [
            "iam:AttachUserPolicy",
            "iam:CreateUser",
            "iam:DetachUserPolicy",
            "iam:PutUserPermissionsBoundary",
            "iam:PutUserPolicy"
        ]
        resources = [
            "*"
        ]
    }

    statement {
        sid     = "AllowManagingUsers"
        actions = [
            "iam:AddUserToGroup",
            "iam:CreateGroup",
            "iam:DeleteUser",
            "iam:GetUser",
            "iam:GetUserPolicy",
            "iam:ListAttachedUserPolicies",
            "iam:ListGroupsForUser",
            "iam:ListUsers",
            "iam:ListUserPolicies",
            "iam:TagUser",
            "iam:UntagUser",
        ]
        resources = [
            "*"
        ]
    }

    statement {
        sid     = "AllowManagingPolicies"
        actions = [
            "iam:CreatePolicy",
            "iam:CreatePolicyVersion",
            "iam:DeletePolicy",
            "iam:DeletePolicyVersion",
            "iam:GetPolicy",
            "iam:TagPolicy",
            "iam:UntagPolicy",
            "iam:GetPolicyVersion",
            "iam:ListEntitiesForPolicy",
            "iam:ListPolicies",
            "iam:ListPolicyVersions",
            "iam:SetDefaultPolicyVersion",
        ]
        resources = [
            "*"
        ]
    }

    statement {
        sid     = "AllowManagingInstanceProfiles"
        actions = [
            "iam:AddRoleToInstanceProfile",
            "iam:CreateInstanceProfile",
            "iam:DeleteInstanceProfile",
            "iam:GetInstanceProfile",
            "iam:ListInstanceProfiles",
            "iam:RemoveRoleFromInstanceProfile",
            "iam:TagInstanceProfile",
            "iam:UntagInstanceProfile",
        ]
        resources = [
            "*"
        ]
    }
}

resource "aws_iam_policy" "iam_manager" {
    count  = local.is_admin_account  ? 0 : 1
    name   = "${var.role_name}-iam"
    path   = "/cawe/"
    policy = data.aws_iam_policy_document.iam_manager[count.index].json
}

resource "aws_iam_policy" "kms" {
    #checkov:skip=CKV_AWS_289: This is needed since we need to manage permissions
    #checkov:skip=CKV_AWS_288: This is needed since we need to manage permissions
    #checkov:skip=CKV_AWS_290: This is needed since we need to manage permissions
    #checkov:skip=CKV_AWS_355
    count = local.is_admin_account ? 1 : 0

    name        = "${var.policy_prefix}-kms"
    description = "${var.policy_prefix}-kms"

    policy = jsonencode({
        Version   = "2012-10-17"
        Statement = [
            {
                Action   = ["kms:Encrypt", "kms:Decrypt", "kms:GenerateDataKey"]
                Effect   = "Allow"
                Resource = "*"
            },
        ]
    })
}
resource "aws_iam_policy" "assume_role" {
    count = local.is_admin_account ? 1 : 0

    name = "${var.policy_prefix}-asumme-role"

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
