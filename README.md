# CrownPi
> Local Masternode hosting for the Crown(CRW) community.

![](http://i63.tinypic.com/vxke4x.png)

## Installation Guide

1 - 
	You must have a new copy of "Raspian Stretch Lite" installed on a 16GB SD Card using win32DiskImager for example.
2 - 
	Once you run the script CrownPi will ask you to change the device password, raspians default password is "raspberry".
3 - 
	Enable SSH connections and expand the file system using
```sudo raspi-config
``` 
4 - 
	Reboot the Pi 
```sudo reboot now
```
5 - 
	Now get the local IP address of the PI which starts with 192.168 and can be used for SSH
```ifconfig
```
6 - 
	Once logged in via SSH, use this command to initiate the installation process
```sudo wget "https://raw.githubusercontent.com/defunctec/CrownPi/master/crownpiscript.sh" -O install.sh | bash && sudo chmod +x install.sh && sudo ./install.sh
```
7 - 
	The script will first ask you to change the password of the device, this is wise for security. Installation is mostly automated but does require manual input in parts.
8 - 
	Once the script has installed the Crown client and setup the backend the script will ask you which VPN provider you use, NordVPN or VPNArea, please choose and follow the instructions.
9 - 
	Now your VPN is setup you can setup a Crown Masternode or Systemnode
```sudo nano /root/.crown/crown.conf
```
daemon=1
rpcuser=MAKE-NEW-USER
rpcpassword=MAKE-NEW-PASSWORD
listen=1
server=1
externalip=ENTERVPNIPADDRESS
masternode=1
masternodeprivkey=YOURMASTERNODEGENKEY
10 - Start the Crown Client
```sudo crownd
```
11 - 
	Goto your wallet, where the collateral is held.
	Edit the node you would like to host.
	Change the IP address to your new VPN IP address, Click Ok.
	The node will remain online or drop off. If it drops try "start missing" one more time.
12 -
	Back to the CrownPi
	Check the masternode is synced with the CrownPi by typing
```sudo crown-cli masternode status
```
## Usage

Raspberry Pi - Raspian Stretch Lite:

```sh
sudo wget "https://raw.githubusercontent.com/defunctec/CrownPi/master/crownpiscript.sh" -O install.sh | bash && sudo chmod +x install.sh && sudo ./install.sh
```

## NordVPN Setup

Qucik guide to using NordVPN with CrownPI

1 - 
	The script will ask you to enter your VPN account details, have these ready to make installation easy.
2 - 
	The command to change your NordVPN login details
```sudo nano /etc/openvpn/auth.txt
``` 
3 -
	This command will show a list of regions to choose from
```sudo ls -a /etc/openvpn/nordvpn
```
4 - 
	The next command shows the selected regions servers
```sudo ls -a /etc/openvpn/nordvpn/usservers
```
5 - 
	This is an example of how to correctly chose a server from a region
```sudo cp /etc/openvpn/nordvpn/usservers/us998.nordvpn.com.udp.ovpn /etc/openvpn/nordvpn.conf
```
6 -
	Now enter the new nordvpn.conf file you made
```sudo nano /etc/openvpn/nordvpn.conf
```
7 -
	Change the line 
```auth-user-pass
``` 
	to 
```auth-user-pass auth.txt
```
8 -
	Now check the IP has changed using
```sudo /etc/init.d/openvpn restart
```
	And
```./whatsmyip.sh
```


```sh
make install
npm test
```

## Release History

* 0.2.1
    * CHANGE: Update docs (module code remains unchanged)
* 0.2.0
    * CHANGE: Remove `setDefaultXYZ()`
    * ADD: Add `init()`
* 0.1.1
    * FIX: Crash when calling `baz()` (Thanks @GenerousContributorName!)
* 0.1.0
    * The first proper release
    * CHANGE: Rename `foo()` to `bar()`
* 0.0.1
    * Work in progress

## Meta

Your Name – [@YourTwitter](https://twitter.com/dbader_org) – YourEmail@example.com

Distributed under the XYZ license. See ``LICENSE`` for more information.

[https://github.com/yourname/github-link](https://github.com/dbader/)

## Contributing

1. Fork it (<https://github.com/yourname/yourproject/fork>)
2. Create your feature branch (`git checkout -b feature/fooBar`)
3. Commit your changes (`git commit -am 'Add some fooBar'`)
4. Push to the branch (`git push origin feature/fooBar`)
5. Create a new Pull Request

<!-- Markdown link & img dfn's -->
[npm-image]: https://img.shields.io/npm/v/datadog-metrics.svg?style=flat-square
[npm-url]: https://npmjs.org/package/datadog-metrics
[npm-downloads]: https://img.shields.io/npm/dm/datadog-metrics.svg?style=flat-square
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
[wiki]: https://github.com/yourname/yourproject/wiki