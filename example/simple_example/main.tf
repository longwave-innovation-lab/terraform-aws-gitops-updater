
module "gitops_updater" {
  source = "../.."

  ecr_registry_triggers = [
    "arn:aws:ecr:eu-west-1:687331130220:repository/demo_pipe"
  ]
  codecommit_repo_arn = "arn:aws:codecommit:eu-west-1:687331130220:ll-k8s-lab01-apps"
}

# aws codecommit get-repository --repository-name ll-k8s-lab01-apps --query 'repositoryMetadata.Arn' --output text --profile innovation
