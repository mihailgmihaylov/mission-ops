module "s3" {
  source = "./modules/s3"
  names  = var.buckets.names

  block_public_access = {
    for name in var.buckets.names :
    name => {
      block_public_acls       = var.buckets.block_public_acls
      block_public_policy     = var.buckets.block_public_policy
      ignore_public_acls      = var.buckets.ignore_public_acls
      restrict_public_buckets = var.buckets.restrict_public_buckets
    }
  }

  server_side_encryption_configuration = {
    for name in var.buckets.names :
    name => {
      sse_algorithm = var.buckets.sse_algorithm
    }
  }

  bucket_policies = {
    for name in var.buckets.names :
    name => [
      {
        sid         = "ReadOnly"
        effect      = "Allow"
        principals = {
          type = "AWS"
          identifiers = [
            aws_iam_role.backend_role.arn
          ]
        }
        actions = [
          "s3:GetObject",
          "s3:GetObjectVersion"
        ]
      },
      {
        sid         = "ReadWrite"
        effect      = "Allow"
        principals = {
          type = "AWS"
          identifiers = [
            aws_iam_role.backend_role.arn
          ]
        }

        actions = [
          "s3:GetObject",
          "s3:GetObjectAcl",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
      }
    ]
  }

  tags = {
    for name in var.buckets.names :
    name => local.tags
  }
}
