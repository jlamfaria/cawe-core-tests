variable "master_username" {
    type        = string
    description = "DocumentDB Cluster username"
}

variable "master_password" {
    type        = string
    description = "DocumentDB Cluster password"
}


variable "db_subnet_group_name" {
    type        = string
    description = "Subnet Group Name of DocumentDB Cluster"
}

variable "vpc_documentdb_name" {
    description = "Name of the VPC where the security group should be created"
}

variable "vpc_eks_name" {
    description = "Name of the VPC where the EKS is created"
}

variable "instance_class" {
    type        = string
    description = "Instance class of the DocumentDB Cluster"
    default     = "db.t3.medium"
}

variable "instance_count" {
    type        = string
    description = "Number of instances in the DocumentDB Cluster"
    default     = "3"
}

variable "suffix" {
    type        = string
    description = "Suffix to be added to the DocumentDB Cluster"
    default = ""
}
