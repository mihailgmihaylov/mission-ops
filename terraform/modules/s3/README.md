# Terraform S3 Module

This module makes it easy to create single or multiple S3 buckets in AWS.

It supports creating:

* S3 bucket
These features of S3 bucket configurations are supported:

* server-side encryption
* bucket policies

## Minimal example

```
module "s3" {
  source = "./modules/s3"
  names  = ["test-123"]
}
```

## Extended example

```
module "s3" {
  source = "./modules/s3"
  names  = ["test-123", "test-321"]

  block_public_access = {
    test-123 = {}
    test-321 = {
      block_public_acls       = false
      block_public_policy     = false
      ignore_public_acls      = true
      restrict_public_buckets = false
    }
  }

  force_destroy = {
    test-123 = true
  }

  server_side_encryption_configuration = {
    test-123 = {
      sse_algorithm = "AES256"
    }

    test-321 = {
      sse_algorithm = "AES256"
    }
  }

  tags = {
    test-123 = {
      "key1" = "value1"
      "key2" = "value2"
    }
    test-321 = {
      "key3" = "value3"
      "key4" = "value4"
    }
  }

  bucket_policies = {
    test-123 = [
      {
        sid         = "ReadOnly"
        effect      = "Allow"
        principals = {
          type = "AWS"
          identifiers = [
            "arn:aws:iam::111111111111:role/some-role-name",
            "arn:aws:iam::222222222222:role/some-role-name",
          ]
        }
        actions = ["s3:GetObject", "s3:GetObjectVersion"]
      },
      {
        sid         = "ReadWrite"
        effect      = "Allow"
        principals = {
          type = "AWS"
          identifiers = [
            "arn:aws:iam::111111111111:role/some-role-name",
            "arn:aws:iam::222222222222:user/some-user"
          ]
        }
        actions     = [
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
}
```
