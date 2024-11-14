variable "secret_name" {
    type        = string
    description = "Name of the secret to be created"
}
variable "secret_names" {
    type = list(string)
    default = []
}
variable "secret_value" {
    type        = string
    description = "Contents of the secret. Please use sops module to get this value"
}
variable "tags" {
    default = null
}
variable "version_only" {
    default     = false
    description = "If true, only the version of the secret will be created"
}
