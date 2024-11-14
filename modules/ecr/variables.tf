variable "repo_name" {}

# Project
variable "group" {
  type        = string

}

variable "project_name" {
  type        = string
  description = "Project Name of this deployment"
}



variable "environment" {
  type        = string
  description = "(Set by pipeline) Used to derive names of AWS resources. Use this to distinguish different enviroments"
}


variable "allow_principal" {
  type = list(string)
}

variable "image_tag_mutability" {
  default = "IMMUTABLE"
}
