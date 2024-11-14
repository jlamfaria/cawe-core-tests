#!/bin/bash
echo "Setting up machine to build"
echo "The first parameter is the github token and the second is the keychain password (needs to be the same in GH secrets)"

diskutil list external physical
PDISK=$(diskutil list physical external | head -n1 | cut -d" " -f1)
APFSCONT=$(diskutil list physical external | grep "Apple_APFS" | tr -s " " | cut -d" " -f8)
yes | sudo diskutil repairDisk $PDISK
sudo diskutil apfs resizeContainer $APFSCONT 0

sudo scutil --set HostName static-macos-runner-baremetal

mkdir actions-runner
cd actions-runner || exit
curl -O -L https://github.com/actions/runner/releases/download/v2.296.3/actions-runner-osx-arm64-2.296.3.tar.gz
tar xzf ./actions-runner-osx-arm64-2.296.3.tar.gz
./config.sh --url https://code.connected.bmw/cicd --token $1 --unattended --runnergroup CAWE --labels static-macos-runner-baremetal
./svc.sh install
./svc.sh start

#./run.sh < /dev/null > /dev/null 2> error.txt & # temporary fix due to github bug on headless macos

security create-keychain -p $2 cawe # -> the password need to be synced with the github secret
security list-keychain -d user -s cawe
security set-keychain-settings cawe

brew upgrade
brew install htop awscli packer tart
