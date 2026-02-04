data "aws_codecommit_repository" "gitops_repo" {
  count           = var.is_codecommit_repo ? 1 : 0
  repository_name = var.repo_name
}
