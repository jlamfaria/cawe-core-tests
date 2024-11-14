resource "aws_iam_role" "runner-cost-exporter-lambda" {
  name          = "runner-cost-exporter-lambda"
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy_attachment" "attachment" {
  name       = "test-attachment"
  roles      = [aws_iam_role.runner-cost-exporter-lambda.name]
  policy_arn = aws_iam_policy.runner-cost-exporter-lambda-policy.arn
}

resource "aws_iam_policy" "runner-cost-exporter-lambda-policy" {
  #checkov:skip=CKV_AWS_355
  #checkov:skip=CKV_AWS_290
  name        = "runner-cost-exporter-lambda"
  description = "runner-cost-exporter-lambda"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action = [
          "ce:GetCostAndUsage",
          "ce:GetReservationPurchaseRecommendation",
          "ce:GetPreferences",
          "ce:ListSavingsPlansPurchaseRecommendationGeneration",
          "ce:ListTagsForResource",
          "ce:GetReservationUtilization",
          "ce:GetCostCategories",
          "ce:GetSavingsPlansPurchaseRecommendation",
          "ce:GetSavingsPlansUtilizationDetails",
          "ce:GetDimensionValues",
          "ce:GetAnomalySubscriptions",
          "ce:DescribeReport",
          "ce:GetReservationCoverage",
          "ce:GetAnomalyMonitors",
          "ce:GetUsageForecast",
          "ce:DescribeNotificationSubscription",
          "ce:DescribeCostCategoryDefinition",
          "ce:GetRightsizingRecommendation",
          "ce:GetSavingsPlansUtilization",
          "ce:GetAnomalies",
          "ce:ListCostCategoryDefinitions",
          "ce:GetCostForecast",
          "ce:GetCostAndUsageWithResources",
          "ce:ListCostAllocationTags",
          "ce:GetSavingsPlanPurchaseRecommendationDetails",
          "ce:GetSavingsPlansCoverage",
          "ce:GetConsoleActionSetEnforced",
          "ce:GetTags"
        ],
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "ec2:DescribeNetworkInterfaces",
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeInstances",
          "ec2:AttachNetworkInterface"
        ],
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}
