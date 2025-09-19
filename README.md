# terraform-aws-gitops-updater <!-- omit in toc -->

Terraform module that creates a codebuild pipeline triggered by push on ECR registries.

- [Repository Types](#repository-types)
  - [Codecommit](#codecommit)
  - [Github](#github)
- [Requirements](#requirements)
- [Providers](#providers)
- [Modules](#modules)
- [Resources](#resources)
- [Inputs](#inputs)
- [Outputs](#outputs)

## Repository Types

### Codecommit

This module has baked in support for codecommit repositories inside the same account withuot any additional work.

Just set the `is_codecommit_repo` to `true`, give the name of the repo to `repo_name` and let the module handle all the permissions headaches.

### Github

When setting `is_codecommit_repo` to `false` this module will think you are planning on using a Github Repo, it does **NOT** support any other platform at the moment.

To make this work it uses the [Github Apps](https://docs.github.com/en/apps/creating-github-apps/about-creating-github-apps/about-creating-github-apps) authentication method.

Create a github app with the right configuration just:

1. [Create a Github App](https://docs.github.com/en/apps/creating-github-apps/registering-a-github-app/registering-a-github-app) in you own account or in the Organization account.
    > When creating for an Organization you **MUST** be the owner
    > You can use whatever as a website url, no callback url is needed and neither webhook active
2. **Give Read and Write permission on Contents**
3. Make it available only in your account or organization
4. **Save the App Id somethere**
5. Once created generate a [private key](https://docs.github.com/en/apps/creating-github-apps/authenticating-with-a-github-app/managing-private-keys-for-github-apps#about-private-keys-for-github-apps) and **save it somewhere**
6. [Install it](https://docs.github.com/en/apps/using-github-apps/installing-your-own-github-app)
7. [Get the installation id](https://stackoverflow.com/questions/74462420/where-can-we-find-github-apps-installation-id) and **save it somewhere**
8. Copy the value of the App ID, Installation ID and the Private Key in the [Parameter Store](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html)
9. Use these variables to give the module the right SSM parameter where you stored those values:
    - `github_app_id_parameter`
    - `github_app_installation_id_parameter`
    - `github_app_private_key_parameter`
10. Enjoy!

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | >= 2.7.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | >= 2.7.0 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.0.0 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.ecr_image_push](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.lambda_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_codebuild_project.cb_project](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_iam_policy.codebuild_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.codecommit](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.read_github_app_ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.codebuild_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.lambda_function_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.trigger_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.codebuild_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.codecommit](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecr_lookup_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lambda_basic_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.read_github_app_ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.codebuild_triggerer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.allow_eventbridge](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_sqs_queue.evnt_rule_target_dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [random_id.resource_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [archive_file.lambda](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_codecommit_repository.gitops_repo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/codecommit_repository) | data source |
| [aws_ecr_repository.repositories](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecr_repository) | data source |
| [aws_iam_policy_document.assume_role_codebuild](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.codebuild_default_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.codecommit](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lambda_function_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.read_github_app_ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [local_file.buildspec](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ecr_registry_triggers"></a> [ecr\_registry\_triggers](#input\_ecr\_registry\_triggers) | List of ECR repositories name which will trigger the pipeline | `list(string)` | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | Name of therepository which will be updated by the pipeline | `string` | n/a | yes |
| <a name="input_build_minutes_timeout"></a> [build\_minutes\_timeout](#input\_build\_minutes\_timeout) | Number of minutes to timeout the build | `number` | `5` | no |
| <a name="input_codebuild_buildspec_path"></a> [codebuild\_buildspec\_path](#input\_codebuild\_buildspec\_path) | Path to the buildspec file in the source repository | `string` | `"buildspec.yaml"` | no |
| <a name="input_codebuild_comput_type"></a> [codebuild\_comput\_type](#input\_codebuild\_comput\_type) | Compute type for the CodeBuild project. Available values: BUILD\_GENERAL1\_SMALL, BUILD\_GENERAL1\_MEDIUM, BUILD\_GENERAL1\_LARGE, BUILD\_GENERAL1\_2XLARGE | `string` | `"BUILD_GENERAL1_SMALL"` | no |
| <a name="input_codebuild_container_type"></a> [codebuild\_container\_type](#input\_codebuild\_container\_type) | Container type for the CodeBuild project. Available values: LINUX\_CONTAINER, WINDOWS\_CONTAINER | `string` | `"LINUX_CONTAINER"` | no |
| <a name="input_codebuild_git_user_mail"></a> [codebuild\_git\_user\_mail](#input\_codebuild\_git\_user\_mail) | Email address of the git user which will end up in git commits | `string` | `"codebuild.gitops_updater@longwave.it"` | no |
| <a name="input_codebuild_git_user_name"></a> [codebuild\_git\_user\_name](#input\_codebuild\_git\_user\_name) | Name of the git user which will end up in git commits | `string` | `"codebuild.gitops_updater"` | no |
| <a name="input_codebuild_image"></a> [codebuild\_image](#input\_codebuild\_image) | Base image for the CodeBuild project. To list every image available use the command `aws codebuild list-curated-environment-images`. | `string` | `"aws/codebuild/amazonlinux2-x86_64-standard:5.0"` | no |
| <a name="input_codebuild_project_name"></a> [codebuild\_project\_name](#input\_codebuild\_project\_name) | Name of the CodeBuild project | `string` | `"GitopsUpdater"` | no |
| <a name="input_codebuild_queue_minutes_timeout"></a> [codebuild\_queue\_minutes\_timeout](#input\_codebuild\_queue\_minutes\_timeout) | Number of minutes to timeout the codebuild queue | `number` | `60` | no |
| <a name="input_ecr_image_push_rule_name"></a> [ecr\_image\_push\_rule\_name](#input\_ecr\_image\_push\_rule\_name) | Name of the event rule for ECR image push. | `string` | `"ecr-image-push-rule"` | no |
| <a name="input_event_rule_target_id"></a> [event\_rule\_target\_id](#input\_event\_rule\_target\_id) | ID of the target for the event rule | `string` | `"InvokeLambdaTriggerer"` | no |
| <a name="input_github_app_id_parameter"></a> [github\_app\_id\_parameter](#input\_github\_app\_id\_parameter) | SSM parameter name for the GitHub App ID. Only required when repository is on Github. | `string` | `null` | no |
| <a name="input_github_app_installation_id_parameter"></a> [github\_app\_installation\_id\_parameter](#input\_github\_app\_installation\_id\_parameter) | SSM parameter name for the GitHub App Installation ID. Only required when repository is on Github. | `string` | `null` | no |
| <a name="input_github_app_private_key_parameter"></a> [github\_app\_private\_key\_parameter](#input\_github\_app\_private\_key\_parameter) | SSM parameter name for the GitHub App Private Key. Only required when repository is on Github. | `string` | `null` | no |
| <a name="input_is_codecommit_repo"></a> [is\_codecommit\_repo](#input\_is\_codecommit\_repo) | Whether the repo is a codecommit repo or not | `bool` | `true` | no |
| <a name="input_lambda_triggerer_name"></a> [lambda\_triggerer\_name](#input\_lambda\_triggerer\_name) | Name of the lambda function which will trigger the pipeline. | `string` | `"ECRPushListener"` | no |
| <a name="input_repo_owner"></a> [repo\_owner](#input\_repo\_owner) | Owner of the repository that will be updated by the pipeline | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | <pre>{<br>  "ServiceScope": "Gitops Updater"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_codebuild_updater_project_arn"></a> [codebuild\_updater\_project\_arn](#output\_codebuild\_updater\_project\_arn) | Codebuild updater project arn |
| <a name="output_codebuild_updater_project_name"></a> [codebuild\_updater\_project\_name](#output\_codebuild\_updater\_project\_name) | Codebuild updater project name |
| <a name="output_codebuild_updater_role_arn"></a> [codebuild\_updater\_role\_arn](#output\_codebuild\_updater\_role\_arn) | Codebuild updater role arn |
| <a name="output_codebuild_updater_role_name"></a> [codebuild\_updater\_role\_name](#output\_codebuild\_updater\_role\_name) | Codebuild updater role name |
| <a name="output_lambda_triggerer_arn"></a> [lambda\_triggerer\_arn](#output\_lambda\_triggerer\_arn) | Arn of the Lambda function that triggers Codebuild |
| <a name="output_lambda_triggerer_function_name"></a> [lambda\_triggerer\_function\_name](#output\_lambda\_triggerer\_function\_name) | Function name of the Lambda function that triggers Codebuild |
<!-- END_TF_DOCS -->