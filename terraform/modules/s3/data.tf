data "aws_iam_policy_document" "policy" {
  for_each = var.bucket_policies
  dynamic "statement" {
    for_each = each.value
    content {
      sid    = statement.value.sid
      effect = statement.value.effect
      principals {
        type        = statement.value.principals.type
        identifiers = statement.value.principals.identifiers
      }
      actions   = statement.value.actions
      resources = length(statement.value.resources) > 0 ? statement.value.resources : local.bucket_resources[each.key]
    }
  }
}
