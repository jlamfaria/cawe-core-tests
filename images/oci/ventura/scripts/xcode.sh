# $1 -> xcode version
echo "Installing xcode $1 ...."
xcodes install $1 --experimental-unxip --path /etc/gha/xcode/Xcode_$1.xip
xcodes select $1
xcodebuild -downloadAllPlatforms
xcodebuild -runFirstLaunch
