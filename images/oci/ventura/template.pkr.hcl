packer {
  required_plugins {
    tart = {
      version = ">= 0.5.4"
      source  = "github.com/cirruslabs/tart"
    }
  }
}

variable "xcode_version" {
  type = string
}

variable "gha_version" {
  type = string
}

source "tart-cli" "tart" {
  # You can find macOS IPSW URLs on various websites like https://ipsw.me/
  # and https://www.theiphonewiki.com/wiki/Beta_Firmware/Mac/13.x
  run_extra_args = ["--dir=files:files"]
  from_ipsw      = "./files/Restore/UniversalMac_13.1_22C65_Restore.ipsw"
  vm_name        = "cawe-ventura"
  cpu_count      = 4
  memory_gb      = 8
  disk_size_gb   = 150
  ssh_password   = "admin"
  ssh_username   = "admin"
  ssh_timeout    = "120s"
  boot_command   = [
    # hello, hola, bonjour, etc.
    "<wait60s><spacebar>",
    # Language
    "<wait30s>english<enter>",
    # Select Your Country and Region
    "<wait30s>united states<leftShiftOn><tab><leftShiftOff><spacebar>",
    # Written and Spoken Languages
    "<wait10s><leftShiftOn><tab><leftShiftOff><spacebar>",
    # Accessibility
    "<wait10s><leftShiftOn><tab><leftShiftOff><spacebar>",
    # Data & Privacy
    "<wait10s><leftShiftOn><tab><leftShiftOff><spacebar>",
    # Migration Assistant
    "<wait10s><tab><tab><tab><spacebar>",
    # Sign In with Your Apple ID
    "<wait10s><leftShiftOn><tab><leftShiftOff><leftShiftOn><tab><leftShiftOff><spacebar>",
    # Are you sure you want to skip signing in with an Apple ID?
    "<wait10s><tab><spacebar>",
    # Terms and Conditions
    "<wait10s><leftShiftOn><tab><leftShiftOff><spacebar>",
    # I have read and agree to the macOS Software License Agreement
    "<wait10s><tab><spacebar>",
    # Create a Computer Account
    "<wait10s>admin<tab><tab>admin<tab>admin<tab><tab><tab><spacebar>",
    # Enable Location Services
    "<wait30s><leftShiftOn><tab><leftShiftOff><spacebar>",
    # Are you sure you don't want to use Location Services?
    "<wait20s><tab><spacebar>",
    # Select Your Time Zone
    "<wait20s><tab>UTC<enter><wait10s><leftShiftOn><tab><leftShiftOff><spacebar>",
    # Analytics
    "<wait30s><leftShiftOn><tab><leftShiftOff><spacebar>",
    # Screen Time
    "<wait10s><tab><spacebar>",
    # Siri
    "<wait10s><tab><spacebar><leftShiftOn><tab><leftShiftOff><spacebar>",
    # Choose Your Look
    "<wait10s><leftShiftOn><tab><leftShiftOff><spacebar>",
    # Enable Voice Over
    "<wait10s><leftAltOn><f5><leftAltOff><wait5s>v",
    # Now that the installation is done, open "System Settings"
    "<wait10s><leftAltOn><spacebar><leftAltOff>System Settings<enter>",
    # Navigate to "Sharing"
    "<wait10s><leftAltOn>f<leftAltOff>sharing<enter>",
    # Navigate to "Screen Sharing" and enable it
    "<wait10s><tab><down><spacebar>",
    # Navigate to "Remote Login" and enable it
    "<wait10s><tab><tab><tab><tab><tab><tab><spacebar>",
    # Open "Remote Login" details
    "<wait10s><tab><spacebar>",
    # Enable "Full Disk Access"
    "<wait10s><tab><spacebar>",
    # Click "Done"
    "<wait10s><leftShiftOn><tab><leftShiftOff><leftShiftOn><tab><leftShiftOff><spacebar>",
    # Disable Voice Over
    "<leftAltOn><f5><leftAltOff>",
  ]

  // A (hopefully) temporary workaround for Virtualization.Framework's
  // installation process not fully finishing in a timely manner
  create_grace_time = "30s"
}

build {
  sources = ["source.tart-cli.tart"]


  provisioner "shell" {
    inline = [
      "date",
      // Enable passwordless sudo
      "echo admin | sudo -S sh -c \"echo 'admin ALL=(ALL) NOPASSWD: ALL' | EDITOR=tee visudo /etc/sudoers.d/admin-nopasswd\"",
      // Enable auto-login
      //
      // See https://github.com/xfreebird/kcpassword for details.
      "echo '00000000: 1ced 3f4a bcbc ba2c caca 4e82' | sudo xxd -r - /etc/kcpassword",
      "sudo defaults write /Library/Preferences/com.apple.loginwindow autoLoginUser admin",
      // Disable screensaver at login screen
      "sudo defaults write /Library/Preferences/com.apple.screensaver loginWindowIdleTime 0",
      // Prevent the VM from sleeping
      "sudo systemsetup -setdisplaysleep Off",
      "sudo systemsetup -setsleep Off",
      "sudo systemsetup -setcomputersleep Off",
      // Launch Safari to populate the defaults
      "/Applications/Safari.app/Contents/MacOS/Safari &",
      "sleep 30",
      "kill -9 %1",
      // Enable Safari's remote automation and "Develop" menu
      "sudo safaridriver --enable",
      "defaults write com.apple.Safari.SandboxBroker ShowDevelopMenu -bool true",
      "defaults write com.apple.Safari IncludeDevelopMenu -bool true",
      // Disable screen lock
      //
      // Note that this only works if the user is logged-in,
      // i.e. not on login screen.
      "sysadminctl -screenLock off -password admin",
    ]
  }

  provisioner "shell" {
    inline = [
      "date",
      "echo 'Disabling spotlight...'",
      "sudo mdutil -a -i off",
    ]
  }

  provisioner "shell" {
    inline = [
      "echo 'Brew setup...'",
      "date",
      "/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"",
      "echo \"export LANG=en_US.UTF-8\" >> ~/.zshenv",
      "echo 'eval \"$(/opt/homebrew/bin/brew shellenv)\"' >> ~/.zshenv",
      "echo \"export HOMEBREW_NO_AUTO_UPDATE=1\" >> ~/.zshenv",
      "echo \"export HOMEBREW_NO_INSTALL_CLEANUP=1\" >> ~/.zshenv",
      "source ~/.zshenv",
      "brew --version",
      "date",
      "brew update",
      "brew upgrade",
      "brew install wget git-lfs jq gh curl wget unzip zip ca-certificates python3 xcodes",
      "git lfs install",
      "sudo softwareupdate --install-rosetta --agree-to-license"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo 'Enable safari...'",
      "date",
      "sudo safaridriver --enable",
    ]
  }

  provisioner "shell" {
    inline = [
      "echo 'Folder setup...'",
      "date",
      "sudo mkdir /etc/gha",
      "sudo chown admin:staff /etc/gha",
      "sudo touch /etc/gha/register.sh",
      "sudo chown admin:staff /etc/gha/register.sh",
      "sudo install -m 777 /etc/gha/register.sh /etc/gha/",
      "cd /etc/gha && curl -O -L https://github.com/actions/runner/releases/download/v${var.gha_version}/actions-runner-osx-arm64-${var.gha_version}.tar.gz",
      "cd /etc/gha && tar xzf ./actions-runner-osx-arm64-${var.gha_version}.tar.gz",
      "cd /etc/gha && rm actions-runner-osx-arm64-${var.gha_version}.tar.gz",
    ]
  }

  provisioner "shell" {
    inline = [
      "echo 'Permissions setup...'",
      "sudo mkdir  /tmp/scripts/",
      "sudo mkdir /etc/gha/scripts",
      "sudo chown admin:staff /tmp/scripts/",
      "sudo chown admin:staff /etc/gha/scripts",
      "sudo mkdir  /tmp/configs/",
      "sudo mkdir /etc/gha/configs",
      "sudo chown admin:staff /tmp/configs/",
      "sudo chown admin:staff /etc/gha/configs",
      "sudo mkdir -p /tmp/common",
      "sudo mkdir -p /etc/gha/common",
      "sudo chown admin:staff /tmp/common/",
      "sudo chown admin:staff /etc/gha/common/",
      "sudo mkdir /etc/gha/xcode"

    ]
  }

  provisioner "file" {
    source      = "./scripts/"
    destination = "/tmp/scripts/"
  }

  provisioner "file" {
    source      = "./configs/"
    destination = "/tmp/configs/"
  }

  provisioner "file" {
    source      = "../../common/"
    destination = "/tmp/common/"
  }

  provisioner "shell" {
    inline = [
      "echo 'Move files...'",
      "ls -la /tmp/scripts/ && sudo mv -v /tmp/scripts/ /etc/gha/ && ls -la /etc/gha/scripts/",
      "ls -la /tmp/configs/ && sudo mv -v /tmp/configs/ /etc/gha/ && ls -la /etc/gha/configs/",
      "ls -la /tmp/common/ && sudo mv -v /tmp/common/ /etc/gha/ && ls -la /etc/gha/common/",
      "chmod +x /etc/gha/scripts/*.sh",
      "ls -ls /etc/gha/scripts/",
      "mkdir -p /Users/admin/Library/Logs/CAWE",
      "touch /Users/admin/Library/Logs/CAWE/cawe.log"
    ]
  }

  provisioner "shell" {
    inline = ["sudo cp /etc/gha/configs/monitoring_controller.plist /Library/LaunchDaemons/"]
  }

  provisioner "shell" {
    inline = [
      "echo \"Install monitoring service\"",
      "pip3 install -r /etc/gha/common/monitoring_controller/requirements.txt",
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
      "sudo chmod 600 /Library/LaunchDaemons/fluent_bit.plist",
    ]
  }

  provisioner "shell" {
    inline = [
      "echo \"Moving files from mounted directory\"",
      "mv -v /Volumes/My\\ Shared\\ Files/files/xcode/ /etc/gha/",
      "ls -la /etc/gha/xcode"
    ]
  }


  provisioner "shell" {
    inline = [
      "echo 'Install...'",
      "sudo /etc/gha/scripts/xcode.sh 14.3",
      "sudo /etc/gha/scripts/xcode.sh 14.2",
      "xcodes select 14.2",
      "/etc/gha/scripts/build.sh",
      "/etc/gha/scripts/configs.sh",
      "/etc/gha/scripts/monitoring.sh",
    ]
  }

  provisioner "shell" {
    inline = [
      "echo 'Apple Certificates...'",
      "date",
      "source ~/.zshenv",
      "sudo security delete-certificate -Z FF6797793A3CD798DC5B2ABEF56F73EDC9F83A64 /Library/Keychains/System.keychain",
      "curl -o add-certificate.swift https://raw.githubusercontent.com/actions/runner-images/fb3b6fd69957772c1596848e2daaec69eabca1bb/images/macos/provision/configuration/add-certificate.swift",
      "swiftc add-certificate.swift",
      "curl -o AppleWWDRCAG3.cer https://www.apple.com/certificateauthority/AppleWWDRCAG3.cer",
      "curl -o DeveloperIDG2CA.cer https://www.apple.com/certificateauthority/DeveloperIDG2CA.cer",
      "sudo ./add-certificate AppleWWDRCAG3.cer",
      "sudo ./add-certificate DeveloperIDG2CA.cer",
      "rm add-certificate* *.cer"
    ]
  }

    provisioner "shell" {
    inline = [
      "echo 'Cleanup...'",
      "sudo rm -R /etc/gha/xcode"
    ]
  }
}
