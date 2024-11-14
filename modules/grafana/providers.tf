terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
        }
        grafana = {
            source  = "grafana/grafana"
            version = "2.18.0"
        }
    }
}
