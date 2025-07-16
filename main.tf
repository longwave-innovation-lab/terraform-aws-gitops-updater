data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_codecommit_repository" "gitops_repo" {
  count           = var.is_codecommit_repo ? 1 : 0
  repository_name = var.repo_name
}

data "aws_ecr_repository" "repositories" {
  for_each = toset(var.ecr_registry_triggers)
  name     = each.key
}

resource "random_id" "resource_suffix" {
  byte_length = 6
}

locals {
  ecr_arn_list = [for repo in data.aws_ecr_repository.repositories : repo.arn]
}
