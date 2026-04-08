data "aws_codecommit_repository" "gitops_repo" {
  count           = var.git_service_provider == local.git_services.codecommit ? 1 : 0
  repository_name = var.repo_name
}
