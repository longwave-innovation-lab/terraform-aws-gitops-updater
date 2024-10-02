<!-- BEGIN_TF_DOCS -->
# terraform-aws-gitops-updater

Terraform module that creates a codebuild pipeline triggered by push on ECR registries.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.69.0 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.ecr_image_push](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.lambda_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_codebuild_project.cb_project](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_iam_role.codebuild_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.lambda_function_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.codebuild_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.trigger_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.ecr_lookup_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lambda_basic_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.codebuild_triggerer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.allow_eventbridge](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_sqs_queue.evnt_rule_target_dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [archive_file.lambda](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_codecommit_repository.gitops_repo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/codecommit_repository) | data source |
| [aws_iam_policy_document.assume_role_codebuild](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.codebuild_default_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lambda_function_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [local_file.buildspec](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_codecommit_repo_name"></a> [codecommit\_repo\_name](#input\_codecommit\_repo\_name) | Name of the CodeCommit repository which will be updated by the pipeline | `string` | n/a | yes |
| <a name="input_ecr_registry_triggers"></a> [ecr\_registry\_triggers](#input\_ecr\_registry\_triggers) | List of ECR repositories ARN which will trigger the pipeline | `list(string)` | n/a | yes |
| <a name="input_build_minutes_timeout"></a> [build\_minutes\_timeout](#input\_build\_minutes\_timeout) | Number of minutes to timeout the build | `number` | `5` | no |
| <a name="input_codebuild_buildspec_path"></a> [codebuild\_buildspec\_path](#input\_codebuild\_buildspec\_path) | Path to the buildspec file in the source repository | `string` | `"buildspec.yaml"` | no |
| <a name="input_codebuild_comput_type"></a> [codebuild\_comput\_type](#input\_codebuild\_comput\_type) | Compute type for the CodeBuild project. Available values: BUILD\_GENERAL1\_SMALL, BUILD\_GENERAL1\_MEDIUM, BUILD\_GENERAL1\_LARGE, BUILD\_GENERAL1\_2XLARGE | `string` | `"BUILD_GENERAL1_SMALL"` | no |
| <a name="input_codebuild_container_type"></a> [codebuild\_container\_type](#input\_codebuild\_container\_type) | Container type for the CodeBuild project. Available values: LINUX\_CONTAINER, WINDOWS\_CONTAINER | `string` | `"LINUX_CONTAINER"` | no |
| <a name="input_codebuild_git_user_mail"></a> [codebuild\_git\_user\_mail](#input\_codebuild\_git\_user\_mail) | Email address of the git user which will end up in git commits | `string` | `"codebuild.gitops_updater@lantechlongwave.it"` | no |
| <a name="input_codebuild_git_user_name"></a> [codebuild\_git\_user\_name](#input\_codebuild\_git\_user\_name) | Name of the git user which will end up in git commits | `string` | `"codebuild.gitops_updater"` | no |
| <a name="input_codebuild_image"></a> [codebuild\_image](#input\_codebuild\_image) | Base image for the CodeBuild project | `string` | `"aws/codebuild/amazonlinux2-x86_64-standard:4.0"` | no |
| <a name="input_codebuild_project_name"></a> [codebuild\_project\_name](#input\_codebuild\_project\_name) | Name of the CodeBuild project | `string` | `"GitopsUpdater"` | no |
| <a name="input_codebuild_queue_minutes_timeout"></a> [codebuild\_queue\_minutes\_timeout](#input\_codebuild\_queue\_minutes\_timeout) | Number of minutes to timeout the codebuild queue | `number` | `60` | no |
| <a name="input_ecr_image_push_rule_name"></a> [ecr\_image\_push\_rule\_name](#input\_ecr\_image\_push\_rule\_name) | Name of the event rule for ECR image push. | `string` | `"ecr-image-push-rule"` | no |
| <a name="input_event_rule_target_id"></a> [event\_rule\_target\_id](#input\_event\_rule\_target\_id) | ID of the target for the event rule | `string` | `"InvokeLambdaTriggerer"` | no |
| <a name="input_lambda_triggerer_name"></a> [lambda\_triggerer\_name](#input\_lambda\_triggerer\_name) | Name of the lambda function which will trigger the pipeline. | `string` | `"ECRPushListener"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->