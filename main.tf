/**
 * # terraform-aws-gitops-updater
 *
 * Terraform module that creates a codebuild pipeline triggered by push on ECR registries.
 * 
 */

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_codecommit_repository" "gitops_repo" {
  repository_name = var.repo_name
}

data "aws_ecr_repository" "repositories" {
  for_each = toset(var.ecr_registry_triggers)
  name     = each.key
}

locals {
  ecr_arn_list = [for repo in data.aws_ecr_repository.repositories : repo.arn]
}
