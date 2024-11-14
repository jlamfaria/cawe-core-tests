#!/bin/bash
source /etc/gha/scripts/logging.sh # import logging script
log

file="/etc/gha/metadata.json"

host_private_ip=$(jq -r '.host_private_ip' $file)
name=$(jq -r '.name' $file)

curl -X DELETE "http://$host_private_ip/VM/?job_id=$name" -H "accept: application/json"
