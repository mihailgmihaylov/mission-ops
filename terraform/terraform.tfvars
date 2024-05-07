name           = "mission-ops"
vpc_cidr_block = "10.10.0.0/16"

tags = {
  env = "test"
}

subnets = [
  {
    name       = "db-tier"
    cidr_block = "10.10.0.0/24"

    tags = {
      "type" = "dbs-private"
    }
  },
  {
    name       = "app-tier"
    cidr_block = "10.10.1.0/24"

    tags = {
      "type" = "apps-private"
    }
  },
  {
    name       = "dmz"
    cidr_block = "10.10.2.0/24"
    public     = true

    tags = {
      "type" = "apps-public"
    }
  }
]
