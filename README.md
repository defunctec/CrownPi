# CrownPi
> Local Masternode hosting for the Crown(CRW) community.

![](http://i63.tinypic.com/vxke4x.png)

## Installation Guide

1. You must have a new copy of "Raspian Stretch Lite" installed on a 16GB SD Card using win32DiskImager for example.
2. This script can be run from user or root.
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
7. The script will first ask you to change the password of the device, this is wise for security. Installation is mostly automated but does require manual input in parts.
8. Once the script has installed the Crown client and setup the backend the script will ask you which VPN provider you use, NordVPN or VPNArea, please choose and follow the instructions.
9. Now your VPN is setup you can setup a Crown Masternode or Systemnode
```sh
sudo nano /root/.crown/crown.conf
```
Enter -   
```sh
daemon=1
rpcuser=MAKE-NEW-USER
rpcpassword=MAKE-NEW-PASSWORD
listen=1
server=1
externalip=ENTERVPNIPADDRESS
masternode=1
masternodeprivkey=YOURMASTERNODEGENKEY
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

## Usage

Raspberry Pi - Raspian Stretch Lite:

```sh
sudo wget "https://raw.githubusercontent.com/defunctec/CrownPi/master/crownpiscript.sh" -O install.sh | bash && sudo chmod +x install.sh && sudo ./install.sh
```

## NordVPN Setup

Quick guide to using NordVPN with CrownPI

1. The script will ask you to enter your VPN account details, have these ready to make installation easy.
2. The command to change your NordVPN login details
```sh
sudo nano /etc/openvpn/auth.txt
``` 
3. This command will show a list of regions to choose from
```sh
sudo ls -a /etc/openvpn/nordvpn
```
4. The next command shows the selected regions servers
```sh
sudo ls -a /etc/openvpn/nordvpn/usservers
```
5. This is an example of how to correctly chose a server from a region
```sh
sudo cp /etc/openvpn/nordvpn/usservers/us998.nordvpn.com.udp.ovpn /etc/openvpn/nordvpn.conf
```
6. Now enter the new nordvpn.conf file you made
```sh
sudo nano /etc/openvpn/nordvpn.conf
```
7. Change the line 
```sh
auth-user-pass
``` 
	to 
```sh
auth-user-pass auth.txt
```
8 -
	Now check the IP has changed using
```sh
sudo /etc/init.d/openvpn restart
```
	And
```sh
./whatsmyip.sh
```


## VPNArea
Quick guide to using VPNArea with CrownPI

1. VPNArea installation is very simple as the script takes care of most of the work.
2. When promted, choose which location you would like to use as VPN server
3. Make sure to enter your correct VPNArea account details

## About Crown

HomePage - https://Crown.tech
Chat - https://mm.crownlab.eu