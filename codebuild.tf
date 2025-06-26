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
