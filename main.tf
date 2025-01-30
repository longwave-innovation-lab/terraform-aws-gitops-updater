/**
 * # terraform-aws-gitops-updater
 *
 * Terraform module that creates a codebuild pipeline triggered by push on ECR registries.
 * 
 */

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_codecommit_repository" "gitops_repo" {
  repository_name = var.codecommit_repo_name
}

data "aws_ecr_repository" "repositories" {
  for_each = toset(var.ecr_registry_triggers)
  name     = each.key
}

locals {
  ecr_arn_list = [for repo in data.aws_ecr_repository.repositories : repo.arn]
}

#region CodeBuild

data "aws_iam_policy_document" "assume_role_codebuild" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "codebuild_role" {
  name_prefix        = substr("${var.codebuild_project_name}", 0, 38)
  assume_role_policy = data.aws_iam_policy_document.assume_role_codebuild.json
  tags = var.tags
}

# Needed to lookup if images was already present or not
resource "aws_iam_role_policy_attachment" "ecr_lookup_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
  role       = aws_iam_role.codebuild_role.name
}

data "aws_iam_policy_document" "codebuild_default_policy" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${var.codebuild_project_name}*",
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${var.codebuild_project_name}"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "codecommit:GitPull",
      "codecommit:CreateCommit",
      "codecommit:GitPush",
      "codecommit:Describe*",
      "codecommit:List*",
    ]
    resources = [
      data.aws_codecommit_repository.gitops_repo.arn
    ]
  }
}

resource "aws_iam_role_policy" "codebuild_default" {
  role   = aws_iam_role.codebuild_role.name
  policy = data.aws_iam_policy_document.codebuild_default_policy.json
}

data "local_file" "buildspec" {
  filename = "${path.module}/conf/buildspec.yaml"
}

resource "aws_codebuild_project" "cb_project" {
  name           = var.codebuild_project_name
  build_timeout  = var.build_minutes_timeout
  queued_timeout = var.codebuild_queue_minutes_timeout
  service_role   = aws_iam_role.codebuild_role.arn
  description    = "CodeBuild project created with the purpose of updating the git repo each time an images is pushes to ECR"
  environment {
    compute_type                = var.codebuild_comput_type
    image                       = var.codebuild_image
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false
    type                        = var.codebuild_container_type

    environment_variable {
      name  = "GIT_MAIL"
      type  = "PLAINTEXT"
      value = var.codebuild_git_user_mail
    }

    environment_variable {
      name  = "GIT_USERNAME"
      type  = "PLAINTEXT"
      value = var.codebuild_git_user_name
    }

    environment_variable {
      name  = "GITOPS_REPO_NAME"
      type  = "PLAINTEXT"
      value = data.aws_codecommit_repository.gitops_repo.repository_name
    }
  }

  source {
    type         = "NO_SOURCE"
    insecure_ssl = false
    buildspec    = data.local_file.buildspec.content
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type = "NO_CACHE"
  }
  tags = var.tags
}

# aws codebuild batch-get-projects --names TepK8sAppsGitOpsSynchEF1D90-vPWKPSV49Jq2 --profile tep


#endregion CodeBuild

#region Lambda
resource "aws_iam_role" "lambda_function_role" {
  name_prefix = "${var.lambda_triggerer_name}_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_function_role.name
}

data "aws_iam_policy_document" "lambda_function_policy_document" {

  statement {
    effect = "Allow"
    actions = [
      "ecr:DescribeImages"
    ]
    resources = local.ecr_arn_list
  }

  statement {
    effect = "Allow"
    actions = [
      "codebuild:StartBuild"
    ]
    resources = [
      aws_codebuild_project.cb_project.arn
    ]
  }
}

resource "aws_iam_role_policy" "trigger_policy" {
  role   = aws_iam_role.lambda_function_role.name
  policy = data.aws_iam_policy_document.lambda_function_policy_document.json
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/lambda_code/app.py"
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "codebuild_triggerer" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename         = "lambda_function_payload.zip"
  function_name    = var.lambda_triggerer_name
  role             = aws_iam_role.lambda_function_role.arn
  handler          = "app.lambda_handler"
  description      = "Lambda function that will trigger Gitops update Codebuild Project for CICD"
  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime       = "python3.12"
  architectures = ["arm64"]
  timeout       = 10
  memory_size   = 256

  environment {
    variables = {
      "CODEBUILD_PROJECT_NAME" = aws_codebuild_project.cb_project.name
    }
  }
  tags = var.tags
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.codebuild_triggerer.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ecr_image_push.arn
}
#endregion Lambda

#region EventRule

resource "aws_cloudwatch_event_rule" "ecr_image_push" {
  name        = var.ecr_image_push_rule_name
  description = "Capture ECR image push events for specific repositories"

  event_pattern = jsonencode({
    source      = ["aws.ecr"]
    detail-type = ["ECR Image Action"]
    region      = [data.aws_region.current.name]
    detail = {
      action-type     = ["PUSH"]
      repository-name = var.ecr_registry_triggers
    }
  })
  tags = var.tags
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.ecr_image_push.name
  target_id = var.event_rule_target_id
  arn       = aws_lambda_function.codebuild_triggerer.arn

  retry_policy {
    maximum_retry_attempts       = 3
    maximum_event_age_in_seconds = 60
  }

  dead_letter_config {
    arn = aws_sqs_queue.evnt_rule_target_dlq.arn
  }
}

resource "aws_sqs_queue" "evnt_rule_target_dlq" {
  name = "${var.event_rule_target_id}-dlq"
  tags = var.tags
}

#endregion EventRule
