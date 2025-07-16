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
  output_path = "${path.module}/lambda_function_payload.zip"
}

resource "aws_lambda_function" "codebuild_triggerer" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename         = "${path.module}/lambda_function_payload.zip"
  function_name    = "${var.lambda_triggerer_name}-${random_id.resource_suffix.hex}"
  role             = aws_iam_role.lambda_function_role.arn
  handler          = "app.lambda_handler"
  description      = "Lambda function that will trigger Gitops update Codebuild Project for CICD"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime          = "python3.12"
  architectures    = ["arm64"]
  timeout          = 10
  memory_size      = 256
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