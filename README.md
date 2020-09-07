# jdk-config-scripts
JDK Configuration Scripts to install, uninstall Oracle JDK or OpenJDK on Ubuntu; make all JDK binaries recognizable by update-java-alternatives command, set JAVA_HOME and update PATH.

# Get Started
Use following commands to setup for the scripts for easy access.

Open new terminal.



1. Install following packages. If you don't have them already. 

Install `java-common` 

`sudo apt install java-common`

Install `git`  

`sudo apt install git`

Install `ca-certificates-java` 

`sudo apt install ca-certificates-java`


2. Clone this repo to your pc.
```
cd ~/
git clone https://github.com/onurkat/jdk-config-scripts.git
```

3. Open your `~/.bashrc` with your favorite text editor. (vim, nano etc.) `vim ~/.bashrc`

Add following text to your `~/.bashrc` somewhere available.

```
source ~/.jdkconfig > /dev/null 2>&1
export PATH=$PATH:$JAVA_HOME/bin
alias changejdk='source /usr/local/bin/changejdk.sh'
alias installjdk='source /usr/local/bin/installjdk.sh'
alias uninstalljdk='source /usr/local/bin/uninstalljdk.sh'
```
4. Run these commands to move scripts to your system and make them executable.

```
cd ~/jdk-config-scripts
sudo chmod +x *.sh
sudo mv *.sh /usr/local/bin
sudo rm -rf ~/jdk-config-scripts
source ~/.bashrc
cd ~/

```

You are good to go!

Now you can use `installjdk`, `uninstalljdk` and `changejdk`

# How to Use

1. Download JDK .tar.gz file from Oracle's website. https://www.oracle.com/java/technologies/javase-downloads.html or java.net

You need to sign up and log in for downloading the JDK files after Oracle's JDK licence update.

Please check the file name before downloading. It has to be x64 to run.

2. Run `installjdk`

Press Y to continue to installation. A GUI window should pop up. Select the tar.gz file in the GUI window.

After the installation, the script will ask you that if you want to set the default JDK now. If so, press Y.

# Other Scripts

1. `changejdk`

Use this script when you want to change your default JDK. Select it on the list and that's all.

2. `uninstalljdk`

Use this script to uninstall a JDK. Warning: Please use this uninstaller for the JDKs only installed manually.

If you want to uninstall a JDK that you installed with a package, use: `sudo apt purge <package_name>`


