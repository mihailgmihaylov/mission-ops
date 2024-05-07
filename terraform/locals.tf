locals {
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
