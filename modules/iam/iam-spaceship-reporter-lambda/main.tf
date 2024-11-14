resource "aws_iam_role" "spaceship-reporter-lambda-role" {
  name                 = "spaceship-reporter-lambda-role"
  path                 = "/spaceship/"
  ##max_session_duration = local.max_session_duration
  description          = "Role created by Spaceship"
  assume_role_policy   = data.aws_iam_policy_document.spaceship-lambda_assume_policy.json
  tags = local.tags
}

resource "aws_iam_policy" "spaceship-lambda-sns-policy" {
  name        = "spaceship-lambda-sns-policy"
  description = "Spaceship Policy for Lambda microservice to publish to SNS"

  policy = data.aws_iam_policy_document.spaceship-lambda-sns_policy-document.json
}

resource "aws_iam_role_policy_attachment" "paceship-lambda-sns-policy-attachment" {
  policy_arn = aws_iam_policy.spaceship-lambda-sns-policy.arn
  role       = aws_iam_role.spaceship-reporter-lambda-role.name
}

resource "aws_iam_policy" "spaceship-lambda-ecr-policy" {
  name        = "spaceship-lambda-ecr-policy"
  description = "Spaceship Policy for Lambda microservice to pull images from ECR"

  policy = data.aws_iam_policy_document.spaceship-lambda-ecr_policy-document.json
}

resource "aws_iam_role_policy_attachment" "spaceship-lambda-ecr-policy-attachment" {
  policy_arn = aws_iam_policy.spaceship-lambda-ecr-policy.arn
  role       = aws_iam_role.spaceship-reporter-lambda-role.name
}

resource "aws_iam_policy" "spaceship-lambda-ec2-policy" {
  name        = "spaceship-lambda-ec2-policy"
  description = "Spaceship Policy for Lambda microservice to create EC2 NI"

  policy = data.aws_iam_policy_document.spaceship-lambda-ec2_policy-document.json
}

resource "aws_iam_role_policy_attachment" "spaceship-lambda-ec2-policy-attachment" {
  policy_arn = aws_iam_policy.spaceship-lambda-ec2-policy.arn
  role       = aws_iam_role.spaceship-reporter-lambda-role.name
}


resource "aws_iam_policy" "spaceship-lambda-logs-policy" {
  name        = "spaceship-lambda-logs-policy"
  description = "Spaceship Policy for Lambda microservice to create EC2 NI"

  policy = data.aws_iam_policy_document.spaceship-lambda-logs_policy-document.json
}

resource "aws_iam_role_policy_attachment" "spaceship-lambda-logs-policy-attachment" {
  policy_arn = aws_iam_policy.spaceship-lambda-logs-policy.arn
  role       = aws_iam_role.spaceship-reporter-lambda-role.name
}
