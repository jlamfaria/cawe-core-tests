# macOs Ventura

- OS Version: UniversalMac_13.1_22C65

## Installed Software

To select Xcode version use `xcodes select XX.X`

- Xcode 14.2 (using [xcodes](https://github.com/RobotsAndPencils/xcodes))
- Xcode 14.3 (using [xcodes](https://github.com/RobotsAndPencils/xcodes))
- aria2 1.36.0_1
- autoconf 2.71
- brotli 1.0.9
- ca-certificates 2023-01-10
- curl 7.88.1
- dart 2.19.4
- fastlane 2.212.1
- fvm 2.4.1
- gettext 0.21.1
- gh 2.24.3
- git 2.40.0
- git-lfs 3.3.0
- jq 1.6
- libidn2 2.3.4_1
- libnghttp2 1.52.0
- libssh2 1.10.0
- libunistring 1.1
- libyaml 0.2.5
- lz4 1.9.4
- m4 1.4.19
- mpdecimal 2.5.1
- oniguruma 6.9.8
- openldap 2.6.4
- openssl@1.1 1.1.1t
- openssl@3 3.1.0
- pcre2 10.42
- pkg-config 0.29.2_3
- python@3.11 3.11.2_1
- rbenv 1.2.0
- readline 8.2.1
- rtmpdump 2.4+20151223_1
- ruby-build 20230309
- ruby@3.1 3.1.3_1
- sqlite 3.41.1
- swift 5.7.3
- swiftlint 0.50.3
- terminal-notifier 2.0.0
- unzip 6.0_8
- wget 1.21.3_1
- xcbeautify 0.17.0
- xz 5.4.1
- zip 3.0
- zstd 1.5.4
- flutter 3.3.7
- xcpretty 0.3.0
- bundler 2.4.8
- vault 1.12.2
- node 19.6.0
- consul-template 0.30.0
- cocoapods 1.11.3
- appcenter-cli 2.13.4

## Automations

- Logs are available at `~/Library/Log/CAWE/cawe.log` for the runner

- Timers

  - There is a 10-minute timer after the runner is registered. If a job is started this timer is disabled.

    - If this is enabled the timer value on `/etc/gha/metadata.json` will be true.

  - After each timer is completed the vm will be terminated, unregistering from GitHub
  - If there is no timer enabled the timer value on `/etc/gha/metadata.json` will be false.

- Hooks

  - Job Started
    - Pre-Job script - `/etc/gha/scripts/pre-job.sh`
    - Executes the validator - Disabled for now
    - Manages timer
  - Job Ended
    - Post-Job script - `/etc/gha/scripts/post-job.sh`
    - Clean-Up
    - Shutdown

- Monitoring
  - The monitoring controller is running as a service at `/Library/LaunchDaemons/monitoring_controller.plist`,
    which is being configure in the `monitoring.sh` script
  - The node metrics come from prometheus node_exporter - More info on the Monitoring controller docs
  - Fluent-bit is also installed and running as a service. The configs are imported
    from `/etc/gha/configs/fluent-bit.conf` - THis happens in the service configuration (see fluent_bit.plist file).
    The `fluent-bit.conf` file need to be modified with the instance name (using a sed command) which happens in
    the `pre-register.sh` script, launched via the API before the runner is registered
