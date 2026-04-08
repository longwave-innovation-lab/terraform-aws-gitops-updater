
module "gitops_updater" {
  source = "../.."

  ecr_registry_triggers = [
    "test-lifecycle-ecr"
  ]
  repo_name                            = "my-repository"
  repo_owner                           = "MyCompanyOrg"
  git_service_provider                 = "GitHub"
  github_app_id_parameter              = "/github_app/id"
  github_app_installation_id_parameter = "/github_app/installation_id"
  github_app_private_key_parameter     = "/github_app/private_key"
}
