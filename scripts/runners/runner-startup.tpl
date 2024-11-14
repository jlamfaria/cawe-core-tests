#! /bin/bash

export RUNNERDIR="/etc/gha"
export RUNNER_ALLOW_RUNASROOT="1"
export USER=root

handle_error() {
  echo "systemctl poweroff --no-block --force" | at now + 2 minutes
}

start_monitoring_services() {
  echo "Starting node_exporter and cawe-monitoring services"
  sudo systemctl enable node_exporter --now
  sudo systemctl enable cawe-monitoring --now

  echo "Starting fluent-bit service"
  sed "s/AWS_INSTANCE_ID/$aws_instance_id/" /etc/gha/configs/fluent-bit.conf >/tmp/fluent-bit.conf.tmp
  mv /tmp/fluent-bit.conf.tmp /etc/gha/configs/fluent-bit.conf
  sudo mv /etc/gha/configs/fluent-bit.conf /etc/fluent-bit/fluent-bit.conf
  sudo service fluent-bit restart
}

warmup_runner() {
  echo "Warming up the runners"
  nohup /etc/gha/bin/Runner.Listener warmup &
  nohup /etc/gha/bin/Runner.Worker spawnclient 0 0 &
}

echo "=========== Runner startup script ============"

echo "Retrieve instance metadata from EC2 API"
aws_token=$(curl -s --show-error -f -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 180")
aws_region=$(curl -s --show-error -f -H "X-aws-ec2-metadata-token: $aws_token" -v http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)
aws_instance_id=$(curl -s --show-error -f -H "X-aws-ec2-metadata-token: $aws_token" -v http://169.254.169.254/latest/meta-data/instance-id)

# Set redis vars for all users
# Replaced by Terraform variables
redis_url=${redis_url}
redis_port=${redis_port}
cat <<EOF > /etc/profile.d/redis_vars.sh
export REDIS_URL="$redis_url"
export REDIS_PORT="$redis_port"
EOF

chmod +x /etc/profile.d/redis_vars.sh
source /etc/profile.d/redis_vars.sh

echo "Setting hostname to $aws_instance_id"
sudo hostnamectl set-hostname "$aws_instance_id"

warmup_runner

instance_type=$(aws ec2 describe-tags \
  --filters "Name=resource-id,Values=$aws_instance_id" "Name=key,Values=Type" \
  --region $aws_region \
  --output text \
  --query 'Tags[0].Value')

if [ "$instance_type" == "adhoc" ]; then
  echo "Detected adhoc instance type"

  echo "Setting state field to registering on redis db"
  echo "Setting timer field to 0 on redis db - disable spot timer"
  redis-cli -h "$REDIS_URL" -p "$REDIS_PORT" -n 1 <<EOF
MULTI
JSON.SET $aws_instance_id $.state '"registering"'
JSON.SET $aws_instance_id $.timer 0
EXPIRE $aws_instance_id 43200
EXEC
EOF

  echo "Invoking register.sh script"
  /bin/bash /etc/gha/register.sh

  echo "Setting state field to registered on redis db"
  redis-cli -h "$REDIS_URL" -p "$REDIS_PORT" -n 1 <<EOF
MULTI
JSON.SET $aws_instance_id $.state '"registered"'
EXPIRE $aws_instance_id 43200
EXEC
EOF

  echo "The monitoring services will start in the background"
  echo "The shutdown delay of about 2 min after the job finishes should be enough to collect the logs"
  start_monitoring_services
else
  echo "Instance type is pool. Skipping Github registration"

  echo "Starting monitoring services"
  start_monitoring_services

  echo "Fetching instance data from AWS"
  instance_lifecycle=$(aws ec2 describe-instances --instance-ids "$aws_instance_id" --region "$aws_region" --query 'Reservations[*].Instances[*].[InstanceLifecycle]' --output text | grep -q 'spot' && echo spot || echo on-demand)
  tags=$(aws ec2 describe-tags --region "$aws_region" --filters "Name=resource-id,Values=$aws_instance_id")
  auto_scaling_group_name=$(echo "$tags" | jq -r '.Tags[]  | select(.Key == "aws:autoscaling:groupName") | .Value')

  echo "Setting new instance entry on redis with AWS data"
  redis-cli -h "$REDIS_URL" -p "$REDIS_PORT" -n 1 <<EOF
MULTI
JSON.SET $aws_instance_id $ '{"aws":{"instanceId": "$aws_instance_id","instanceLifecycle":"$instance_lifecycle","autoScalingGroupName":"$auto_scaling_group_name","region":"$aws_region"},"type":"$instance_type","state":"provisioned"}'
EXPIRE $aws_instance_id 86400
EXEC
EOF

  if [ $? -ne 0 ]; then
    echo "Failed set instance matadata on redis db"
    handle_error
  fi

  if [ "$instance_lifecycle" == "spot" ]; then
    echo "Setting timer field to -1 (spot) on redis"
    redis-cli -h "$REDIS_URL" -p "$REDIS_PORT" -n 1 <<EOF
MULTI
JSON.SET $aws_instance_id $.timer '"-1"'
EXPIRE $aws_instance_id 86400
EXEC
EOF

    echo "Enabling spot shutdown timer service"
    nohup ./scripts/timer.sh 7200 >> /var/log/cawe.log &
    true
  fi

  sleep 45s

  echo "Add instance id to correspondent redis stack"
  redis-cli -h  "$REDIS_URL" -p "$REDIS_PORT" -n 0 RPUSH $auto_scaling_group_name $aws_instance_id

  if [ $? -ne 0 ]; then
    echo "Failed to add instance to correspondent redis stack"
    handle_error
  fi
fi
