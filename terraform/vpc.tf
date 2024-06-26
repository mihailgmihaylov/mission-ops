resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"
  tags = merge(
    {
      Name = var.name
    },
    local.tags
  )
}

resource "aws_subnet" "subnets" {
  count                   = length(var.subnets)
  availability_zone       = can(regex("^.*secondary.*$", var.subnets[count.index].name)) ? local.backup_availability_zone : local.availability_zone
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnets[count.index].cidr_block
  map_public_ip_on_launch = lookup(var.subnets[count.index], "public", false)
  tags = merge(
    {
      Name = "${var.name}-${var.subnets[count.index].name}-${trimprefix(local.availability_zone, var.region)}"
    },
    var.subnets[count.index].tags,
    local.tags
  )
}

resource "aws_db_subnet_group" "rds" {
  name       = "${var.name}-db"
  subnet_ids = local.db_subnet_ids

  tags = {
    Name = "My DB subnet group"
  }
}
