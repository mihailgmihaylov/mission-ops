module "s3" {
  source = "./modules/s3"
  names  = ["${var.name}-bucket"]

  block_public_access = {
    "${var.name}-bucket" = {
      block_public_acls       = false
      block_public_policy     = false
      ignore_public_acls      = true
      restrict_public_buckets = false
    }
  }

  server_side_encryption_configuration = {
    "${var.name}-bucket" = {
      sse_alogithm = "AES256"
    }
  }

  bucket_policies = {
    "${var.name}-bucket" = [
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
    "${var.name}-bucket" = local.tags
  }
}
