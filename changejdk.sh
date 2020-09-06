#!/bin/bash

# Author : Onur Kat
# Contact info : github.com/onurkat

CHECK_DIR=(/usr/lib/jvm/.*.jinfo)

if [ ! -f ${CHECK_DIR[0]} ]; then
	echo "Your system does not have any version of JDK or the script failed to detect them!"
	echo "You can use 'installjdk' to install Oracle JDKs with the .tar.gz file from https://www.oracle.com/java/technologies/javase-downloads.html"
	return
fi

options=$(update-java-alternatives -l | awk '{print $1}')
echo "This script will set selected JDK as your default Java binaries."
echo "Also it will update your JAVA_HOME and PATH environment variables."
echo "Select JDK from the list below:" 
select JDK_DIR_NAME in $options
do
echo "Selected: "$JDK_DIR_NAME
break
done

JDK_DIR_PATH="/usr/lib/jvm/"

if [ ! -d $JDK_DIR_PATH$JDK_DIR_NAME ]; then
echo "This JDK might not be installed correctly! Mission abort."
return
fi

if [ ! -e $JDK_DIR_PATH$JDK_DIR_NAME/bin/java ] || [ ! -e $JDK_DIR_PATH$JDK_DIR_NAME/bin/javac ]; then
echo "Some required files are missing! Mission abort."
return
fi

if [ ! -e ~/.jdkconfig ]; then
sudo touch ~/.jdkconfig
fi

if [[ $(update-java-alternatives -l) != *"$JDK_DIR_NAME"* ]] || [[ $(update-alternatives --list java) != *"$JDK_DIR_NAME"* ]]; then
echo "Some required configurations are missing! Mission abort."
return
fi

# Cleaning PATH from old JDK
export PATH="$( echo $PATH| tr : '\n' |grep -v java | paste -s -d: )"
export PATH="$( echo $PATH| tr : '\n' |grep -v jdk | paste -s -d: )"

sudo update-java-alternatives -s $JDK_DIR_NAME > /dev/null 2>&1
export JAVA_HOME=$JDK_DIR_PATH$JDK_DIR_NAME	
export PATH=$PATH:$JAVA_HOME/bin
sudo bash -c 'echo "export JAVA_HOME='"$JDK_DIR_PATH$JDK_DIR_NAME"'" > ~/.jdkconfig'	
echo "JAVA_HOME= " $JAVA_HOME
echo "PATH cleaned from old JDKs."
echo "Added to PATH: "$JAVA_HOME/bin
java -version
javac -version


