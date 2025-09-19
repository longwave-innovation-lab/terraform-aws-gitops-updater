locals {
  github_env_vars = var.is_codecommit_repo ? [] : [{
    name  = "GITHUB_APP_ID"
    type  = "PARAMETER_STORE"
    value = var.github_app_id_parameter
    }, {
    name  = "GITHUB_APP_INSTALL_ID"
    type  = "PARAMETER_STORE"
    value = var.github_app_installation_id_parameter
    }, {
    name  = "GITHUB_APP_PRIVATE_KEY"
    type  = "PARAMETER_STORE"
    value = var.github_app_private_key_parameter
    }
  ]
}

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
  tags               = var.tags
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
      "arn:aws:logs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${var.codebuild_project_name}*",
      "arn:aws:logs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${var.codebuild_project_name}"
    ]
  }
}

resource "aws_iam_policy" "codebuild_default" {
  policy = data.aws_iam_policy_document.codebuild_default_policy.json
}

resource "aws_iam_role_policy_attachment" "codebuild_default" {
  policy_arn = aws_iam_policy.codebuild_default.arn
  role       = aws_iam_role.codebuild_role.name
}

data "aws_iam_policy_document" "codecommit" {
  count = var.is_codecommit_repo ? 1 : 0

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
      data.aws_codecommit_repository.gitops_repo[0].arn
    ]
  }
}

resource "aws_iam_policy" "codecommit" {
  count  = var.is_codecommit_repo ? 1 : 0
  policy = data.aws_iam_policy_document.codecommit[0].json
}

resource "aws_iam_role_policy_attachment" "codecommit" {
  count      = var.is_codecommit_repo ? 1 : 0
  policy_arn = aws_iam_policy.codecommit[0].arn
  role       = aws_iam_role.codebuild_role.name
}

data "aws_iam_policy_document" "read_github_app_ssm" {
  count = var.is_codecommit_repo ? 0 : 1
  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameters"
    ]
    resources = [
      "arn:aws:ssm:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:parameter${var.github_app_id_parameter}",
      "arn:aws:ssm:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:parameter${var.github_app_installation_id_parameter}",
      "arn:aws:ssm:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:parameter${var.github_app_private_key_parameter}"
    ]
  }
}

resource "aws_iam_policy" "read_github_app_ssm" {
  count  = var.is_codecommit_repo ? 0 : 1
  policy = data.aws_iam_policy_document.read_github_app_ssm[0].json
}

resource "aws_iam_role_policy_attachment" "read_github_app_ssm" {
  count      = var.is_codecommit_repo ? 0 : 1
  policy_arn = aws_iam_policy.read_github_app_ssm[0].arn
  role       = aws_iam_role.codebuild_role.name
}

data "local_file" "buildspec" {
  filename = var.is_codecommit_repo ? "${path.module}/conf/buildspec.yaml" : "${path.module}/conf/buildspec-github.yaml"
}

resource "aws_codebuild_project" "cb_project" {
  name           = "${var.codebuild_project_name}-${random_id.resource_suffix.hex}"
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
      value = var.repo_name
    }

    environment_variable {
      name  = "GITOPS_REPO_OWNER"
      type  = "PLAINTEXT"
      value = var.repo_owner != null ? var.repo_owner : ""
    }

    dynamic "environment_variable" {
      for_each = local.github_env_vars
      content {
        name  = environment_variable.value.name
        type  = environment_variable.value.type
        value = environment_variable.value.value
      }
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
