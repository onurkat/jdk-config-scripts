# jdk-config-scripts
JDK Configuration Scripts to;

- Install, uninstall Oracle JDK, SAPMachine JDK or any other JDK based on OpenJDK for Linux based operating systems.
- Make all JDK binaries recognizable by update-java-alternatives command
- Set JAVA_HOME and update PATH when you switch your JDK.
- **New: Option to download and install SAP Machine JDK 11 directly via `installjdk` script.**

# Get Started
Use following commands to setup for the scripts for easy access.

Open new terminal and execute following command to install the scripts. It will also install necessary packages.

```
source <(curl -s https://raw.githubusercontent.com/onurkat/jdk-config-scripts/master/installscripts.sh)
```
![image](https://user-images.githubusercontent.com/5752017/109224300-d2e21e00-77cc-11eb-9809-dc771005e7af.png)

Press `y` and the script will do the rest!

You are good to go!

Now you can use `installjdk`, `uninstalljdk` and `changejdk`

# How to Use

### Install JDK

Run `installjdk`

![image](https://user-images.githubusercontent.com/5752017/109223701-fc4e7a00-77cb-11eb-8a93-039eb18ce89e.png)

- You can easily download and install SAP Machine JDK by pressing `1`
- Or you can press `2` and install any other custom JDK from a .tar.gz file. A GUI window should pop up. Select the tar.gz file in the GUI window.

After the installation, the script will ask you that if you want to set the default JDK now. If so, press `Y`.

### Change JDK

Run `changejdk`

![image](https://user-images.githubusercontent.com/5752017/109224400-ef7e5600-77cc-11eb-87d3-7912986776af.png)

Use this script when you want to change your default JDK. Select it on the list and that's all. The script will do all necessary changes.

### Uninstall JDK

Run `uninstalljdk`

Use this script to uninstall a JDK. Warning: Please use this uninstaller for the JDKs only installed by this script.

If you want to uninstall a JDK that you installed with a package, use: `sudo apt purge <package_name>`
