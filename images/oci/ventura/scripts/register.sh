#!/bin/bash
source /etc/gha/scripts/logging.sh # import logging script
log
#This script will be inside the vm and register the runner by receiving the token as its first parameter
export RUNNERDIR="/etc/gha"
export RUNNER_ALLOW_RUNASROOT="1"
echo "=========== Retrieve runner parameters ============"
cd $RUNNERDIR
./config.sh --unattended  --ephemeral --url "$1" --token "$2"  --runnergroup CAWE --labels "$3"

echo "=========== Starting Github Runner as a service ============"
./svc.sh install
./svc.sh start

echo "Invoking shutdown timer script in the background"
nohup /etc/gha/scripts/timer.sh >> /Users/admin/Library/Logs/CAWE/cawe.log 2>&1 & disown

echo "Register complete"

