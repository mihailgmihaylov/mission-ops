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
