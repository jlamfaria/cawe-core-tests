# macOS Ventura Hypervisor

- Base image: ami-07e696473c102733d (64-bit (Mac-Arm))

## Modifications

This AMI is a vanilla Ventura image, but with the virtualization API installed at `/etc/virtualizationAPI` running as a
service at `/Library/LaunchDaemons/virtApi_launcher.plist`

## Installed software

- Tart
- python3
- awscli
- jq
- OCI v0.2 clone

## AWS config

The following config is found at `/Users/ec2-user/.aws/config`

```
[default]
role_arn = arn:aws:iam::831308554080:role/cawe/cawe-user-role
credential_source = Ec2InstanceMetadata
```

## Login on ECR

`aws ecr get-login-password --region eu-west-1 | sudo tart login --username AWS --password-stdin 831308554080.dkr.ecr.eu-west-1.amazonaws.com`

## Tart pull

`aws ecr get-login-password --region eu-west-1 --profile cawe-user-role | sudo tart login --username AWS --password-stdin 831308554080.dkr.ecr.eu-west-1.amazonaws.com`

`tart pull 831308554080.dkr.ecr.eu-west-1.amazonaws.com/cawe-ventura:<version>`

## Packer remote connection

To build this image packer is not using SSH. A temporary policy assignment allows packer to connect via session manager.
This increases security ans does not need open ports on security groups nor ACLs. For this to work
the [aws ssm plugin](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html)
should be installed on the build machine

## Automations

- Logs are available at `~/Library/Log/CAWE/virtualizationAPI.(log | error)` for the API

- Monitoring
  - The monitoring controller is running as a service at `/Library/LaunchDaemons/monitoring_controller.plist`,
    which is being configure in the `monitoring.sh` script
  - The node metrics come from prometheus node_exporter - More info on the Monitoring controller docs
  - Fluent-bit is also installed and running as a service. The configs are imported
    from `/etc/gha/configs/fluent-bit.conf` - THis happens in the service configuration (see fluent_bit.plist file).
    The `fluent-bit.conf` file need to be modified with the instance name (using a sed command) which happens in
    the `macos-hypervisor-startup.tpl` script, at boot
