locals {
  region            = "eu-central-1"
  availability_zone = "${data.aws_region.current.name}${var.availability_zone}"

  tags = merge(
    {
      for k, v in var.tags :
      k => v
    },
    {
      project = var.name
    }
  )

  all_subnets_cidrs = [
    for key, subnet in aws_subnet.subnets :
    subnet.cidr_block
  ]
}
