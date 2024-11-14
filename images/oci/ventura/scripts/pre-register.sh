#! /bin/sh 
 
sudo -u admin sudo brew services start node_exporter
sudo launchctl load /Library/LaunchDaemons/monitoring_controller.plist


sed "s/AWS_INSTANCE_ID/$1/" /etc/gha/configs/fluent-bit.conf > /tmp/fluent-bit.conf.tmp
mv /tmp/fluent-bit.conf.tmp /etc/gha/configs/fluent-bit.conf

sudo launchctl unload /Library/LaunchDaemons/fluent_bit.plist
sudo launchctl load /Library/LaunchDaemons/fluent_bit.plist
