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
      "type" = "db"
    }
  },
  # A second DB subnet is an RDS requeirement even for a Standalone instance
  {
    name       = "db-secondary-tier"
    cidr_block = "10.10.1.0/24"

    tags = {
      "type" = "db"
    }
  },
  {
    name       = "app-tier"
    cidr_block = "10.10.2.0/24"

    tags = {
      "type" = "apps-private"
    }
  },
  {
    name       = "dmz"
    cidr_block = "10.10.3.0/24"
    public     = true

    tags = {
      "type" = "apps-public"
    }
  }
]

database = {
  storage  = 20
  instance = "db.t3.micro"
}

application = {
  port      = 8080
  image     = "public.ecr.aws/aws-containers/hello-app-runner"
  tag       = "latest"
  repo      = "ECR_PUBLIC"
  is_public = true
}
