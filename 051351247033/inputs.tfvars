role_to_assume = "arn:aws:iam::051351247033:role/cawe/cawe-developer"

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

environment  = "int"
group        = "cawe"
project_name = "cawe"
account_type = "ORBIT"
