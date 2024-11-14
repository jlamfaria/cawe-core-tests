#!/bin/bash
echo "=========== Starting shutdown timer ============"

delay=600 # 10 minutes

echo "[TIMER] Starting count down for $delay seconds"

sleep $delay

echo "[TIMER] Count down ended"

echo "[TIMER] Extracting values from metadata file"
file="/etc/gha/metadata.json"
echo "[TIMER] Metadata file path: $file"

timer=$(jq -r '.timer' $file)
github_token=$(jq -r '.github.token' $file)

if [ "$timer" = true ] ; then
    echo "[TIMER] Unregistering from Github"
    # unregister runner from github
    /etc/gha/svc.sh uninstall
    sudo RUNNER_ALLOW_RUNASROOT="1" /etc/gha/config.sh remove --token $github_token

    /etc/gha/scripts/post-job.sh
fi
