resource "aws_s3_bucket" "buckets" {
  for_each      = local.buckets
  bucket        = each.value
  force_destroy = lookup(var.force_destroy, each.key, false)

  lifecycle {
    ignore_changes = [grant]
  }

  tags = merge(
    {
      Name = each.value
    },
    lookup(var.tags, each.key, {})
  )
}

resource "aws_s3_bucket_policy" "buckets" {
  for_each = var.bucket_policies
  bucket   = aws_s3_bucket.buckets[each.key].id
  policy   = data.aws_iam_policy_document.policy[each.key].json
}

resource "aws_s3_bucket_public_access_block" "buckets" {
  for_each = local.buckets
  bucket   = aws_s3_bucket.buckets[each.key].id

  block_public_acls       = can(var.block_public_access[each.value].block_public_acls) ? var.block_public_access[each.value].block_public_acls : true
  block_public_policy     = can(var.block_public_access[each.value].block_public_policy) ? var.block_public_access[each.value].block_public_policy : true
  ignore_public_acls      = can(var.block_public_access[each.value].ignore_public_acls) ? var.block_public_access[each.value].ignore_public_acls : true
  restrict_public_buckets = can(var.block_public_access[each.value].restrict_public_buckets) ? var.block_public_access[each.value].restrict_public_buckets : true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "buckets" {
  for_each = var.server_side_encryption_configuration
  bucket   = aws_s3_bucket.buckets[each.key].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = lookup(each.value, "sse_algorithm", "AES256")
      kms_master_key_id = lookup(each.value, "kms_master_key_id", null)
    }
    bucket_key_enabled = lookup(each.value, "bucket_key_enabled", true)
  }
}
