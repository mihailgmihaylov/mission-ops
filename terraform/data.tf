data "aws_region" "current" {}

data "http" "personal_public_ip_address" {
  url = "https://ifconfig.co/ip"
}
