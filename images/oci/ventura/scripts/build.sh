brew tap dart-lang/dart
brew tap leoafarias/fvm

brew install fastlane git swift swiftlint dart rbenv xcbeautify fvm vault node consul-template cocoapods aria2

fvm install 3.3.7

echo "export PATH=$PATH:/Users/admin/fvm/default/bin" >> ~/.zshenv
source ~/.zshenv

fvm global 3.3.7

cat ~/.zshenv
flutter

echo "if which rbenv > /dev/null; then eval '$(rbenv init -)'; fi" >> ~/.zshenv
source ~/.zshenv

rbenv install 3.0.5
rbenv global 3.0.5

gem install bundler

gem install xcpretty

curl -Ls https://install.tuist.io | bash

npm install --location=global appcenter-cli
