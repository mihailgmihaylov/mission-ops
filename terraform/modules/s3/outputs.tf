output "names" {
  description = "Map with bucket names."
  value = { for name, bucket in aws_s3_bucket.buckets :
    name => bucket.id
  }
}

output "arns" {
  description = "Map with bucket ARNs."
  value = { for arn, bucket in aws_s3_bucket.buckets :
    arn => bucket.arn
  }
}
