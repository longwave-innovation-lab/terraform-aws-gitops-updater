
module "gitops_updater" {
  source = "../.."

  ecr_registry_triggers = [
    "registry_name"
  ]
  repo_name            = "repo_name"
  repo_owner           = "repo_owner"
  git_service_provider = "Generic"
  git_server_hostname  = "your.git.server"

  git_access_token_parameter = "/path/to/ssm/parameter"
}
