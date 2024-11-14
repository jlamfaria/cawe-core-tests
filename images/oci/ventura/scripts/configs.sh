curl http://sslcrl.bmwgroup.com/pki/BMW_Trusted_Certificates_Latest.pem >> ~/BMW.pem
sudo security import ~/BMW.pem -k ~/Library/Keychains/login.keychain
rm ~/BMW.pem