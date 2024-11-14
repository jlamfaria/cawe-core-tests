#!/bin/bash
source /etc/gha/scripts/logging.sh # import logging script
log

echo "=========== Starting pre-job ============"

echo "Fetching metadata information from metadata.json file"
file="/etc/gha/metadata.json"
github_org=$(jq -r '.github.org' $file)

# Set timer to false
echo "Disabling shutdown timer"
timer=$(jq '.timer' $file)
if [ "$timer" == "true" ]; then
  jq '.timer |= false' $file > "$file.tmp" && mv "$file.tmp" $file
fi

echo "Invoking the validator script"
echo "WARN: Not implemented yet on macos -> $github_org"
#/bin/bash /etc/gha/scripts/validator.sh $github_org
