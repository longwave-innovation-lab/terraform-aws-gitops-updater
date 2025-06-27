
module "gitops_updater" {
  source = "../.."

  ecr_registry_triggers = [
    "ipc-aws-docs"
  ]
  repo_name                            = "ipc-eks-apps-platform"
  repo_owner                           = "ImpresaPizzarotti"
  is_codecommit_repo                   = false
  github_app_id_parameter              = "/lw/gitops/github_app/id"
  github_app_installation_id_parameter = "/lw/gitops/github_app/installation_id"
  github_app_private_key_parameter     = "/lw/gitops/github_app/private_key"
}