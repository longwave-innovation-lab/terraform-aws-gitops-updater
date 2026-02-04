data "aws_ecr_repository" "repositories" {
  for_each = toset(var.ecr_registry_triggers)
  name     = each.key
}
