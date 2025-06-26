variable "ecr_registry_triggers" {
  type        = list(string)
  description = "List of ECR repositories name which will trigger the pipeline"
}

variable "ecr_image_push_rule_name" {
  type        = string
  default     = "ecr-image-push-rule"
  description = "Name of the event rule for ECR image push."
}

variable "event_rule_target_id" {
  type        = string
  default     = "InvokeLambdaTriggerer"
  description = "ID of the target for the event rule"
}

variable "lambda_triggerer_name" {
  type        = string
  default     = "ECRPushListener"
  description = "Name of the lambda function which will trigger the pipeline."
}

variable "repo_name" {
  type        = string
  description = "Name of the CodeCommit repository which will be updated by the pipeline"
}

variable "codebuild_project_name" {
  type        = string
  default     = "GitopsUpdater"
  description = "Name of the CodeBuild project"
}

variable "build_minutes_timeout" {
  type        = number
  default     = 5
  description = "Number of minutes to timeout the build"
}

variable "codebuild_queue_minutes_timeout" {
  type        = number
  default     = 60
  description = "Number of minutes to timeout the codebuild queue"
}

variable "codebuild_comput_type" {
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
  description = "Compute type for the CodeBuild project. Available values: BUILD_GENERAL1_SMALL, BUILD_GENERAL1_MEDIUM, BUILD_GENERAL1_LARGE, BUILD_GENERAL1_2XLARGE"
}

variable "codebuild_image" {
  type        = string
  default     = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
  description = "Base image for the CodeBuild project"
}

variable "codebuild_container_type" {
  type        = string
  default     = "LINUX_CONTAINER"
  description = "Container type for the CodeBuild project. Available values: LINUX_CONTAINER, WINDOWS_CONTAINER"
}

variable "codebuild_buildspec_path" {
  type        = string
  default     = "buildspec.yaml"
  description = "Path to the buildspec file in the source repository"
}

variable "codebuild_git_user_mail" {
  type        = string
  default     = "codebuild.gitops_updater@lantechlongwave.it"
  description = "Email address of the git user which will end up in git commits"
}

variable "codebuild_git_user_name" {
  type        = string
  default     = "codebuild.gitops_updater"
  description = "Name of the git user which will end up in git commits"
}

variable "tags" {
  type = map(string)
  default = {
    "ServiceScope" = "Gitops Updater"
  }
  description = "Tags to apply to all resources"
}