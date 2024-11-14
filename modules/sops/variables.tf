variable "secret_key" {
    description = "The JSON key where the secret is stored in the secret file. Not needed if input_type is raw"
    type        = string
    default     = null
}

variable "secret_file" {
    description = "The secret file to be used to decrypt the secret"
    type        = string
}

variable "input_type" {
    default     = null
    description = "(Optional) The provider will use the file extension to determine how to unmarshal the data. If your file does not have the usual extension, set this argument to yaml or json accordingly, or raw if the encrypted data is encoded differently."
}
