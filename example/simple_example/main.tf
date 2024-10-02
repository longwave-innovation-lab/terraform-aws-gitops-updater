
module "gitops_updater" {
  source = "../.."

  ecr_registry_triggers = [
    "demo_pipe"
  ]
  # codecommit_repo_arn = "arn:aws:codecommit:eu-west-1:687331130220:ll-k8s-lab01-apps"
  codecommit_repo_name = "ll-k8s-lab01-apps"
}