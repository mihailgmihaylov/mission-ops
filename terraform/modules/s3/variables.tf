variable "names" {
  type        = list(string)
  description = "Bucket name suffixes."
  validation {
    condition = alltrue([
      for bucket in var.names :
      can(regex("^[a-z0-9][a-z0-9_\\-\\.]{1,61}[a-z0-9]$", bucket))
      &&
      (length(distinct(var.names)) == length(var.names))
    ])
    error_message = "* Use only lowercase letters, numbers, hyphens (-), and underscores (_). Dots (.) may be used to form a valid domain name. Must start and end with lowercase letter or number. Must be betwen 3 and 63 characters.\n* Should not contain duplicate elements in the list."
  }
}

variable "prefix" {
  description = "Prefix used to generate the bucket name."
  type        = string
  default     = ""
  validation {
    condition     = var.prefix == "" || can(regex("^[a-z0-9][a-z0-9\\-]{1,38}[a-z0-9]$", var.prefix))
    error_message = "Use only lowercase letters, numbers and hyphens (-). Dots (.) Must start and end with lowercase letter or number. Must be betwen 3 and 40 characters."
  }
}

variable "bucket_policies" {
  type = map(list(object({
    sid       = optional(string, "")
    effect    = optional(string, "Allow")
    actions   = list(string)
    resources = optional(list(string), [])

    principals = object({
      type        = optional(string, "AWS")
      identifiers = list(string)
    })
  })))
  description = "Map of bucket names => policy statement."
  default     = {}
}

variable "server_side_encryption_configuration" {
  type    = map(map(string))
  default = {}
}

variable "block_public_access" {
  type        = map(map(string))
  description = "Map of bucket names => block_public_access settings."
  default     = {}
}

variable "force_destroy" {
  description = "Optional map of lowercase unprefixed name => boolean, defaults to false."
  type        = map(bool)
  default     = {}
}

variable "tags" {
  type        = map(map(string))
  description = "Map of bucket names => map of tags to assign to the bucket."
  default     = {}
}
