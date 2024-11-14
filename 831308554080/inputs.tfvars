role_to_assume = "arn:aws:iam::831308554080:role/cawe/cawe-developer"
#
# trusted_entities_contracts = [
#   "arn:aws:iam::092228957173:root",
#   "arn:aws:iam::500643607194:root",
#   "arn:aws:iam::810674048896:root",
#   "arn:aws:iam::230630246195:role/daytona/daytona-developer",
#   "arn:aws:iam::230630246195:user/platform-ci",
#   "arn:aws:iam::230630246195:user/products-ci",
#   "arn:aws:iam::230630246195:user/self-services-ci",
#   "arn:aws:sts::111802884793:assumed-role/sso/Hugo.LC.Cardoso@ctw.bmwgroup.com"
# ]

kms_principals = [
    "arn:aws:iam::565128768560:root",
    "arn:aws:iam::088012017805:root",
    "arn:aws:iam::092228957173:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling",
    "arn:aws:iam::092228957173:root",
    "arn:aws:iam::500643607194:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling",
    "arn:aws:iam::500643607194:root",
    "arn:aws:iam::810674048896:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling",
    "arn:aws:iam::810674048896:root",
    "arn:aws:iam::831308554080:root",
    "arn:aws:iam::932595925475:root",
    "arn:aws:iam::641068916226:root",
    "arn:aws:iam::051351247033:root",
]

kms_arn = "arn:aws:kms:eu-central-1:831308554080:key/d3c2a829-56ca-41e4-916b-a0fc13606f34"

vpc_cidr         = "10.19.0.0/20"
vpc_subnet_count = 3


#### Nginx ####

ami_name_nginx = "nginx"

source_ami_id_nginx = "ami-09e5f5020a9ab2504"

destination_ids_nginx = ["932595925475", "565128768560", "088012017805"]
### General ###
environment           = "prd-admin"
group                 = "cawe"
project_name          = "cawe"
account_type          = "ADM"
vpc_cidr_macOs        = "12.30.0.0/18"
