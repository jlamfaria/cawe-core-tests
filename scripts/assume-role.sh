#! /bin/bash
account=$1

function assume-role() {
OUT=$(aws sts assume-role --role-arn $1 --role-session-name $2);\
export AWS_ACCESS_KEY_ID=$(echo $OUT | jq -r '.Credentials''.AccessKeyId');\
export AWS_SECRET_ACCESS_KEY=$(echo $OUT | jq -r '.Credentials''.SecretAccessKey');\
export AWS_SESSION_TOKEN=$(echo $OUT | jq -r '.Credentials''.SessionToken');
}

assume-role "arn:aws:iam::$account:role/cawe/cawe-developer" "bucketsession"
