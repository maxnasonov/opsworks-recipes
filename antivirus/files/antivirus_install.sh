#!/bin/bash

if [ -z "$AWS_ACCOUNT" ]; then
    echo "ERROR: AWS_ACCOUNT is not defined."
    exit 1
fi

FILE=/usr/bin/apt-get
if [ -f "$FILE" ]; then
  PKG_NAME=falcon-sensor_5.38.0-10404_amd64.deb
  sudo /usr/bin/curl -o /tmp/$PKG_NAME https://antivirusdownloadbucket.s3.amazonaws.com/Crowdstrike/Ubunutu/$PKG_NAME
  test $? -ne 0 && { echo "Unable to copy file from S3"; exit 1; }
  sudo apt-get -y install libnl-3-200 libnl-genl-3-200
  test $? -ne 0 && { echo "Unable to install libnl-3-200 libnl-genl-3-200"; exit 1; }
  sudo dpkg -i /tmp/$PKG_NAME
  test $? -ne 0 && { echo "Unable to install falcon file"; exit 1; }
  apt list --installed 2>/dev/null | grep falcon
  test $? -ne 0 && { echo "Falcon package not listed after install"; exit 1; }
  sudo /opt/CrowdStrike/falconctl -s -f --cid=4686E5ECEED0487FA94E8A1C3A0ADF76-A8 --provisioning-token=87191FA1
  sudo /opt/CrowdStrike/falconctl -s -f --tags="AWS-$AWS_ACCOUNT"
  test $? -ne 0 && { echo "Error in registration of falconctl"; exit 1; }
  sudo service falcon-sensor start
  test $? -ne 0 && { echo "Error in starting falcon-sensor"; exit 1; }
  sudo rm -f /tmp/$PKG_NAME 2> /dev/null
  exit 0
fi

# Amazon Linux AMI (amzn1)
if uname -r | grep amzn1 >/dev/null; then
  PKG_NAME=falcon-sensor-5.43.0-10801.amzn1.x86_64.rpm
  sudo /usr/bin/curl -o /tmp/$PKG_NAME https://antivirusdownloadbucket.s3.amazonaws.com/Crowdstrike/AL1/$PKG_NAME

  test $? -ne 0 && { echo "Unable to copy file from S3"; exit 1; }
  sudo yum -q -y install libnl
  test $? -ne 0 && { echo "Unable to install libnl"; exit 1; }
  sudo rpm -i /tmp/$PKG_NAME
  yum list installed 2>/dev/null | grep falcon
  test $? -ne 0 && { echo "Falcon package not listed after install"; exit 1; }
  sudo /opt/CrowdStrike/falconctl -s -f --cid=4686E5ECEED0487FA94E8A1C3A0ADF76-A8 --provisioning-token=87191FA1
  sudo /opt/CrowdStrike/falconctl -s -f --tags="AWS-$AWS_ACCOUNT"
  test $? -ne 0 && { echo "Error in registration of falconctl"; exit 1; }
  sudo service falcon-sensor start
  test $? -ne 0 && { echo "Error in starting falcon-sensor"; exit 1; }
  sudo rm -f /tmp/$PKG_NAME 2> /dev/null
  exit 0
fi

# Amazon Linux 2
if uname -r | grep amzn2 >/dev/null; then
  PKG_NAME=falcon-sensor-5.38.0-10404.amzn2.x86_64.rpm
  sudo /usr/bin/curl -o /tmp/$PKG_NAME https://antivirusdownloadbucket.s3.amazonaws.com/Crowdstrike/AL2/$PKG_NAME

  test $? -ne 0 && { echo "Unable to copy file from S3"; exit 1; }
  sudo yum -q -y install libnl
  test $? -ne 0 && { echo "Unable to install libnl"; exit 1; }
  sudo rpm -i /tmp/$PKG_NAME
  yum list installed 2>/dev/null | grep falcon
  test $? -ne 0 && { echo "Falcon package not listed after install"; exit 1; }
  sudo /opt/CrowdStrike/falconctl -s -f --cid=4686E5ECEED0487FA94E8A1C3A0ADF76-A8 --provisioning-token=87191FA1
  sudo /opt/CrowdStrike/falconctl -s -f --tags="AWS-$AWS_ACCOUNT"
  test $? -ne 0 && { echo "Error in registration of falconctl"; exit 1; }
  sudo service falcon-sensor start
  test $? -ne 0 && { echo "Error in starting falcon-sensor"; exit 1; }
  sudo rm -f /tmp/$PKG_NAME 2> /dev/null
  exit 0
fi
exit 1

