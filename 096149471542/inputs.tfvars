role_to_assume = "arn:aws-cn:iam::096149471542:role/cawe/cawe-developer"

kms_principals = [
    "arn:aws-cn:iam::096149471542:root",
    "arn:aws-cn:iam::090973320140:root",
    "arn:aws-cn:iam::090974794329:root",
    "arn:aws-cn:iam::090975101271:root"
]

### General ###
environment  = "prd-admin"
group        = "cawe"
project_name = "cawe"
region       = "cn-north-1"
account_type = "ADM"
