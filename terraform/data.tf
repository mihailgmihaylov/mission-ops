data "aws_region" "current" {}
data "aws_partition" "current" {}

data "http" "personal_public_ip_address" {
  url = "https://ifconfig.co/ip"
}

data "aws_iam_policy_document" "instance_assume_role" {
  statement {
    sid     = "InstanceAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["tasks.apprunner.${data.aws_partition.current.dns_suffix}"]
    }
  }
}
