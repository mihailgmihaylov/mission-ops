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
}
