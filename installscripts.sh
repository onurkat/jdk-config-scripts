#!/bin/bash

# Author : Onur Kat
# Contact info : github.com/onurkat

echo "This script will install JDK Config Scripts from github.com/onurkat/jdk-config-scripts and necessary packages." 
echo "Do you want to continue? [Y/n]"

TEMP_DIR="/tmp/jdk-config-scripts"

while : 
do
read selection
  case $selection in
	y | Y)	break
		;;
	n | N)	return			
		;;
	*)
		echo "[Select y or n only!]"		
		;;
  esac
done

echo "Updating package list..."
sudo apt-get update
echo "Package list updated."

echo "Step 1 : Installing required packages..."

for REQUIRED_PKG in "java-common" "git" "ca-certificates-java" "wget"

do

PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
  sudo apt-get --yes install $REQUIRED_PKG 
  PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
  if [ "" = "$PKG_OK" ]; then
  echo "Installation of $REQUIRED_PKG failed. Mission abort."
  return
  fi
fi

done

echo "Step 1: SUCCESS."
echo "Step 2: Installing JDK Config Scripts..."

if [ -d "$TEMP_DIR" ];then
sudo rm -rf $TEMP_DIR
fi

sudo git clone https://github.com/onurkat/jdk-config-scripts.git $TEMP_DIR

if grep -q 'source ~/.jdkconfig' ~/.bashrc; then

echo "You already have .jdkconfig setting in your .bashrc file. Skipping..."

else

sed -i -n '/JAVA_HOME/!p' ~/.bashrc

echo 'source ~/.jdkconfig > /dev/null 2>&1' >> ~/.bashrc 
echo 'case "$PATH" in' >> ~/.bashrc 
echo '*:$JAVA_HOME/bin*) ;;' >> ~/.bashrc
echo '*) export PATH=$PATH:$JAVA_HOME/bin ;;' >> ~/.bashrc
echo 'esac' >> ~/.bashrc
echo 'alias changejdk='\''source /usr/local/bin/changejdk.sh'\' >> ~/.bashrc
echo 'alias installjdk='\''source /usr/local/bin/installjdk.sh'\' >> ~/.bashrc
echo 'alias uninstalljdk='\''source /usr/local/bin/uninstalljdk.sh'\' >> ~/.bashrc
echo ''>> ~/.bashrc
fi

cd $TEMP_DIR
sudo chmod +x *.sh
sudo mv *.sh /usr/local/bin
cd ~/
sudo rm -rf $TEMP_DIR
source ~/.bashrc
cd ~/

echo "Step 2: SUCCESS."

echo "Installation finished. Now you can use installjdk, changejdk, uninstalljdk commands."

