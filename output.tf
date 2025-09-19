output "codebuild_updater_project_arn" {
  value       = aws_codebuild_project.cb_project.arn
  description = "Codebuild updater project arn"
}

output "codebuild_updater_project_name" {
  value       = aws_codebuild_project.cb_project.name
  description = "Codebuild updater project name"
}

output "codebuild_updater_role_arn" {
  value       = aws_iam_role.codebuild_role.arn
  description = "Codebuild updater role arn"
}

output "codebuild_updater_role_name" {
  value       = aws_iam_role.codebuild_role.name
  description = "Codebuild updater role name"
}

output "lambda_triggerer_arn" {
  value       = aws_lambda_function.codebuild_triggerer.arn
  description = "Arn of the Lambda function that triggers Codebuild"
}

output "lambda_triggerer_function_name" {
  value       = aws_lambda_function.codebuild_triggerer.function_name
  description = "Function name of the Lambda function that triggers Codebuild"
}