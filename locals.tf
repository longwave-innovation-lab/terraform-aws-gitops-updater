locals {
  git_services = {
    github     = "GitHub"
    generic    = "Generic"
    codecommit = "CodeCommit"
  }
  all_git_services = values(local.git_services)

  codebuild_env_vars = {
    codecommit = []
    github = [
      {
        name  = "GITHUB_APP_ID"
        type  = "PARAMETER_STORE"
        value = var.github_app_id_parameter
      },
      {
        name  = "GITHUB_APP_INSTALLATION_ID"
        type  = "PARAMETER_STORE"
        value = var.github_app_installation_id_parameter
      },
      {
        name  = "GITHUB_APP_PRIVATE_KEY"
        type  = "PARAMETER_STORE"
        value = var.github_app_private_key_parameter
      }
    ]
    generic = [
      {
        name  = "GIT_ACCESS_TOKEN"
        type  = "PARAMETER_STORE"
        value = var.git_access_token_parameter
      },
      {
        name  = "GIT_SERVER_URL"
        type  = "PLAINTEXT"
        value = var.git_server_hostname
      }
    ]
  }
}
