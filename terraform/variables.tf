variable "region" {
  description = "The name of the region in which the terraform S3 state bucket resides."
  type        = string
  default     = "eu-central-1"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resource."
  default     = {}
}

variable "name" {
  type        = string
  description = "Name of the overall environment."
  validation {
    condition     = can(regex("^[a-z][-a-z0-9]{1,60}[a-z0-9]$", var.name))
    error_message = "The name must be 3-62 characters long and match the regular expression \"^[a-z][-a-z0-9]{1,60}[a-z0-9]$\"."
  }
}

variable "vpc_cidr_block" {
  type        = string
  description = "The CIDR block for the VPC."
  validation {
    condition = (
      (tonumber(split(".", var.vpc_cidr_block)[0]) == 10 || tonumber(split(".", var.vpc_cidr_block)[0]) == 172 || tonumber(split(".", var.vpc_cidr_block)[0]) == 192) &&
      (tonumber(split(".", var.vpc_cidr_block)[1]) >= 0 && tonumber(split(".", var.vpc_cidr_block)[1]) <= 255) &&
      (tonumber(split(".", var.vpc_cidr_block)[2]) >= 0 && tonumber(split(".", var.vpc_cidr_block)[2]) <= 255) &&
      tonumber(split("/", split(".", var.vpc_cidr_block)[3])[0]) == 0 &&
      tonumber(split("/", var.vpc_cidr_block)[1]) >= 16 && tonumber(split("/", var.vpc_cidr_block)[1]) <= 24
    )
    error_message = "The CIDR block is not a valid IP address with Subnet mask"
  }
}

variable "subnets" {
  type = list(object({
    name        = string
    public      = optional(bool, false)
    cidr_block  = string
    tags        = optional(map(string), {})
  }))
  description = "The list of subnets being created."
  default     = []
  validation {
    condition = length([
      for subnet in var.subnets :
      "public"
      if lookup(subnet, "public", false)
    ]) <= 1
    error_message = "Only one subnet map can be configured with \"public\" set to \"true\"."
  }
}

variable "availability_zone" {
  type        = string
  description = "The suffix of the avaliability zone."
  default     = "a"
}

variable "backup_availability_zone" {
  type        = string
  description = "The suffix of the backup avaliability zone."
  default     = "b"
}

variable "database" {
  type = object({
    storage      = number
    storage_type = optional(string, "gp3")
    engine       = optional(string, "postgres")
    version      = optional(string, "16.1")
    instance     = string
    is_public    = optional(bool, false)
  })
  description = "A map of database settings."
}

variable "db_admin_user" {
  type        = string
  description = "The database user with admin access."
  default     = ""
  sensitive   = true
}

variable "db_admin_pass" {
  type        = string
  description = "The database admin user password."
  default     = ""
  sensitive   = true
}
