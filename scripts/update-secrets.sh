#!/bin/bash

# Set the AWS region and profile to use
AWS_REGION=$1
# AWS_PROFILE="default"

# Set the name of the secret to check for
SECRET_NAME=$2

app_id=$3
client_id=$4
key_base64=$5
webhook_secret=$6

# Check if the secret exists
if aws secretsmanager describe-secret --region $AWS_REGION --secret-id $SECRET_NAME > /dev/null 2>&1; then
  echo "Secret $SECRET_NAME exists."
else
  echo "Secret $SECRET_NAME does not exist. Creating..."
  
  # Create the secret
  aws secretsmanager create-secret --region $AWS_REGION --name $SECRET_NAME --kms-key-id alias/cawe-main-key-new

  aws secretsmanager put-resource-policy --secret-id $SECRET_NAME --resource-policy file://./scripts/secret-policy.json

  
  echo "Secret $SECRET_NAME created."
fi

aws secretsmanager put-secret-value --secret-id $SECRET_NAME --secret-string "{\"app_id\":\"$app_id\",\"client_id\":\"$client_id\",\"key_base64\":\"$key_base64\",\"webhook_secret\":\"$webhook_secret\"}"
