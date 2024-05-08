locals {
  region                   = "eu-central-1"
  availability_zone        = "${data.aws_region.current.name}${var.availability_zone}"
  backup_availability_zone = "${data.aws_region.current.name}${var.backup_availability_zone}"

  tags = merge(
    {
      for k, v in var.tags :
      k => v
    },
    {
      project = var.name
    }
  )

  db_subnet_ids = [
    for key, subnet in aws_subnet.subnets :
    subnet.id
    if subnet.tags.type == "db"
  ]

  lambda_subnet_ids = [
    for key, subnet in aws_subnet.subnets :
    subnet.id
    if subnet.tags.type == "apps-private"
  ]

  db_subnets_cidrs = [
    for key, subnet in aws_subnet.subnets :
    subnet.cidr_block
    if subnet.tags.type == "db"
  ]

  all_subnets_cidrs = [
    for key, subnet in aws_subnet.subnets :
    subnet.cidr_block
  ]
}
