locals {
  ecr_arn_list = [for repo in data.aws_ecr_repository.repositories : repo.arn]
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "random_id" "resource_suffix" {
  byte_length = 6
}
