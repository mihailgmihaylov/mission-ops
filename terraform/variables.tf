variable "terraform_state_bucket" {
  description = "The name of the S3 bucket to store Terraform state."
  type        = string
  default     = ""
}

variable "region" {
  description = "The name of the region in which the terraform S3 state bucket resides."
  type        = string
  default     = "eu-central-1"
}
