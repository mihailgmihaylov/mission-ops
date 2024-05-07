terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.48.0"
    }
  }

  backend "s3" {
    bucket = var.bucket
    key    = "terraform.tfstate"
    region = var.region
  }
}
