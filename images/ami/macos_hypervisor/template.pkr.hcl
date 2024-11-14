// Init
packer {
  required_plugins {
    amazon = {
      version = "~> 1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

// Variables

variable "root_volume_size_gb" {
  type = number
}

variable "keychain_key" {
  sensitive = true
}

variable "ebs_delete_on_termination" {
  description = "Indicates whether the EBS volume is deleted on instance termination."
  type        = bool
  default     = true
}

variable "region" {
  description = "The region to build the image in"
  type        = string
}

variable "security_group_id" {
  description = "The ID of the security group Packer will associate with the builder to enable access"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "If using VPC, the ID of the vpc."
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "If using VPC, the ID of the subnet, such as subnet-12345def, where Packer will launch the EC2 instance. This field is required if you are using an non-default VPC"
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "If using a non-default VPC, there is no public IP address assigned to the EC2 instance. If you specified a public subnet, you probably want to set this to true. Otherwise the EC2 instance won't have access to the internet"
  type        = string
  default     = null
}

# Config
variable "role_to_assume" {
  type        = string
  description = "Role to Assume during terraform execution."
}

# Project
variable "naming_prefix" {
  type        = string
  description = "Naming prefix for all resources"
  default     = "gha"
}

variable "project_name" {
  type        = string
  description = "Project Name of this deployment"
  default     = "GitHub Actions"
}

variable "environment" {
  type        = string
  description = "(Set by pipeline) Used to derive names of AWS resources. Use this to distinguish different enviroments"
  default     = "global" # TODO remove as soon as deployment jobs are fixed to pass the value
}

locals {
  tags = {
    group   = var.naming_prefix
    project = var.project_name
    module  = "macos_hypervisor"
  }

  name_prefix = "${var.naming_prefix}-${var.environment}"
}

data "amazon-ami" "macos-sonoma-ami" {
  filters = {
    virtualization-type = "hvm"
    name = "amzn-ec2-macos-14.*"
    architecture = "arm64_mac"
    root-device-type = "ebs"
  }
  owners = ["100343932686"]
  most_recent = true
}

// Source
source "amazon-ebs" "macos-hypervisor" {
  assume_role {
    role_arn = var.role_to_assume
  }
  ssh_username            = "ec2-user"
  ssh_timeout             = "2h"
  ami_name                = "hypervisor-mac-arm64-${formatdate("YYYYMMDDhhmm", timestamp())}"
  ami_virtualization_type = "hvm"
  tenancy                 = "host"
  ebs_optimized           = true
  instance_type           = "mac2.metal"
  region                  = var.region
  ssh_interface           = "session_manager"
  source_ami              = data.amazon-ami.macos-sonoma-ami.id

  vpc_id                      = var.vpc_id
  subnet_id                   = var.subnet_id
  security_group_id           = var.security_group_id
  associate_public_ip_address = var.associate_public_ip_address

  tags = merge(
    local.tags,
    {
      OS_Version    = data.amazon-ami.macos-sonoma-ami.name
      Release       = "14"
      Creation_Date = data.amazon-ami.macos-sonoma-ami.creation_date
    }
  )

  snapshot_tags = merge(
    local.tags
  )

  run_tags = merge(
    local.tags,
    {
      Name       = "${local.name_prefix}-packer-instance-${formatdate("YYYYMMDDhhmm", timestamp())}"
      automation = "Packer"
    }
  )

  aws_polling {
    delay_seconds = 60
    max_attempts  = 600
  }

  launch_block_device_mappings {
    device_name           = "/dev/sda1"
    volume_size           = 300
    volume_type           = "gp3"
    iops                  = 3000
    throughput            = 500
    delete_on_termination = true
  }

  iam_instance_profile = "cawe-runner-instance-profile"

  temporary_iam_instance_profile_policy_document {
    Version = "2012-10-17"
    Statement {
      Effect = "Allow"
      Action = [
        "ssm:DescribeAssociation",
        "ssm:GetDeployablePatchSnapshotForInstance",
        "ssm:GetDocument",
        "ssm:DescribeDocument",
        "ssm:GetManifest",
        "ssm:GetParameter",
        "ssm:GetParameters",
        "ssm:ListAssociations",
        "ssm:ListInstanceAssociations",
        "ssm:PutInventory",
        "ssm:PutComplianceItems",
        "ssm:PutConfigurePackageResult",
        "ssm:UpdateAssociationStatus",
        "ssm:UpdateInstanceAssociationStatus",
        "ssm:UpdateInstanceInformation"
      ]
      Resource = ["*"]
    }
    Statement {
      Effect = "Allow"
      Action = [
        "ssmmessages:CreateControlChannel",
        "ssmmessages:CreateDataChannel",
        "ssmmessages:OpenControlChannel",
        "ssmmessages:OpenDataChannel"
      ]
      Resource = ["*"]
    }
    Statement {
      Effect = "Allow"
      Action = [
        "ec2messages:AcknowledgeMessage",
        "ec2messages:DeleteMessage",
        "ec2messages:FailMessage",
        "ec2messages:GetEndpoint",
        "ec2messages:GetMessages",
        "ec2messages:SendReply"
      ]
      Resource = ["*"]
    }
  }
}

build {
  name    = "macos-hypervisor"
  sources = [
    "source.amazon-ebs.macos-hypervisor"
  ]

  provisioner "shell" {
    inline = [
      "sudo /usr/local/bin/ec2-macos-init clean --all"
    ]
  }

  provisioner "shell" {
    inline = [
      "date",
      "/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"",
      "echo \"export LANG=en_US.UTF-8\" >> ~/.zshenv",
      "echo 'eval \"$(/opt/homebrew/bin/brew shellenv)\"' >> ~/.zshenv",
      "echo \"export HOMEBREW_NO_AUTO_UPDATE=1\" >> ~/.zshenv",
      "echo \"export HOMEBREW_NO_INSTALL_CLEANUP=1\" >> ~/.zshenv",
      "source ~/.zshenv",
      "brew --version",
      "date"
    ]
  }

  provisioner "shell" {
    inline = [
      "brew update",
      "brew upgrade",
      "brew install cirruslabs/cli/tart",
      "brew install wget cmake gcc jq gh python3 awscli htop bmon redis",
      "echo \"export PATH=/usr/local/bin:$PATH\" >> ~/.zshenv ",
      "date",
    ]
  }

  provisioner "shell" {
    inline = [
      "echo \"expand volume to the size of disk\"",
      "diskutil list external physical",
      "PDISK=$(diskutil list physical external | head -n1 | cut -d \" \" -f1)",
      "APFSCONT=$(diskutil list physical external | grep \"Apple_APFS\" | tr -s \" \" | cut -d\" \" -f8)",
      "yes | sudo diskutil repairDisk $PDISK",
      "sudo diskutil apfs resizeContainer $APFSCONT 0",
    ]
    valid_exit_codes = [0, 1]
  }

  provisioner "shell" {
    //creating a custom keychain to fix Error: Failed(message: "Keychain failed to add item: Unable to obtain authorization for this operation.
    environment_vars = ["KEYCHAIN_KEY=${var.keychain_key}"]
    inline = [
      "echo \"Creating  new keychain cawe ...\"",
      "sudo security authorizationdb write com.apple.trust-settings.admin allow",
      "security create-keychain -p $KEYCHAIN_KEY cawe",
      "security list-keychain -d user -s cawe",
      "security set-keychain-settings cawe",
      "security unlock-keychain -p $KEYCHAIN_KEY cawe",
      "security default-keychain -s /Users/ec2-user/Library/Keychains/cawe-db",
      "security list-keychains",
      "sudo security authorizationdb remove com.apple.trust-settings.admin"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo \"Configure aws credentials to pull image\"",
      "mkdir ~/.aws/",
      "cd ~/.aws/ && touch config",
      "cd ~/.aws/ && echo \"[profile cawe-user-role]\" >> config",
      "cd ~/.aws/ && echo \"role_arn = arn:aws:iam::831308554080:role/cawe/cawe-user-role\" >> config",
      "cd ~/.aws/ && echo \"credential_source = Ec2InstanceMetadata\" >> config"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo \"ECR login\"",
      "echo $PATH",
      "printenv",
      "which tart",
      "aws ecr get-login-password --region eu-west-1 --profile cawe-user-role | sudo tart login --username AWS --password-stdin 831308554080.dkr.ecr.eu-west-1.amazonaws.com",
      "echo \"Get latest image tag or use the value passed as the first parameter\"",
      #TODO regex for vx.x.x
      "latest_version=$(aws ecr describe-images --repository-name cawe-sonoma --profile cawe-user-role --query 'reverse(sort_by(imageDetails, &imageTags[0])) | [0].imageTags[]' --output json | jq -r '.[0]')",
      "echo \"using $latest_version\"",
      "echo \"Pull image from ECR\"",
      "tart pull 831308554080.dkr.ecr.eu-west-1.amazonaws.com/cawe-sonoma:$latest_version"
    ]
  }

  #Virtualization API
  provisioner "shell" {
    inline = [
      "sudo mkdir -p /tmp/virtualizationAPI/",
      "sudo mkdir -p /etc/virtualizationAPI",
      "sudo chown ec2-user:staff /tmp/virtualizationAPI/",
      "sudo chown ec2-user:staff /etc/virtualizationAPI",
      "sudo mkdir -p /tmp/scripts/",
      "sudo mkdir -p /etc/gha/scripts",
      "sudo chown ec2-user:staff /tmp/scripts/",
      "sudo chown ec2-user:staff /etc/gha/scripts",
      "sudo mkdir -p /tmp/configs/",
      "sudo mkdir -p /etc/gha/configs",
      "sudo chown ec2-user:staff /tmp/configs/",
      "sudo chown ec2-user:staff /etc/gha/configs",
      "sudo mkdir -p /tmp/common",
      "sudo mkdir -p /etc/gha/common",
      "sudo chown ec2-user:staff /tmp/common/",
      "sudo chown ec2-user:staff /etc/gha/common/"
    ]
  }

  provisioner "file" {
    source      = "./../../../virtualizationAPI/"
    destination = "/tmp/virtualizationAPI/"
  }

  provisioner "file" {
    source      = "./scripts/"
    destination = "/tmp/scripts/"
  }

  provisioner "file" {
    source      = "./configs/"
    destination = "/tmp/configs/"
  }

  provisioner "file"{
    source = "../../common/"
    destination = "/tmp/common"
  }

  provisioner "shell" {
    inline = [
      "/etc/gha/scripts/certificates.sh",
    ]
  }

  provisioner "shell" {
    inline = [
      "ls -la /tmp/virtualizationAPI/ && sudo mv -v /tmp/virtualizationAPI/ /etc/ && ls -la /etc/virtualizationAPI/",
      "ls -la /tmp/scripts/ && sudo mv -v /tmp/scripts/ /etc/gha/ && ls -la /etc/gha/scripts/",
      "ls -la /tmp/configs/ && sudo mv -v /tmp/configs/ /etc/gha/ && ls -la /etc/gha/configs/",
      "ls -la /tmp/common/ && sudo mv -v /tmp/common/ /etc/gha/ && ls -la /etc/gha/common/",
      "chmod +x /etc/gha/scripts/*.sh",
      "curl http://sslcrl.bmwgroup.com/pki/BMW_Trusted_Certificates_Latest.pem >> /etc/gha/configs/BMW.pem"
    ]
  }

  provisioner "shell" {
    inline = ["sudo cp /etc/virtualizationAPI/virtApi_launcher.plist /Library/LaunchDaemons/"]
  }

  provisioner "shell" {
    inline = [
      "echo \"Install API as a service\"",
      "pip3 install -r /etc/virtualizationAPI/requirements.txt --break-system-packages",
      "sudo chown root:wheel /Library/LaunchDaemons/virtApi_launcher.plist",
      "sudo chmod 600 /Library/LaunchDaemons/virtApi_launcher.plist",
      "sudo launchctl bootstrap system /Library/LaunchDaemons/virtApi_launcher.plist",
      "sudo brew services start redis"
    ]
  }

  provisioner "shell" {
    inline = ["sudo cp /etc/gha/configs/monitoring_controller.plist /Library/LaunchDaemons/"]
  }

  provisioner "shell" {
    inline = [
      "echo \"Install monitoring service\"",
      "pip3 install -r /etc/gha/common/monitoring_controller/requirements.txt --break-system-packages",
      "sudo chown root:wheel /Library/LaunchDaemons/monitoring_controller.plist",
      "sudo chmod 600 /Library/LaunchDaemons/monitoring_controller.plist",
    ]
  }

  provisioner "shell" {
    inline = ["sudo cp /etc/gha/configs/fluent_bit.plist /Library/LaunchDaemons/"]
  }

  provisioner "shell" {
    inline = [
      "echo \"Install fluent bit service\"",
      "sudo chown root:wheel /Library/LaunchDaemons/fluent_bit.plist",
      "sudo chmod 600 /Library/LaunchDaemons/fluent_bit.plist"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo \"Monitoring Setup\"",
      "/etc/gha/scripts/monitoring.sh"
    ]
  }
}
