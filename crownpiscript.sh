#!/bin/bash

# Clear Screen
clear_screen() {
     clear
     echo "  _____                         _____ _ " 
     echo " / ____|                       |  __ (_)"
     echo "| |     _ __ _____      ___ __ | |__) | "
     echo "| |    | '__/ _ \ \ /\ / / '_ \|  ___/ |"
     echo "| |____| | | (_) \ V  V /| | | | |   | |"
     echo " \_____|_|  \___/ \_/\_/ |_| |_|_|   |_|"     
     sleep 3
     echo Installing...
     sleep 2
}

# Software install
install_dependencies() {
    echo Installing software...
    sudo apt-get install ufw -y
    sudo apt-get install unzip -y
    sudo apt-get install nano -y
    sudo apt-get install p7zip -y
}

# Attempt to create 1GB swap ram
create_swap() {
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
    echo
    echo "Done"
    fi
}

# Update OS
update_repos() {
    echo
    echo "Making sure the system is up to date (this could take a few minutes)."
    sudo apt-get update >/dev/null 2>&1
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade >/dev/null 2>&1
    sudo apt autoremove -y >/dev/null 2>&1
    echo
    echo "Done"
}

# Maintenance scripts
maintenance_scripts() {
    echo Downloading watchdog script...
    sudo curl -o /usr/local/bin/crown-server-install.sh https://raw.githubusercontent.com/Crowndev/crowncoin/master/scripts/crown-server-install.sh
    sudo chmod +x /usr/local/bin/crown-server-install.sh
    sudo crown-server-install.sh -w 1
    echo Would you like to download the bootstrap?
    choice=3
    echo "1. Yes"
    echo "2. No"
    echo -n "1 for Yes 2 for No [1 or 2]? "
    while [ $choice -eq 3 ]; do
    read choice
    if [ $choice -eq 1 ] ; then
    echo Downloading bootstrap
    sudo crown-server-install.sh -c -b
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
    done
}

# Download Crown client (Update link with new client)
download_package() {
    # Password change prompt
    echo Getting 0.13.4 MN-PoS client...
    # Create temporary directory
    dir=`mktemp -d`
    if [ -z "$dir" ]; then
        # Create directory under $HOME if above operation failed
        dir=$HOME/crown-temp
        mkdir -p $dir
    fi
    # Change this later to take latest release version.
    sudo wget "https://github.com/Crowndev/crown-core/releases/download/v0.13.4.0/Crown-0.13.4.0-RaspberryPi.zip" -O $dir/crown.zip
}

# Install Crown client
install_package() {
    echo Installing Crown client...
    sudo unzip -d $dir/crown $dir/crown.zip
    sudo cp -f $dir/crown/*/bin/* /usr/local/bin/
    sudo cp -f $dir/crown/*/lib/* /usr/local/lib/
    sudo rm -rf $tmp
}

# Firewall
configure_firewall() {
    echo Setting up firewall...
    sudo ufw allow ssh/tcp
    sudo ufw limit ssh/tcp
    sudo ufw allow 9340/tcp
}

# Zabbix Install
zabbix_install() {
# Declare variable choice and assign value 4
    echo Would you like to install a Zabbix agent?
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
}

# NordVPN Install
vpn_install() {
# Declare variable choice and assign value 4
    echo Please choose a VPN provider...
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
}

configure_conf() {
    echo Setting up crown.conf
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
}

# Crown package
main() {
    # Clear screen
    clear_screen
    # Stop crownd (in case it's running)
    sudo crown-cli stop
    # Create swap to help with sync
    create_swap
    # Update Repos
    update_repos
    # Install Packages
    install_dependencies
    # Maintenance Scripts
    maintenance_scripts
    # Download the latest release
    download_package
    # Extract and install
    install_package
    # Configure firewall
    configure_firewall
    # Maintenance Scripts
    zabbix_install
    # Install VPN
    vpn_install
    # Create folder structures and configure crown.conf
    configure_conf
}

main

# Notes
echo Please continue with the guide...