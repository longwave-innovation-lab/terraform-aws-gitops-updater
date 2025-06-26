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