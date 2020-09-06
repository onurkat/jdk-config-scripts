# jdk-config-scripts
JDK Configuration Scripts to install, uninstall Oracle JDK; make all JDK binaries recognizable by update-java-alternatives command, set JAVA_HOME and update PATH.

# How to Use
Use following commands to setup for the scripts for easy access

Install git if you don't have it already. 'sudo apt install git'

Clone this repo to your pc.
...
git clone github.com/onurkat/jdk-config-scripts.git
...

...
cd ~/jdk-config-scripts
sudo chmod +x *.sh
sudo mv *.sh /usr/local/bin
sudo rm -rf ~/jdk-config-scripts
...

Open your ~/.bashrc with your favorite text editor. (vi, vim, nano etc.) 'vi ~/.bashrc'

Add following text to your ~/.bashrc somewhere available.

...
source ~/.jdkconfig > /dev/null 2>&1
export PATH=$PATH:$JAVA_HOME/bin
alias changejdk='source /usr/local/bin/changejdk.sh'
alias installjdk='source /usr/local/bin/installjdk.sh'
alias uninstalljdk='source /usr/local/bin/uninstalljdk.sh'
...

You are good to go!

Now you can use 'installjdk', 'uninstalljdk' and 'changejdk'.
