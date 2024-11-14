### Runer setup

To run this build we cannot use our runners because they rely on virtualization and Apples virtualization framework does not support nested virtualization (the build process creates a vm)

The solution is to create a static, bare metal runner running the [script](./runner_setup.sh) in a normal EC2 instance with network connection. the script accepts two parameters, the first one is a github runner registration token and the second is the keychain password that should match the one in github secrets
Note: this instance needs to have vnc enabled and the script need to be executed via VNC because of a bug in the GitHub runner that does not allow to run the config script in headless mode [how-to](https://aws.amazon.com/premiumsupport/knowledge-center/ec2-mac-instance-gui-access/)
