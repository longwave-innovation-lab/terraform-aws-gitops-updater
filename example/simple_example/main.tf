
module "gitops_updater" {
  source = "../.."

  ecr_registry_triggers = [
    "demo_pipe"
  ]
  codecommit_repo_name = "ll-k8s-lab01-apps"
}