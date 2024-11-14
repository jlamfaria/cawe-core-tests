resource "aws_iam_role" "role" {
    name                 = var.role_name
    path                 = "/cawe/"
    max_session_duration = local.max_session_duration
    description          = "Role created by Connected CICD - CAWE"
    assume_role_policy   = data.aws_iam_policy_document.assume_role_policy.json
    permissions_boundary = local.permissions_boundary
}

resource "aws_iam_role_policy_attachment" "AmazonSSMFullAccess" {
    count      = local.is_admin_account ? 0 : 1
    policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonSSMFullAccess"
    role       = aws_iam_role.role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2FullAccess" {
    count      = local.is_admin_account ? 0 : 1
    policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEC2FullAccess"
    role       = aws_iam_role.role.name
}

resource "aws_iam_role_policy_attachment" "AWSSupportAccess" {
    policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AWSSupportAccess"
    role       = aws_iam_role.role.name
}

resource "aws_iam_role_policy_attachment" "ReadOnlyAccess" {
    policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/ReadOnlyAccess"
    role       = aws_iam_role.role.name
}


resource "aws_iam_role_policy_attachment" "UserRODenyAccessToResources" {
    policy_arn = aws_iam_policy.UserRODenyAccessToResources.arn
    role       = aws_iam_role.role.name
}


resource "aws_iam_role_policy_attachment" "UserROPolicyDiff" {
    policy_arn = aws_iam_policy.UserROPolicyDiff.arn
    role       = aws_iam_role.role.name
}
