#! /bin/sh

PDISK=$(diskutil list physical external | head -n1 | cut -d" " -f1)
APFSCONT=$(diskutil list physical external | grep "Apple_APFS" | tr -s " " | cut -d" " -f8)
yes | sudo diskutil repairDisk "$PDISK"
sudo diskutil apfs resizeContainer "$APFSCONT" 0

echo "Retrieve instance metadata from EC2 API"
aws_token=$(curl -f -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 180")
aws_region=$(curl -f -H "X-aws-ec2-metadata-token: $aws_token" -v http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)
aws_instance_id=$(curl -f -H "X-aws-ec2-metadata-token: $aws_token" -v http://169.254.169.254/latest/meta-data/instance-id)

echo "Setting hostname to $aws_instance_id"
sudo scutil --set HostName "$aws_instance_id"

sudo -u ec2-user brew update
sudo -u ec2-user brew upgrade

sudo -u ec2-user sudo brew services start node_exporter

sudo launchctl load /Library/LaunchDaemons/monitoring_controller.plist

sed "s/AWS_INSTANCE_ID/$aws_instance_id/" /etc/gha/configs/fluent-bit.conf >/tmp/fluent-bit.conf.tmp
mv /tmp/fluent-bit.conf.tmp /etc/gha/configs/fluent-bit.conf

sudo launchctl unload /Library/LaunchDaemons/fluent_bit.plist
sudo launchctl load /Library/LaunchDaemons/fluent_bit.plist
