variable "vpc_id" {}
variable "ec2_disk_size" {
  default = 32
}

variable "ecs_cluster_name" {}
variable "subnet_list" {}
variable "asg_desired_capacity" {}
variable "asg_minimum_size" {}
variable "asg_maximum_size" {}
variable "ec2_instance_profile" {}
variable "blackbox_ecr" {}
variable "prometheus_ecr" {}
variable "blackbox_tag" {}
variable "prometheus_tag" {}

variable "kms_arn" {
  type        = string
  default     = ""
  description = "KMS ARN to use for encryption"
}
