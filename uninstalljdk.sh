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

echo "Warning: Please use this uninstaller for the JDKs installed manually."
echo "If you want to uninstall a JDK that you installed with a package, use: sudo apt purge <package_name>"
echo "List of installed JDKs:"
select JDK_DIR_NAME in $options
do
echo "Selected to uninstall: "$JDK_DIR_NAME
break
done

JDK_DIR_PATH="/usr/lib/jvm/"

for f in $JDK_DIR_PATH$JDK_DIR_NAME/bin/*; do
    name=`basename $f`;
    if [ ! -f "/usr/bin/$name" -o -L "/usr/bin/$name" ]; then     
           sudo update-alternatives --remove $name $JDK_DIR_PATH$JDK_DIR_NAME/bin/$name  > /dev/null 2>&1           
fi
done

[ -f $JDK_DIR_PATH$JDK_DIR_NAME/lib/jexec ] && sudo update-alternatives --remove jexec $JDK_DIR_PATH$JDK_DIR_NAME/lib/jexec > /dev/null 2>&1

sudo rm -rf $JDK_DIR_PATH$JDK_DIR_NAME
sudo rm -rf $JDK_DIR_PATH.$JDK_DIR_NAME.jinfo
export PATH="$( echo $PATH| tr : '\n' |grep -v '"$JDK_DIR_NAME"' | paste -s -d: )"
echo "Removed all files and configurations of selected JDK!"
if [ ! -d $JDK_DIR_PATH$JDK_DIR_NAME ]; then
	if [ ! -e $JDK_DIR_PATH.$JDK_DIR_NAME.jinfo ]; then
		if [[ $(update-alternatives --list java > /dev/null 2>&1) != *"$JDK_DIR_NAME"* ]] && [[ $(update-alternatives --list javac > /dev/null 2>&1) != *"$JDK_DIR_NAME"* ]]; then
		echo "Mission successful! Uninstalled:" $JDK_DIR_NAME
		fi
	fi
fi

if [ "$JAVA_HOME" = "$JDK_DIR_PATH$JDK_DIR_NAME" ]; then
	JAVA_HOME=""
	sudo bash -c ': > ~/.jdkconfig '
	export PATH="$( echo $PATH| tr : '\n' |grep -v "$JDK_DIR_NAME" | paste -s -d: )"
	echo "Warning: You uninstalled your current default JDK. Currently, JAVA_HOME is empty and PATH doesn't contain any JDK!"
	CHECK_DIR=$(/usr/lib/jvm/.*.jinfo > /dev/null 2>&1) 
	if [ -f ${CHECK_DIR[0]} ]; then		
	echo "You have at least one more JDK installed. Do you want to set one of them as default JDK, JAVA_HOME and configure your PATH? [Y/N]"
	while : 
	do
	read INPUT
  	case $INPUT in
		y | Y)	options=$(update-java-alternatives -l | awk '{print $1}')
			select JDK_DIR_NAME in $options
			do
			echo "Selected: "$JDK_DIR_NAME
			break
			done
			
			sudo update-java-alternatives -s $JDK_DIR_NAME > /dev/null 2>&1
			export JAVA_HOME=$JDK_DIR_PATH$JDK_DIR_NAME	
			export PATH=$PATH:$JAVA_HOME/bin
			echo "JAVA_HOME= " $JAVA_HOME
			echo "export JAVA_HOME='"$JDK_DIR_PATH$JDK_DIR_NAME"'" > ~/.jdkconfig	
			echo "Added to PATH: "$JAVA_HOME"/bin"
			java -version
			javac -version
			break		
			;;
		n | N)	return			
			;;
		*)
			echo "[Select y or n only!]"		
			;;
 	esac	
	done
	else
	echo "You can use 'installjdk' to install Oracle JDKs with the .tar.gz file from https://www.oracle.com/java/technologies/javase-downloads.html"	
	fi	
fi
