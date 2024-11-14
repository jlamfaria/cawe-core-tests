data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "spaceship-lambda_assume_policy" {
    statement {
        effect = "Allow"

        principals {
            type        = "Service"
            identifiers = ["lambda.amazonaws.com"]
        }

        actions = ["sts:AssumeRole"]
    }
}

// Policy document for the Lambda function to publish to the SNS topic
data "aws_iam_policy_document" "spaceship-lambda-sns_policy-document" {
    statement {
        effect = "Allow"

        actions = ["sns:Publish"]

        resources = [var.sns_topic_arn]
    }
}

// Policy document for the Lambda function to retrieve ECR image from the repository
data "aws_iam_policy_document" "spaceship-lambda-ecr_policy-document" {
    statement {
        effect = "Allow"

        actions = [
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "ecr:BatchCheckLayerAvailability"
        ]

        resources = [var.ecr_repository_arn]
    }
}

data "aws_iam_policy_document" "spaceship-lambda-ec2_policy-document" {
    statement {
        effect = "Allow"

        actions = [
            "ec2:DescribeNetworkInterfaces",
            "ec2:CreateNetworkInterface",
            "ec2:DeleteNetworkInterface",
            "ec2:AttachNetworkInterface"
        ]

        resources = ["*"]
    }
}

data "aws_iam_policy_document" "spaceship-lambda-logs_policy-document" {
    statement {
        effect = "Allow"

        actions = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ]

        resources = ["*"]
    }
}
