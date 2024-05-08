resource "aws_security_group" "rds_security_group" {
  name        = "rds-security-group"
  vpc_id      = aws_vpc.vpc.id
  description = "Security group for RDS instance"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = local.all_subnets_cidrs
  }

  tags = {
    Name = "rds-security-group"
  }
}

resource "aws_security_group" "lambda_security_group" {
  name        = "lambda-security-group"
  vpc_id      = aws_vpc.vpc.id
  description = "Security group for the Lambda instances"

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = local.db_subnets_cidrs
  }

  tags = {
    Name = "lambda-security-group"
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda-policy"
  description = "Policy for the Lambda function"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "arn:aws:logs:*:*:*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "rds-db:connect"
        ],
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_security_group" "backend_security_group" {
  name   = "backend-security-group"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = var.application.port
    to_port     = var.application.port
    protocol    = "tcp"
    cidr_blocks = ["${trimspace(data.http.personal_public_ip_address.response_body)}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["${trimspace(data.http.personal_public_ip_address.response_body)}/32"]
  }

  tags = {
    Name = "backend-security-group"
  }
}

resource "aws_iam_role" "backend_role" {
  name = "backend-role"

  assume_role_policy    = data.aws_iam_policy_document.instance_assume_role.json
  force_detach_policies = true

  tags = local.tags
}
