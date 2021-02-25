#!/bin/bash

# Author : Onur Kat
# Contact info : github.com/onurkat

echo "Executing installjdk.sh ..."
echo "Please select ..."
echo "1) Download and install SapMachine JDK 11"
echo "2) Install other JDK from .tar.gz file"
echo "Press any other key to exit."
SELECTION=3
TAR_DIR=
while : 
do
read INPUT
  case $INPUT in
	1)	SELECTION=1
		break
		;;
	2)	SELECTION=2
		break			
		;;
	*)	return
		;;
  esac
done

if [ "1" = "$SELECTION" ]; then

TEMP_TAR_FILE="~/Downloads/sapmachine-jdk-11.0.10_linux-x64_bin.tar.gz"

if [ -f $TEMP_TAR_FILE ]; then
sudo rm -rf $TEMP_TAR_FILE
fi


wget -O $TEMP_TAR_FILE 'https://github.com/SAP/SapMachine/releases/download/sapmachine-11.0.10/sapmachine-jdk-11.0.10_linux-x64_bin.tar.gz'

TAR_DIR="$TEMP_TAR_FILE"

fi

if [ "$TAR_DIR" = "" ]; then

TAR_DIR=$(zenity --title "Select the .tar.gz file you downloaded" --file-selection --filename "${HOME}/Downloads/" --file-filter=""*jdk*64*.tar.gz"" 2> /dev/null)

fi

if [ "$TAR_DIR" = "" ]; then
	echo "You did not select a file. Mission abort."
	return
fi

echo "Selected file: $TAR_DIR"

JDK_DIR_NAME=$(tar tf $TAR_DIR | head -1 | cut -f1 -d"/")

if [ "$JDK_DIR_NAME" = "" ]; then
	echo "The tar.gz file is corrupted. There is no folder in it. Mission abort."
	return
fi

CHECK_JDK_BIN=$(tar tf $TAR_DIR | grep javac)

if [ "$CHECK_JDK_BIN" = "" ]; then
	echo "The tar.gz file is corrupted. There is no javac file in it. Mission abort."
	return
fi

JDK_DIR_PATH="/usr/lib/jvm/"
if [ ! -d "$JDK_DIR_PATH" ];then
sudo mkdir -p "$JDK_DIR_PATH"
fi
PRIORITY=1000

# .jinfo file creation:
if [[ -e $JDK_DIR_PATH.$JDK_DIR_NAME.jinfo ]] || [[ -d $JDK_DIR_PATH$JDK_DIR_NAME ]] || [[ $(update-alternatives --list java > /dev/null 2>&1) = *"$JDK_DIR_PATH$JDK_DIR_NAME"* ]]; then
echo "It seems like you have already installed this JDK. Do you want to continue anyway? [y/n]"
while : 
do
read INPUT
  case $INPUT in
	y | Y)	sudo rm -rf $JDK_DIR_PATH.$JDK_DIR_NAME.jinfo
		break
		;;
	n | N)	return			
		;;
	*)
		echo "[Select y or n only!]"		
		;;
  esac
done
fi

echo "Installing: $JDK_DIR_NAME"
sudo tar -zxf $TAR_DIR --directory $JDK_DIR_PATH
sudo touch /usr/lib/jvm/.$JDK_DIR_NAME.jinfo
sudo bash -c 'echo name='"$JDK_DIR_NAME"' >> /usr/lib/jvm/.'"$JDK_DIR_NAME"'.jinfo'
sudo bash -c 'echo alias='"$JDK_DIR_NAME"' >>/usr/lib/jvm/.'"$JDK_DIR_NAME"'.jinfo'
sudo bash -c 'echo priority='"$PRIORITY"' >> /usr/lib/jvm/.'"$JDK_DIR_NAME"'.jinfo'
sudo bash -c 'echo section=non-free >> /usr/lib/jvm/.'"$JDK_DIR_NAME"'.jinfo'

# Installing all Java binaries
for f in $JDK_DIR_PATH$JDK_DIR_NAME/bin/*; do
    name=`basename $f`;
    if [ ! -f "/usr/bin/$name" -o -L "/usr/bin/$name" ]; then 
    
           sudo update-alternatives --install /usr/bin/$name $name $JDK_DIR_PATH$JDK_DIR_NAME/bin/$name $PRIORITY  > /dev/null 2>&1
           sudo bash -c 'echo "jdk '"$name"' '"$JDK_DIR_PATH"''"$JDK_DIR_NAME"'/bin/'"$name"'" >> /usr/lib/jvm/.'"$JDK_DIR_NAME"'.jinfo'

fi
done

[ -f $JDK_DIR_PATH$JDK_DIR_NAME/lib/jexec ] && sudo update-alternatives --install /usr/bin/jexec jexec $JDK_DIR_PATH$JDK_DIR_NAME/lib/jexec $PRIORITY > /dev/null 2>&1 && sudo bash -c 'echo "jdk jexec '"$JDK_DIR_PATH$JDK_DIR_NAME"'/lib/jexec" >> /usr/lib/jvm/.'"$JDK_DIR_NAME"'.jinfo'



if [ -d "$JDK_DIR_PATH$JDK_DIR_NAME" ]; then
	if [ -e "$JDK_DIR_PATH.$JDK_DIR_NAME".jinfo ]; then
		if [[ $(update-java-alternatives -l) = *"$JDK_DIR_NAME"* ]] && [[ $(update-alternatives --list java) = *"$JDK_DIR_NAME"* ]]; then
		echo "Mission successful! Installed JDK: $JDK_DIR_NAME"
		
		else
			echo "Mission failed!"
			return
		fi
	fi
fi

if [ ! -e ~/.jdkconfig ]; then
touch ~/.jdkconfig
fi
	
echo "Do you want to set the newly installed JDK as your default JDK and update JAVA_HOME and PATH? [y/n]"
while : 
do
read INPUT2
  case $INPUT2 in
	y | Y)	sudo update-java-alternatives -s $JDK_DIR_NAME > /dev/null 2>&1
		export PATH="$( echo $PATH| tr : '\n' |grep -v java | paste -s -d: )"
		export PATH="$( echo $PATH| tr : '\n' |grep -v jdk | paste -s -d: )"
		echo "Cleaned PATH from old JDKs."
		sudo update-java-alternatives -s $JDK_DIR_NAME > /dev/null 2>&1
		export JAVA_HOME=$JDK_DIR_PATH$JDK_DIR_NAME
		echo "export JAVA_HOME='"$JDK_DIR_PATH$JDK_DIR_NAME"'" > ~/.jdkconfig	
		export PATH=$PATH:$JAVA_HOME/bin
		break		
		;;
	n | N)	return			
		;;
	*)
		echo "[Select y or n only!]"		
		;;
  esac
done

echo "JAVA_HOME= $JAVA_HOME"
echo "Added to PATH: $JAVA_HOME/bin"
java -version
javac -version
 
