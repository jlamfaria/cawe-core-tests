data "aws_vpc" "documentdb_documentdb_vpc" {
    tags = {
        Name = var.vpc_documentdb_name
    }
}

data "aws_vpc" "documentdb_eks_vpc" {
    tags = {
        Name = var.vpc_eks_name
    }
}

resource "aws_security_group" "documentdb_cluster_sg" {
    name        = "documentdb_cluster_sg"
    description = "Security Group to filter the connections with the DocumentDB cluster"
    vpc_id      = data.aws_vpc.documentdb_documentdb_vpc.id

    ingress {
        description = "Allow connection from VPC where the EKS cluster is created"
        from_port   = 27017
        to_port     = 27017
        protocol    = "tcp"
        cidr_blocks = [data.aws_vpc.documentdb_eks_vpc.cidr_block]
    }

    ingress {
        description = "Allow connection from VPC where the DocumentDB cluster is created"
        from_port   = 27017
        to_port     = 27017
        protocol    = "tcp"
        cidr_blocks = [data.aws_vpc.documentdb_documentdb_vpc.cidr_block]
    }

}

resource "aws_docdb_cluster_instance" "cawe-cluster_instances" {
    count                       = var.instance_count
    identifier                  = "cawe-api-documentdb-cluster${var.suffix != "" ? "-${var.suffix}" : ""}-${count.index}"
    cluster_identifier          = aws_docdb_cluster.cawe-api-documentdb-cluster.id
    instance_class              = var.instance_class
    apply_immediately           = false
    enable_performance_insights = true
}

resource "aws_docdb_cluster" "cawe-api-documentdb-cluster" {
    #checkov:skip=CKV_AWS_182
    cluster_identifier           = "cawe-api-cluster-documentdb${var.suffix != "" ? "-${var.suffix}" : ""}"
    availability_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
    master_username              = var.master_username
    master_password              = var.master_password
    db_subnet_group_name         = var.db_subnet_group_name
    vpc_security_group_ids = [aws_security_group.documentdb_cluster_sg.id]
    skip_final_snapshot          = false
    preferred_backup_window      = "01:00-02:00"
    preferred_maintenance_window = "tue:02:30-tue:03:00"
    backup_retention_period      = 7
    storage_encrypted            = true
    enabled_cloudwatch_logs_exports = ["audit", "profiler"]
    deletion_protection          = "true"


}

