resource "aws_apprunner_observability_configuration" "backend" {
  observability_configuration_name = "${var.name}-backend"

  trace_configuration {
    vendor = "AWSXRAY"
  }
}

resource "aws_apprunner_vpc_connector" "backend_connector" {
  vpc_connector_name = "${var.name}-backend"
  subnets         = local.backend_subnet_ids
  security_groups = [aws_security_group.backend_security_group.id]
}

resource "aws_apprunner_service" "backend" {
  service_name = "${var.name}-backend"

  observability_configuration {
    observability_configuration_arn = aws_apprunner_observability_configuration.backend.arn
    observability_enabled           = true
  }

  source_configuration {
    image_repository {
      image_configuration {
        port = var.application.port
      }
      image_identifier      = "${var.application.image}:${var.application.tag}"
      image_repository_type = var.application.repo
    }

    auto_deployments_enabled = false
  }

  instance_configuration {
    cpu                = var.application.cpu
    memory             = var.application.memory
    instance_role_arn  = ""
  }

  network_configuration {
    ingress_configuration {
      is_publicly_accessible = var.application.is_public
    }

    egress_configuration {
      egress_type       = "VPC"
      vpc_connector_arn = aws_apprunner_vpc_connector.backend_connector.arn
    }
  }

  tags = local.tags
}
