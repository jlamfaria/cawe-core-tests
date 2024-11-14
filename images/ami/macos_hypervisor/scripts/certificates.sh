#!/bin/bash

echo 'Install certificates'
count_certs() {
  security find-certificate -a -p /Library/Keychains/System.keychain | grep "BEGIN CERTIFICATE" | wc -l
}
KEYCHAIN="/Library/Keychains/System.keychain"
PKI_URL="http://sslcrl.bmwgroup.com/pki/BMW_Trusted_Certificates_Latest.zip"

current_certs=$(count_certs)
echo "Current number of certificates: $current_certs"

TMPDIR=$(mktemp -d)

echo 'Download BMW certificates'
wget -nv -O "$TMPDIR/BMW_Trusted_Certificates_Latest.zip" $PKI_URL
if [ $? -ne 0 ]; then
  echo "Failed to download certificates."
  exit 1
fi

unzip -q "$TMPDIR/BMW_Trusted_Certificates_Latest.zip" -d "$TMPDIR"
if [ $? -ne 0 ]; then
  echo "Failed to unzip certificates."
  exit 1
fi

INTERMEDIATE_DIR=$(find "$TMPDIR" -type d -name "Intermediate" -print -quit)
ROOT_DIR=$(find "$TMPDIR" -type d -name "Root" -print -quit)

echo "Allowing security authorization"
sudo security authorizationdb write com.apple.trust-settings.admin allow
if [ $? -ne 0 ]; then
  echo "Failed to allow security authorization."
  exit 1
fi

if [ -n "$INTERMEDIATE_DIR" ]; then
  for cert in "$INTERMEDIATE_DIR"/*.crt; do
    sudo security add-trusted-cert -d -r trustAsRoot -p ssl -k "$KEYCHAIN" "$cert"
    if [ $? -ne 0 ]; then
      echo "Failed to add intermediate certificate: $cert"
    else
      echo "Added certificate: $cert"
    fi
  done
else
  echo "Intermediate directory not found."
  exit 1
fi

if [ -n "$ROOT_DIR" ]; then
  for cert in "$ROOT_DIR"/*.crt; do
    sudo security add-trusted-cert -d -r trustRoot -p ssl -k "$KEYCHAIN" "$cert"
    if [ $? -ne 0 ]; then
      echo "Failed to add root certificate: $cert"
    else
      echo "Added certificate: $cert"
    fi
  done
else
  echo "Root directory not found."
  exit 1
fi

echo "Disallowing security authorization"
sudo security authorizationdb remove com.apple.trust-settings.admin
if [ $? -ne 0 ]; then
  echo "Failed to disallow security authorization."
  exit 1
fi

new_certs=$(count_certs)
echo "New number of certificates: $new_certs"
echo "Number of certificates added: $(($new_certs - $current_certs))"

# Clean up temporary files
rm -rf "$TMPDIR"
