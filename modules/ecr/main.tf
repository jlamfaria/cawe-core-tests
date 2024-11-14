resource "aws_ecr_repository" "ecr-core" {
  name                 = var.repo_name
  image_tag_mutability = var.image_tag_mutability

  encryption_configuration {
        encryption_type = "KMS"
    }

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "policy" {
  repository = aws_ecr_repository.ecr-core.name

  policy = jsonencode(
    {
      rules : [
        {
          rulePriority = 1,
          description  = "Keep last 3 images dev",
          selection    = {
            tagStatus     = "tagged",
            tagPrefixList = ["dev-v"],
            countType     = "imageCountMoreThan",
            countNumber   = 3
          },
          action = {
            type = "expire"
          }
        }, {
          rulePriority = 2,
          description  = "Keep last 3 images int",
          selection    = {
            tagStatus     = "tagged",
            tagPrefixList = ["int-v"],
            countType     = "imageCountMoreThan",
            countNumber   = 3
          },
          action = {
            type = "expire"
          }
        },
        {
          rulePriority = 3,
          description  = "Keep last 3 images prd",
          selection    = {
            tagStatus     = "tagged",
            tagPrefixList = ["prd-v"],
            countType     = "imageCountMoreThan",
            countNumber   = 3
          },
          action = {
            type = "expire"
          }
        }
      ]
    })

}

