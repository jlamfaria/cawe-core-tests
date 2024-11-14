environment                              = "dev"
group                                    = "cawe"
project_name                             = "cawe"
account_type                             = "DEF"
vpc_endpoint_service_name_cdp_tools      = "com.amazonaws.vpce.eu-central-1.vpce-svc-0a54f52b9a859e5c8"
vpc_endpoint_service_name_code_connected = "com.amazonaws.vpce.eu-central-1.vpce-svc-05b59faa9a2b5ae23"


accounts = {
    dev = {
        default  = "932595925475"
        advanced = "092228957173"
    }
    int = {
        default  = "565128768560"
        advanced = "500643607194"
    }
    prd = {
        default  = "088012017805"
        advanced = "810674048896"
    }
}

common_tags = {
    environment  = "dev"
    project_name = "CAWE"
}

# when creating a new zone, run it with a target to ensure the correct order and no downtime
# terraform apply -var-file inputs.tfvars --target  module.route-manager.aws_route53_zone.default
hosted_zones = [
    "bmwgroup.net",
    "aws.cloud.bmw",
    "azure.cloud.bmw",
    "bmw.corp",
    "muc",
    "aws.unicom.cloud.bmw",
    "gcp.cloud.bmw"
]

nginx_ports = [
    443,
    444,
    3000,
    8080,
    9020,
    9021,
    9080,
    9090,
    9091,
    9093,
    9243,
    9914,
    12443,
    15898,
    16215,
    16216,
    19914
]

load_balancers_vpc1 = []

load_balancers_vpc2 = [
    "phantom",
    "ghost",
    "spectre",
    "wraith",
    "cullinan",
    "berlin",
    "hamburg",
    "munich",
    "cologne",
    "dortmund",
    "stuttgart",
    "frankfurt"
]

# Please note that we can't duplicate port number for the same NLB
# Also take into consideration the AWS limits https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-limits.html
# ALWAYS ADD NEW ROUTES TO THE END -> adding in the top/middle will recreate all resources that have higher indexes
target_groups_vpc1 = []

target_groups_vpc2 = [
    {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "160.46.167.56"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "160.52.38.37"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "160.46.167.51"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "160.46.167.55"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "172.30.183.59"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "172.24.24.207"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "160.46.136.111"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "160.46.135.96"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "170.34.109.11"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "160.48.96.120"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "172.16.73.155"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "160.48.5.16"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "160.51.11.40"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "160.46.2.22"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "172.30.183.24"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "172.25.195.208"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "172.25.195.209"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "160.47.40.20"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "170.34.109.129"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "160.46.167.52"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "160.48.96.121"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "160.46.221.15"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "160.47.40.21"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "160.46.167.54"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "160.46.194.13"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "160.46.136.100"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "160.46.136.105"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "160.46.167.58"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "170.34.109.218"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "160.46.136.106"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "160.46.136.107"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "160.46.167.53"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "172.25.128.21"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "172.30.183.32"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "160.46.167.57"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "160.48.232.219"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "160.46.135.54"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "160.52.38.41"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "160.51.10.111"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "160.48.227.59"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "160.48.5.12"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "160.48.227.56"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "10.4.59.161"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "10.187.241.96"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "160.46.2.23"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "172.23.224.32"
    }, {
        subdomain     = "europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 636
        service_ip    = "170.34.216.11"
    },
    {
        subdomain     = "smuc13666"
        hosted_zone   = "bmwgroup.net"
        load_balancer = "phantom"
        service_port  = 2018
        service_ip    = "10.30.90.14"
    }, {
        subdomain     = "smuc13666"
        hosted_zone   = "bmwgroup.net"
        load_balancer = "phantom"
        service_port  = 12018
        service_ip    = "10.30.90.14"
    }, {
        subdomain     = "smuc13667"
        hosted_zone   = "bmwgroup.net"
        load_balancer = "ghost"
        service_port  = 2018
        service_ip    = "10.30.89.127"
    }, {
        subdomain     = "smuc13667"
        hosted_zone   = "bmwgroup.net"
        load_balancer = "ghost"
        service_port  = 12018
        service_ip    = "10.30.89.127"
    }, {
        subdomain     = "groupdir"
        hosted_zone   = "bmwgroup.net"
        load_balancer = "ghost"
        service_port  = 636
        service_ip    = "160.50.80.238"
    }, {
        subdomain     = "smuc13668"
        hosted_zone   = "bmwgroup.net"
        load_balancer = "spectre"
        service_port  = 2018
        service_ip    = "10.30.90.145"
    }, {
        subdomain     = "smuc13668"
        hosted_zone   = "bmwgroup.net"
        load_balancer = "spectre"
        service_port  = 12018
        service_ip    = "10.30.90.145"
    }, {
        subdomain     = "atc-github"
        hosted_zone   = "azure.cloud.bmw"
        load_balancer = "spectre"
        service_port  = 22
        service_ip    = "160.48.166.4"
    }, {
        subdomain     = "atc-github"
        hosted_zone   = "azure.cloud.bmw"
        load_balancer = "spectre"
        service_port  = 443
        service_ip    = "160.48.166.4"
    }, {
        subdomain     = "smuc11822"
        hosted_zone   = "bmwgroup.net"
        load_balancer = "phantom"
        service_port  = 9914
        service_ip    = "160.50.15.21"
    }, {
        subdomain     = "smuc11822"
        hosted_zone   = "bmwgroup.net"
        load_balancer = "phantom"
        service_port  = 19914
        service_ip    = "160.50.15.21"
    }, {
        subdomain     = "proxy.ccc-ng-1.eu-central-1"
        hosted_zone   = "aws.cloud.bmw"
        load_balancer = "phantom"
        service_port  = 8080
        service_ip    = "10.6.27.176"
    }, {
        subdomain     = "proxy.ccc-ng-1.eu-central-1"
        hosted_zone   = "aws.cloud.bmw"
        load_balancer = "phantom"
        service_port  = 8080
        service_ip    = "10.6.27.107"
    }, {
        subdomain     = "git"
        hosted_zone   = "bmwgroup.net"
        load_balancer = "phantom"
        service_port  = 7999
        service_ip    = "160.52.107.4"
    }, {
        subdomain     = "git"
        hosted_zone   = "bmwgroup.net"
        load_balancer = "phantom"
        service_port  = 7999
        service_ip    = "160.52.107.21"
    }, {
        subdomain     = "pkgitsmrepp"
        hosted_zone   = "bmwgroup.net"
        load_balancer = "phantom"
        service_port  = 1529
        service_ip    = "10.30.38.94"
    }, {
        subdomain     = "pkgtmsvdwhi"
        hosted_zone   = "bmwgroup.net"
        load_balancer = "phantom"
        service_port  = 1522
        service_ip    = "10.30.37.163"
    }, {
        subdomain     = "mail"
        hosted_zone   = "bmwgroup.net"
        load_balancer = "phantom"
        service_port  = 465
        service_ip    = "160.50.251.10"
    }, {
        subdomain     = "mail"
        hosted_zone   = "bmwgroup.net"
        load_balancer = "phantom"
        service_port  = 587
        service_ip    = "160.50.251.10"
    }, {
        subdomain     = "base-e2e-emea"
        hosted_zone   = "bmwgroup.net"
        load_balancer = "phantom"
        service_port  = 443
        service_ip    = "160.50.23.13"
    }, {
        subdomain     = "GMUC12596G1.europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "phantom"
        service_port  = 1433
        service_ip    = "10.31.153.71"
    }, {
        subdomain     = "pkgsbcmdbp"
        hosted_zone   = "bmwgroup.net"
        load_balancer = "phantom"
        service_port  = 1523
        service_ip    = "10.30.38.153"
    }, {
        subdomain     = "liintra12127vm"
        hosted_zone   = "bmwgroup.net"
        load_balancer = "phantom"
        service_port  = 22
        service_ip    = "10.30.76.182"
    }, {
        subdomain     = "li10usbffe2e02"
        hosted_zone   = "bmwgroup.net"
        load_balancer = "wraith"
        service_port  = 22
        service_ip    = "10.184.234.96"
    }, {
        subdomain     = "lp10usbffprod02"
        hosted_zone   = "bmwgroup.net"
        load_balancer = "cullinan"
        service_port  = 22
        service_ip    = "10.184.234.115"
    }, {
        subdomain     = "ltbfftest02"
        hosted_zone   = "bmwgroup.net"
        load_balancer = "berlin"
        service_port  = 22
        service_ip    = "10.30.72.15"
    }, {
        subdomain     = "ltbffint02"
        hosted_zone   = "bmwgroup.net"
        load_balancer = "hamburg"
        service_port  = 22
        service_ip    = "10.30.72.20"
    }, {
        subdomain     = "libffe2e02"
        hosted_zone   = "bmwgroup.net"
        load_balancer = "munich"
        service_port  = 22
        service_ip    = "10.30.72.33"
    }, {
        subdomain     = "lpbffprod02"
        hosted_zone   = "bmwgroup.net"
        load_balancer = "cologne"
        service_port  = 22
        service_ip    = "10.30.72.35"
    }, {
        subdomain     = "li19cnbffe2e02"
        hosted_zone   = "bmwgroup.net"
        load_balancer = "dortmund"
        service_port  = 22
        service_ip    = "10.187.194.178"
    }, {
        subdomain     = "lp19cnbffprod02"
        hosted_zone   = "bmwgroup.net"
        load_balancer = "stuttgart"
        service_port  = 22
        service_ip    = "10.187.194.102"
    }, {
        subdomain     = "avicap8201int"
        hosted_zone   = "bmwgroup.net"
        load_balancer = "phantom"
        service_port  = 1344
        service_ip    = "160.50.41.161"
    }, {
        subdomain     = "avicap8202int"
        hosted_zone   = "bmwgroup.net"
        load_balancer = "phantom"
        service_port  = 1344
        service_ip    = "160.50.41.163"
    }, {
        subdomain     = "e2e-cache-db.concat.eu-central-1"
        hosted_zone   = "aws.cloud.bmw"
        load_balancer = "phantom"
        service_port  = 5432
        service_ip    = "10.3.61.100"
    }, {
        subdomain     = "prod-cache-db.concat.eu-central-1"
        hosted_zone   = "aws.cloud.bmw"
        load_balancer = "ghost"
        service_port  = 5432
        service_ip    = "10.3.61.118"
    }, {
        subdomain     = "e2e-cache-db.concat.us-east-1"
        hosted_zone   = "aws.cloud.bmw"
        load_balancer = "spectre"
        service_port  = 5432
        service_ip    = "10.81.149.141"
    }, {
        subdomain     = "prod-cache-db.concat.us-east-1"
        hosted_zone   = "aws.cloud.bmw"
        load_balancer = "wraith"
        service_port  = 5432
        service_ip    = "10.81.149.152"
    }, {
        subdomain     = "e2e-cache-db.concat.ap-northeast-2"
        hosted_zone   = "aws.cloud.bmw"
        load_balancer = "cullinan"
        service_port  = "5432"
        service_ip    = "10.10.83.157"
    }, {
        subdomain     = "prod-cache-db.concat.ap-northeast-2"
        hosted_zone   = "aws.cloud.bmw"
        load_balancer = "berlin"
        service_port  = "5432"
        service_ip    = "10.10.83.155"
    }, {
        subdomain     = "lpapigwbuild11"
        hosted_zone   = "bmwgroup.net"
        load_balancer = "frankfurt"
        service_port  = "22"
        service_ip    = "10.30.19.151"
    }, {
        subdomain     = "GMUC14566G5.europe"
        hosted_zone   = "bmw.corp"
        load_balancer = "ghost"
        service_port  = 1433
        service_ip    = "10.31.153.176"
    },
    {
        subdomain     = "vehicle.mqtt.e2e-bk25.mqtt-broker.vdc.eu-central-1"
        hosted_zone   = "aws.cloud.bmw"
        load_balancer = "cologne"
        service_port  = 8883
        service_ip    = "10.8.155.13"
    }, {
        subdomain     = "mqtt.sp18.prod.mqtt-broker.vdc.eu-central-1"
        hosted_zone   = "aws.cloud.bmw"
        load_balancer = "dortmund"
        service_port  = 8883
        service_ip    = "10.6.46.71"
    },
    {
        subdomain     = "mqtt.sp18.e2e.mqtt-broker.vdc.us-east-1"
        hosted_zone   = "bmwgroup.net"
        load_balancer = "stuttgart"
        service_port  = 8883
        service_ip    = "10.81.182.54"
    },
    {
        subdomain     = "mqtt.sp18.prod.mqtt-broker.vdc.us-east-1"
        hosted_zone   = "aws.cloud.bmw"
        load_balancer = "frankfurt"
        service_port  = 8883
        service_ip    = "10.81.138.222"
    },
    {
        subdomain     = "mqtt.sp18.e2e.mqtt-broker.vdc.eu-central-1"
        hosted_zone   = "aws.cloud.bmw"
        load_balancer = "munich"
        service_port  = 8883
        service_ip    = "10.3.90.70"
    },
    {
        subdomain     = "vehicle.mqtt.prod-bk25.mqtt-broker.vdc.eu-central-1"
        hosted_zone   = "aws.cloud.bmw"
        load_balancer = "hamburg"
        service_port  = 8883
        service_ip    = "10.8.115.170"
    }
    ]

# please use this to point the subdomain to the correct NLB above
dns_prefixes_vpc1 = []

dns_prefixes_vpc2 = [
    { hosted_zone = "bmwgroup.net", subdomain = "smuc13666", load_balancer = "phantom" },
    { hosted_zone = "bmwgroup.net", subdomain = "smuc13667", load_balancer = "ghost" },
    { hosted_zone = "bmwgroup.net", subdomain = "smuc13668", load_balancer = "spectre" },
    { hosted_zone = "bmwgroup.net", subdomain = "groupdir", load_balancer = "ghost" },
    { hosted_zone = "bmw.corp", subdomain = "europe", load_balancer = "phantom" },
    { hosted_zone = "azure.cloud.bmw", subdomain = "atc-github", load_balancer = "spectre" },
    { hosted_zone = "bmwgroup.net", subdomain = "smuc11822", load_balancer = "phantom" },
    { hosted_zone = "aws.cloud.bmw", subdomain = "proxy.ccc-ng-1.eu-central-1", load_balancer = "phantom" },
    { hosted_zone = "muc", subdomain = "wlic01a1", load_balancer = "phantom" },
    { hosted_zone = "muc", subdomain = "wlic01a2", load_balancer = "ghost" },
    { hosted_zone = "muc", subdomain = "wlic01a3", load_balancer = "spectre" },
    { hosted_zone = "bmwgroup.net", subdomain = "git", load_balancer = "phantom" },
    { hosted_zone = "bmwgroup.net", subdomain = "pkgitsmrepp", load_balancer = "phantom" },
    { hosted_zone = "bmwgroup.net", subdomain = "pkgtmsvdwhi", load_balancer = "phantom" },
    { hosted_zone = "bmwgroup.net", subdomain = "mail", load_balancer = "phantom" },
    { hosted_zone = "bmwgroup.net", subdomain = "base-e2e-emea", load_balancer = "phantom" },
    { hosted_zone = "bmw.corp", subdomain = "GMUC12596G1.europe", load_balancer = "phantom" },
    { hosted_zone = "bmwgroup.net", subdomain = "pkgsbcmdbp", load_balancer = "phantom" },
    { hosted_zone = "bmwgroup.net", subdomain = "liintra12127vm", load_balancer = "phantom" },
    { hosted_zone = "bmwgroup.net", subdomain = "li10usbffe2e02", load_balancer = "wraith" },
    { hosted_zone = "bmwgroup.net", subdomain = "lp10usbffprod02", load_balancer = "cullinan" },
    { hosted_zone = "bmwgroup.net", subdomain = "ltbfftest02", load_balancer = "berlin" },
    { hosted_zone = "bmwgroup.net", subdomain = "ltbffint02", load_balancer = "hamburg" },
    { hosted_zone = "bmwgroup.net", subdomain = "libffe2e02", load_balancer = "munich" },
    { hosted_zone = "bmwgroup.net", subdomain = "lpbffprod02", load_balancer = "cologne" },
    { hosted_zone = "bmwgroup.net", subdomain = "li19cnbffe2e02", load_balancer = "dortmund" },
    { hosted_zone = "bmwgroup.net", subdomain = "lp19cnbffprod02", load_balancer = "stuttgart" },
    { hosted_zone = "bmwgroup.net", subdomain = "avicap8201int", load_balancer = "phantom" },
    { hosted_zone = "bmwgroup.net", subdomain = "avicap8202int", load_balancer = "phantom" },
    { hosted_zone = "aws.cloud.bmw", subdomain = "e2e-cache-db.concat.eu-central-1", load_balancer = "phantom" },
    { hosted_zone = "aws.cloud.bmw", subdomain = "prod-cache-db.concat.eu-central-1", load_balancer = "ghost" },
    { hosted_zone = "aws.cloud.bmw", subdomain = "e2e-cache-db.concat.us-east-1", load_balancer = "spectre" },
    { hosted_zone = "aws.cloud.bmw", subdomain = "prod-cache-db.concat.us-east-1", load_balancer = "wraith" },
    { hosted_zone = "aws.cloud.bmw", subdomain = "e2e-cache-db.concat.ap-northeast-2", load_balancer = "cullinan" },
    { hosted_zone = "aws.cloud.bmw", subdomain = "prod-cache-db.concat.ap-northeast-2", load_balancer = "berlin" },
    { hosted_zone = "bmwgroup.net", subdomain = "lpapigwbuild11", load_balancer = "frankfurt" },
    { hosted_zone = "bmw.corp", subdomain = "GMUC14566G5.europe", load_balancer = "ghost" },
    { hosted_zone = "aws.cloud.bmw", subdomain = "vehicle.mqtt.e2e-bk25.mqtt-broker.vdc.eu-central-1", load_balancer = "cologne" },
    { hosted_zone = "aws.cloud.bmw", subdomain = "mqtt.sp18.prod.mqtt-broker.vdc.eu-central-1", load_balancer = "dortmund" },
    { hosted_zone = "aws.cloud.bmw", subdomain = "mqtt.sp18.e2e.mqtt-broker.vdc.us-east-1", load_balancer = "stuttgart" },
    { hosted_zone = "aws.cloud.bmw", subdomain = "mqtt.sp18.prod.mqtt-broker.vdc.us-east-1", load_balancer = "frankfurt" },
    { hosted_zone = "aws.cloud.bmw", subdomain = "mqtt.sp18.e2e.mqtt-broker.vdc.eu-central-1", load_balancer = "munich" },
    { hosted_zone = "aws.cloud.bmw", subdomain = "vehicle.mqtt.prod-bk25.mqtt-broker.vdc.eu-central-1", load_balancer = "hamburg" }

]

nginx_ami_name         = "cawe-nginx-ubuntu-x64-v1.2.3"
nginx_instance_type    = "t3a.small"

nginx_desired_capacity = 4
nginx_min_size = 1
nginx_max_size = 9

generic_endpoint_connection = [
    {
        service           = "buffet-db-emea-e2e",
        ports             = [6543],
        customer_name     = "CDSE Team",
        vpce_service_name = "com.amazonaws.vpce.eu-central-1.vpce-svc-00fa37350290b28fb"
    },
    {
        service           = "test-db-emea",
        ports             = [5071, 5041, 5100, 5056, 5081, 5014, 5026, 5053, 5070, 5060, 5050, 5013, 5101, 6543],
        customer_name     = "CDSE Team",
        vpce_service_name = "com.amazonaws.vpce.eu-central-1.vpce-svc-0b6693df6ca5d5e6c"
    }
]
