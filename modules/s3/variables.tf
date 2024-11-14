variable "name" {
  description = ""
}
variable "naming_prefix" {
  description = ""
}
variable "project_name" {
  description = ""
}
variable "environment" {
  description = ""
}
variable "module" {
  default = "cawe.bucket"
}
variable "kms_arn" {
  default = null
}
variable "allowed_accounts" {}

variable "enable_acl" {
  type = bool
  default = false
  description = "Enable/disable S3 ACLs"
}
