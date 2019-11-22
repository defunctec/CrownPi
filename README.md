# CrownPi - (MNPoS 0.13.4)
> Local Masternode hosting for the Crown(CRW) community.

![alt text](https://i.imgur.com/yWxTrUM.jpg)

## Introduction

CROWNPI IS NO LONGER RECOMMENDED AS IT DOESN'T PROVIDE INCOMING CONNECTIONS


Hosting from home is risky as your IP address is made public. CrownPi will help you host from home safely using OpenVPN.
You must have a NordVPN or AreaVPN account to use CrownPi.

## Usage

Raspberry Pi - Raspian Stretch Lite:

```sh
sudo wget "https://raw.githubusercontent.com/defunctec/CrownPi/master/crownpiscript.sh" -O install.sh | bash && sudo chmod +x install.sh && sudo ./install.sh
```

## Installation Guide

1. You must have a new copy of "Raspian Stretch Lite" installed on a 16GB SD Card using win32DiskImager for example.
2. This script must be run from root.
3. Enable SSH connections and expand the file system using
```sh
sudo raspi-config
``` 
4. Reboot the Pi 
```sh
sudo reboot now
```
5. Now get the local IP address of the PI which starts with 192.168 and can be used for SSH
```sh
ifconfig
```
6. Once logged in via SSH, use this command to initiate the installation process
```sh
sudo wget "https://raw.githubusercontent.com/defunctec/CrownPi/master/crownpiscript.sh" -O install.sh | bash && sudo chmod +x install.sh && sudo ./install.sh
```
7. Installation is mostly automated but does require manual input at the end.
8. Once the script has installed the Crown client and setup the backend the script will ask you which VPN provider you use, NordVPN or VPNArea, please choose and follow the instructions.
9. Now the VPN is setup, use the crown.conf to enter VPN IP, genkey ect.
```sh
sudo nano /root/.crown/crown.conf
```
10. Start the Crown Client
```sh
sudo crownd
```
11. Goto your wallet, where the collateral is held.
	 Edit the node you would like to host.
	 Change the IP address to your new VPN IP address, Click Ok.
	 The node will remain online or drop off. If it drops try "start missing" one more time.
12. Back to the CrownPi
	 Check the masternode is synced with the CrownPi by typing
```sh
sudo crown-cli masternode status
```

Linux - Ubuntu 19:

```sh
sudo wget "https://raw.githubusercontent.com/defunctec/CrownPi/master/crownpiscript.sh" -O install.sh | bash && sudo chmod +x install.sh && sudo ./install.sh
```

## Installation Guide

1. This guide is based on a new linux VPS.
2. This script must be run from root.
3. Enable SSH connections and expand the file system using
4. Installation is mostly automated but does require manual input.
![alt text](https://i.imgur.com/6gFdUaN.png?1)
5. Once logged in via SSH, use this command to initiate the installation process
```sh
sudo wget "https://raw.githubusercontent.com/defunctec/CrownPi/master/crownpiscript.sh" -O install.sh | bash && sudo chmod +x install.sh && sudo ./install.sh
```
![alt text](https://i.imgur.com/PuTLgWa.png)
6. Follow the instructions and enter your VPN details when promted (VPN instructions below)
![alt text](https://i.imgur.com/GAekdKu.png)
7. Now the VPN is setup, use the crown.conf to enter VPN IP, genkey ect.
```sh
sudo nano /root/.crown/crown.conf
```
10. Start the Crown Client
```sh
crownd
```
11. Goto your wallet, where the collateral is held.
	 Edit the node you would like to host.
	 Change the IP address to your new VPN IP address, Click Ok.
	 The node will remain online or drop off. If it drops try "start missing" one more time.
12. Back to your VPS
	 Check the masternode is synced with the CrownPi by typing
```sh
crown-cli masternode status
```

## Update CrownPi

![alt text](https://i.imgur.com/3zYYrpO.png)

Choose between Linux and RPI, then choose update.

```sh
./install.sh
``` 

## NordVPN Commands

Quick guide to using NordVPN with CrownPI

1. The script will ask you to enter your VPN account details, have these ready to make installation easy.
2. The command to change your NordVPN login details
```sh
nano /etc/openvpn/auth.txt
``` 
3. This command will show a list of regions to choose from
```sh
ls -a /etc/openvpn/nordvpn
```
4. The next command shows the selected regions servers
```sh
ls -a /etc/openvpn/nordvpn/usservers
```
5. This is an example of how to correctly choose a server from a region
```sh
cp /etc/openvpn/nordvpn/usservers/us998.nordvpn.com.udp.ovpn /etc/openvpn/nordvpn.conf
```
6. Now edit the new nordvpn.conf file you made
```sh
sed -i -e 's/auth-user-pass/auth-user-pass auth.txt/g' /etc/openvpn/nordvpn.conf
```
7. Restart openvpn and check the IP is correct.
```sh
/etc/init.d/openvpn restart
```
	And
```sh
./whatsmyip.sh
```

## VPNArea
Quick guide to using VPNArea with CrownPI

![alt text](https://i.imgur.com/uCdPqor.png)

1. VPNArea installation is very simple as the script takes care of most of the work.
2. When promted, choose which location you would like to use as VPN server
3. Make sure to enter your correct VPNArea account details

## About Crown

HomePage - https://Crown.tech