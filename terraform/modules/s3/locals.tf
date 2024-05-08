locals {
  buckets = {
    for name in var.names :
    (name) => var.prefix == "" ? name : format("%s-%s", var.prefix, name)
  }

  bucket_resources = {
    for name in var.names :
    (name) => [
      aws_s3_bucket.buckets[name].arn,
      "${aws_s3_bucket.buckets[name].arn}/*"
    ]
  }
}
