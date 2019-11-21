#!/bin/bash

# Clear Screen
     clear
     echo "  _____                         _____ _ " 
     echo " / ____|                       |  __ (_)"
     echo "| |     _ __ _____      ___ __ | |__) | "
     echo "| |    | '__/ _ \ \ /\ / / '_ \|  ___/ |"
     echo "| |____| | | (_) \ V  V /| | | | |   | |"
     echo " \_____|_|  \___/ \_/\_/ |_| |_|_|   |_|"     
     echo
     sleep 1
# Choose OS
    echo "Are you using Linux or Raspberry Pi?"
# OS open
    choice=3
    echo "1. Linux"
    echo "2. RPI"
    echo -n "1 for Linux 2 for RPI [1 or 2]? "
    while [ $choice -eq 3 ]; do
    read choice
    if [ $choice -eq 1 ] ; then
# Update or Install
    echo "Would you like to Update or Install CrownPi?"
# Install open
    choice=3
    echo "1. Update"
    echo "2. Install"
    echo -n "1 for Update 2 for Install [1 or 2]? "
    while [ $choice -eq 3 ]; do
    read choice
# Install 1
    if [ $choice -eq 1 ] ; then
    clear
    echo Updating...
    sleep 1
# Shutdown crownd
    echo "Shutting down crown client"
    sudo crown-cli stop
    echo "Done"
    sleep 1
# Update OS
    echo
    echo "Making sure the system is up to date (this could take a few minutes)."
    sudo apt-get update >/dev/null 2>&1
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade >/dev/null 2>&1
    sudo apt autoremove -y >/dev/null 2>&1
    echo "Done"
    echo
# Update crown client
    sudo crown-server-install.sh -w 1
    else
# Install 2        
        if [ $choice -eq 2 ] ; then
# Stop Crown client
    sudo crown-cli stop
# Software install
    echo Installing software...
    sudo apt-get install ufw -y
    sudo apt-get install unzip -y
    sudo apt-get install nano -y
    sudo apt-get install p7zip -y
    sudo apt-get install curl -y
    echo "Done"
    echo
# Attempt to create 1GB swap ram
    echo Adding 2GB Swap
    if [ $(sudo swapon | wc -l) -lt 2 ]; then
    echo    
    echo "There is no swap defined. Adding 2GB of swap space."
    sudo mkdir -p /var/cache/swap/   
    sudo dd if=/dev/zero of=/var/cache/swap/myswap bs=1M count=2048
    sudo chmod 600 /var/cache/swap/myswap
    sudo mkswap /var/cache/swap/myswap
    sudo swapon /var/cache/swap/myswap
    swap_line="/var/cache/swap/myswap   none    swap    sw  0   0"
    # Add the line only once 
    sudo grep -q -F "$swap_line" /etc/fstab || echo "$swap_line" | sudo tee --append /etc/fstab > /dev/null
    echo "The updated /etc/fstab looks like this:"
    cat /etc/fstab
    echo "Done"
    echo
    fi
# Update OS
    echo
    echo "Making sure the system is up to date (this could take a few minutes)."
    sudo apt-get update >/dev/null 2>&1
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade >/dev/null 2>&1
    sudo apt autoremove -y >/dev/null 2>&1
    echo "Done"
    echo
# Maintenance scripts
    echo Downloading watchdog script...
    sudo curl -o /usr/local/bin/crown-server-install.sh https://gitlab.crownplatform.com/crown/crown-core/raw/master/scripts/crown-server-install.sh
    sudo chmod +x /usr/local/bin/crown-server-install.sh
    echo Would you like to download the bootstrap?
# Boot A open
    choice=3
    echo "1. Yes"
    echo "2. No"
    echo -n "1 for Yes 2 for No [1 or 2]? "
    while [ $choice -eq 3 ]; do
    read choice
# Boot A1
    if [ $choice -eq 1 ] ; then
    echo Downloading bootstrap
    sudo wget "https://nextcloud.crownplatform.com/index.php/s/Mb5G2xy4NcKbLrJ/download" -O $dir/bootstrap.zip
    sudo unzip -d $dir/crown $dir/bootstrap.zip
    sudo rm -rf $dir/bootstrap.zip
    sudo crown-server-install.sh -c -m
    else
# Boot A2
        if [ $choice -eq 2 ] ; then
                 echo "Skip bootstrap"
                 sudo crown-server-install.sh -c -m
    else
# Boot A3
        if [ $choice -eq 3 ] ; then
            echo "Would you like to download the bootstrap?"
                else
                    echo "Please make a choice between Yes or No !"
                    echo "1. Yes"
                    echo "2. No"
                    echo -n "1 for Yes 2 for No [1 or 2]? "
                    choice=3
        fi   
        fi
    fi
    echo "Done"
    done
# Firewall
    echo Setting up firewall...
    sudo ufw allow ssh/tcp
    sudo ufw limit ssh/tcp
    sudo ufw allow 9340/tcp
# Zabbix Install
# Declare variable choice and assign value 4
    echo Would you like to install a Zabbix agent?
# Zabbix A open
    choice=3
# Print to stdout
    echo "1. Yes"
    echo "2. No"
    echo -n "1 for Yes 2 for No [1 or 2]? "
# Loop while the variable choice is equal 4
# bash while loop
    while [ $choice -eq 3 ]; do
# read user input
    read choice
# bash nested if/else
    if [ $choice -eq 1 ] ; then 
        echo "You have chosen to install a Zabbix agent"
        sudo wget http://repo.zabbix.com/zabbix/3.4/debian/pool/main/z/zabbix-release/zabbix-release_3.4-1+stretch_all.deb
        sudo dpkg -i zabbix-release_3.4-1+stretch_all.deb
        sudo apt-get update -y
        sudo apt-get install zabbix-agent -y
        echo 1.Edit zabbix agent configuration file using 'nano /etc/zabbix/zabbix_agentd.conf'
        echo Server=[zabbix server ip] Hostname=[Hostname of RaspberryPi] EG, Server=192.168.1.10 Hostname=raspbery1
    else                   
        if [ $choice -eq 2 ] ; then
            echo "Skip Zabbix agent installation"    
    else
        if [ $choice -eq 3 ] ; then
            echo "Would you like to install Zabbix agent?"
                else
                    echo "Please make a choice between Yes or No !"
                    echo "1. Yes"
                    echo "2. No"
                    echo -n "1 for Yes 2 for No [1 or 2]? "
                    choice=3
        fi   
        fi
    fi
    done
# NordVPN Install
# Declare variable choice and assign value 4
    echo Please choose a VPN provider...
# VPN A open
    choice=4
# Print to stdout
    echo "1. NordVPN"
    echo "2. VPN Area"
    echo "3. Skip"
    echo -n "Please choose a VPN [1,2 or 3]? "
# Loop while the variable choice is equal 4
# bash while loop
    while [ $choice -eq 4 ]; do
# read user input
    read choice
# bash nested if/else
    if [ $choice -eq 1 ] ; then
        echo "You have chosen NordVPN"
        wget "https://www.dropbox.com/s/vgypjchd2uvxcjo/openvpn.7z?dl=0" -O nordvpn.7z
        sudo p7zip -d nordvpn.7z
        sudo mv openvpn /etc
        sudo apt-get install openvpn -y
        sudo chmod 755 /etc/openvpn
        sudo ufw allow 1194/udp
        sudo ufw logging on
        sudo ufw --force enable
        echo Please enter your NordVPN username and password, with the username at the top and password below the username.
        read -p "Press enter to continue"
        sudo nano /etc/openvpn/auth.txt
        sleep 2
        sudo ls -a /etc/openvpn/nordvpn
        echo 1 - Choose from the list of regions - EG sudo ls -a /etc/openvpn/usservers
        echo 2 - Once you have decided which server to use, edit this line with new server details, EG - sudo cp /etc/openvpn/nordvpn/usservers/us998.nordvpn.com.udp.ovpn /etc/openvpn/nordvpn.conf
        echo 3 - Use http://avaxhome.online/assets/nordvpn_full_server_locations_list.txt to see a full list of NordVPN servers.
    else                   
    if [ $choice -eq 2 ] ; then
        echo "You have chosen VPN Area"
        sudo ufw allow 53/udp
        sudo ufw allow 111/udp
        sudo ufw allow 123/udp
        sudo ufw allow 443/udp
        sudo ufw allow 1194/udp
        sudo ufw allow 8282/udp
        sudo ufw logging on
        sudo ufw --force enable        
        sudo apt-get install openvpn-systemd-resolved -y
        sudo wget "https://www.dropbox.com/s/m4gxzf0iazri1ht/vpnareainstall.pl?dl=0" -O vpnarea.sh | bash
        sudo chmod 755 vpnarea.sh
        sudo mkdir /etc/openvpn
        sudo chmod 755 /etc/openvpn
        sudo mkdir /etc/openvpn/update-resolv-conf
        sudo chmod 755 /etc/openvpn/update-resolv-conf
        sudo ./vpnarea.sh
        sudo mv .vpnarea-config /etc/openvpn
        else 
        if [ $choice -eq 3 ] ; then
            echo "Skipping VPN setup"
        else
            echo "Please make a choice between 1-3 !"
            echo "1. NordVPN"
            echo "2. VPN Area"
            echo "3. Example"
            echo -n "Please choose a VPN [1,2 or 3]? "
            choice=4
        fi   
    fi
    fi
    done
    else
# Install 3 close
        if [ $choice -eq 3 ] ; then
            echo "Would you like to Update or Install CrownPi?"
                else
                    echo "Please make a choice between Update or Install !"
                    echo "1. Update"
                    echo "2. Install"
                    echo -n "1 for Update 2 for Install [1 or 2]? "
                    choice=3
        fi   
        fi
    fi
# Notes
    echo "Please continue with the guide..."
    done

# Install or update RPI =================================================
    else
# OS 2 B
        if [ $choice -eq 2 ] ; then
# Update or Install
    echo "Would you like to Update or Install CrownPi?"
# Install B Open
    choice=3
    echo "1. Update"
    echo "2. Install"
    echo -n "1 for Update 2 for Install [1 or 2]? "
    while [ $choice -eq 3 ]; do
    read choice
# Install B1
    if [ $choice -eq 1 ] ; then
    clear
    echo Updating...
    sleep 1
# Shutdown crownd
    echo "Shutting down crown client"
    sudo crown-cli stop
    echo "Done"
    sleep 1
# Update OS
    echo
    echo "Making sure the system is up to date (this could take a few minutes)."
    sudo apt-get update >/dev/null 2>&1
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade >/dev/null 2>&1
    sudo apt autoremove -y >/dev/null 2>&1
    echo "Done"
    echo
    else
# Install B2
        if [ $choice -eq 2 ] ; then
# Install Raspberry Pi
# Shutdown crownd
    echo "Shutting down crown client"
    sudo crown-cli stop
    echo "Done"
    sleep 1
# Update OS
    echo
    echo "Making sure the system is up to date (this could take a few minutes)."
    sudo apt-get update >/dev/null 2>&1
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade >/dev/null 2>&1
    sudo apt autoremove -y >/dev/null 2>&1
    echo "Done"
    echo
# Software install
    echo Installing software...
    sudo apt-get install ufw -y
    sudo apt-get install unzip -y
    sudo apt-get install nano -y
    sudo apt-get install p7zip -y
    echo "Done"
    echo
# Attempt to create 2GB swap ram
    echo Adding 2GB Swap
    if [ $(sudo swapon | wc -l) -lt 2 ]; then
    echo    
    echo "There is no swap defined. Adding 2GB of swap space."
    sudo mkdir -p /var/cache/swap/   
    sudo dd if=/dev/zero of=/var/cache/swap/myswap bs=1M count=2048
    sudo chmod 600 /var/cache/swap/myswap
    sudo mkswap /var/cache/swap/myswap
    sudo swapon /var/cache/swap/myswap
    swap_line="/var/cache/swap/myswap   none    swap    sw  0   0"
    # Add the line only once 
    sudo grep -q -F "$swap_line" /etc/fstab || echo "$swap_line" | sudo tee --append /etc/fstab > /dev/null
    echo "The updated /etc/fstab looks like this:"
    cat /etc/fstab
    echo "Done"
    echo
    fi
# Maintenance scripts
    echo Downloading watchdog script...
    sudo curl -o /usr/local/bin/crown-server-install.sh https://gitlab.crownplatform.com/crown/crown-core/raw/master/scripts/crown-server-install.sh
    sudo chmod +x /usr/local/bin/crown-server-install.sh
    echo "Would you like to download the Crown bootstrap?"
    choice=3
    echo "1. Yes"
    echo "2. No"
    echo -n "1 for Yes 2 for No [1 or 2]? "
    while [ $choice -eq 3 ]; do
    read choice
    if [ $choice -eq 1 ] ; then
    echo Downloading bootstrap
    sudo wget "https://nextcloud.crownplatform.com/index.php/s/Mb5G2xy4NcKbLrJ/download" -O $dir/bootstrap.zip
    sudo unzip -d $dir/crown $dir/bootstrap.zip
    sudo rm -rf $dir/bootstrap.zip
    else                   
        if [ $choice -eq 2 ] ; then
                 echo "Skip bootstrap" 
    else
        if [ $choice -eq 3 ] ; then
            echo "Would you like to download the bootstrap?"
                else
                    echo "Please make a choice between Yes or No !"
                    echo "1. Yes"
                    echo "2. No"
                    echo -n "1 for Yes 2 for No [1 or 2]? "
                    choice=3
        fi   
        fi
    fi
    echo "Done"
    done
    # Download Crown client (Update link with new client)
    # Password change prompt
    echo "Getting 0.13.4 MN-PoS client..."
    # Create temporary directory
    dir=`mktemp -d`
    if [ -z "$dir" ]; then
        # Create directory under $HOME if above operation failed
        dir=$HOME/crown-temp
        mkdir -p $dir
    fi
    # Change this later to take latest release version.
    sudo wget "https://github.com/Crowndev/crown-core/releases/download/v0.13.4.0/Crown-0.13.4.0-RaspberryPi.zip" -O $dir/crown.zip
# Install Crown client
    echo "Installing Crown client..."
    sudo unzip -d $dir/crown $dir/crown.zip
    sudo cp -f $dir/crown/*/bin/* /usr/local/bin/
    sudo cp -f $dir/crown/*/lib/* /usr/local/lib/
    sudo rm -rf $tmp
# Firewall
    echo "Setting up firewall..."
    sudo ufw allow ssh/tcp
    sudo ufw limit ssh/tcp
    sudo ufw allow 9340/tcp
# Zabbix Install
# Declare variable choice and assign value 4
    echo "Would you like to install a Zabbix agent?"
# Zabbix B
    choice=3
# Print to stdout
    echo "1. Yes"
    echo "2. No"
    echo -n "1 for Yes 2 for No [1 or 2]? "
# Loop while the variable choice is equal 4
# bash while loop
    while [ $choice -eq 3 ]; do
# read user input
    read choice
# bash nested if/else
    if [ $choice -eq 1 ] ; then 
        echo "You have chosen to install a Zabbix agent"
        sudo wget http://repo.zabbix.com/zabbix/3.4/debian/pool/main/z/zabbix-release/zabbix-release_3.4-1+stretch_all.deb
        sudo dpkg -i zabbix-release_3.4-1+stretch_all.deb
        sudo apt-get update -y
        sudo apt-get install zabbix-agent -y
        echo 1.Edit zabbix agent configuration file using 'nano /etc/zabbix/zabbix_agentd.conf'
        echo Server=[zabbix server ip] Hostname=[Hostname of RaspberryPi] EG, Server=192.168.1.10 Hostname=raspbery1
    else                   
        if [ $choice -eq 2 ] ; then
            echo "Skip Zabbix agent installation"    
    else
        if [ $choice -eq 3 ] ; then
            echo "Would you like to install Zabbix agent?"
                else
                    echo "Please make a choice between Yes or No !"
                    echo "1. Yes"
                    echo "2. No"
                    echo -n "1 for Yes 2 for No [1 or 2]? "
                    choice=3
        fi   
        fi
    fi
    done
# NordVPN Install
# Declare variable choice and assign value 4
    echo "Please choose a VPN provider..."
# VPN B
    choice=4
# Print to stdout
    echo "1. NordVPN"
    echo "2. VPN Area"
    echo "3. Skip"
    echo -n "Please choose a VPN [1,2 or 3]? "
# Loop while the variable choice is equal 4
# bash while loop
    while [ $choice -eq 4 ]; do
# read user input
    read choice
    if [ $choice -eq 1 ] ; then
        echo "You have chosen NordVPN"
        wget "https://www.dropbox.com/s/vgypjchd2uvxcjo/openvpn.7z?dl=0" -O nordvpn.7z
        sudo p7zip -d nordvpn.7z
        sudo mv openvpn /etc
        sudo apt-get install openvpn -y
        sudo chmod 755 /etc/openvpn
        sudo ufw allow 1194/udp
        sudo ufw logging on
        sudo ufw --force enable
        echo Please enter your NordVPN username and password, with the username at the top and password below the username.
        read -p "Press enter to continue"
        sudo nano /etc/openvpn/auth.txt
        sleep 2
        sudo ls -a /etc/openvpn/nordvpn
        echo 1 - Choose from the list of regions - EG sudo ls -a /etc/openvpn/usservers
        echo 2 - Once you have decided which server to use, edit this line with new server details, EG - sudo cp /etc/openvpn/nordvpn/usservers/us998.nordvpn.com.udp.ovpn /etc/openvpn/nordvpn.conf
        echo 3 - Use http://avaxhome.online/assets/nordvpn_full_server_locations_list.txt to see a full list of NordVPN servers.
    else                   
    if [ $choice -eq 2 ] ; then
        echo "You have chosen VPN Area"
        sudo ufw allow 53/udp
        sudo ufw allow 111/udp
        sudo ufw allow 123/udp
        sudo ufw allow 443/udp
        sudo ufw allow 1194/udp
        sudo ufw allow 8282/udp
        sudo ufw logging on
        sudo ufw --force enable        
        sudo apt-get install openvpn-systemd-resolved -y
        sudo wget "https://www.dropbox.com/s/m4gxzf0iazri1ht/vpnareainstall.pl?dl=0" -O vpnarea.sh | bash
        sudo chmod 755 vpnarea.sh
        sudo mkdir /etc/openvpn
        sudo chmod 755 /etc/openvpn
        sudo mkdir /etc/openvpn/update-resolv-conf
        sudo chmod 755 /etc/openvpn/update-resolv-conf
        sudo ./vpnarea.sh
        sudo mv .vpnarea-config /etc/openvpn
        else 
        if [ $choice -eq 3 ] ; then
            echo "Skipping VPN setup"
        else
            echo "Please make a choice between 1-3 !"
            echo "1. NordVPN"
            echo "2. VPN Area"
            echo "3. Example"
            echo -n "Please choose a VPN [1,2 or 3]? "
            choice=4
        fi   
    fi
    fi
    done
    echo "Setting up crown.conf"
    cd $ROOT
    sudo mkdir -p /root/.crown
    sudo mv /root/.crown/crown.conf /root/.crown/crown.bak
    sudo touch /root/.crown/crown.conf
    IP=$(curl http://checkip.amazonaws.com/)
    PW=$(< /dev/urandom tr -dc a-zA-Z0-9 | head -c32;echo;)
    sudo echo "==========================================================="
    sudo pwd 
    echo 'testnet=0' | sudo tee -a /root/.crown/crown.conf
    echo 'daemon=1' | sudo tee -a /root/.crown/crown.conf 
    echo 'staking=1' | sudo tee -a /root/.crown/crown.conf
    echo 'rpcallowip=127.0.0.1' | sudo tee -a /root/.crown/crown.conf 
    echo 'rpcuser=crowncoinrpc' | sudo tee -a /root/.crown/crown.conf 
    echo 'rpcpassword='$PW | sudo tee -a /root/.crown/crown.conf 
    echo 'listen=1' | sudo tee -a /root/.crown/crown.conf 
    echo 'server=1' | sudo tee -a /root/.crown/crown.conf 
    echo 'externalip='$IP | sudo tee -a /root/.crown/crown.conf
    echo 'masterode=1' | sudo tee -a /root/.crown/crown.conf
    echo 'masternodeprivkey=YOURGENKEYHERE' | sudo tee -a /root/.crown/crown.conf
    sudo cat /root/.crown/crown.conf
 # Notes
    echo Please continue with the guide...
        else
        if [ $choice -eq 3 ] ; then
            echo "Would you like to Update or Install CrownPi?"
                else
                    echo "Please make a choice between Update or Install !"
                    echo "1. Update"
                    echo "2. Install"
                    echo -n "1 for Update 2 for Install [1 or 2]? "
                    choice=3
        fi   
        fi
    fi
    echo "Done"
    echo
    done
    else
        if [ $choice -eq 3 ] ; then
            echo "Are you using Linux or Raspberry Pi?"
                else
                    echo "Please make a choice between Linux or RPI !"
                    echo "1. Linux"
                    echo "2. RPI"
                    echo -n "1 for Linux 2 for RPI [1 or 2]? "
                    choice=3
        fi   
        fi
    fi
    done