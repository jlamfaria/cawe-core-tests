resource "aws_iam_role" "role" {
  name                 = var.role_name
  path                 = "/cawe/"
  max_session_duration = local.max_session_duration
  description          = "Role created by Connected CICD - CAWE"
  assume_role_policy   = local.is_admin_account ? data.aws_iam_policy_document.assume_role_policy_oidc[0].json : data.aws_iam_policy_document.assume_role_policy.json
  permissions_boundary = local.permissions_boundary
}

################################# roles for admin account #################################
resource "aws_iam_role_policy_attachment" "systems_manager_admin" {
  count = local.is_admin_account ? 1 : 0
  policy_arn = aws_iam_policy.SSM[count.index].arn
  role       = aws_iam_role.role.name
}

resource "aws_iam_role_policy_attachment" "reduced_power_user_admin" {
  count = local.is_admin_account ? 1 : 0
  policy_arn = aws_iam_policy.Reduced_Power_User[count.index].arn
  role       = aws_iam_role.role.name
}

resource "aws_iam_role_policy_attachment" "ec2_manager_admin" {
  count = local.is_admin_account ? 1 : 0
  policy_arn = aws_iam_policy.EC2[count.index].arn
  role       = aws_iam_role.role.name
}

################################# roles for non-admin accounts #################################
resource "aws_iam_role_policy_attachment" "systems_manager" {
  count = local.is_admin_account ? 0 : 1
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonSSMFullAccess"
  role       = aws_iam_role.role.name
}

resource "aws_iam_role_policy_attachment" "power_user" {
  count = local.is_admin_account ? 0 : 1
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/PowerUserAccess"
  role       = aws_iam_role.role.name
}

resource "aws_iam_role_policy_attachment" "ec2_manager" {
  count = local.is_admin_account ? 0 : 1
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEC2FullAccess"
  role       = aws_iam_role.role.name
}

resource "aws_iam_role_policy_attachment" "iam_manager" {
  count = local.is_admin_account ? 0 : 1
  policy_arn = aws_iam_policy.iam_manager[count.index].arn
  role       = aws_iam_role.role.name
}

###### OPEN ID CONNECT #################
# Open ID Connect provider for Github in China is created by the TSP Cloud Team through the ITSM
resource "aws_iam_openid_connect_provider" "github" {
  count           = local.is_admin_account && !local.is_china_account  ? 1 : 0
  url             = var.oidc_provider_url
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github.certificates[1].sha1_fingerprint]
}

resource "aws_iam_role_policy_attachment" "kms-attach" {
  count = local.is_admin_account ? 1 : 0

  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.kms[count.index].arn
}
