#!/bin/bash

# Manual
# Password change prompt
echo Please change device password...
passwd

# Software install
echo Installing software...
install_dependencies() {
    sudo apt-get install ufw -y
    sudo apt-get install unzip -y
    sudo apt-get install nano -y
    sudo apt-get install p7zip -y
}

# Attempt to create 1GB swap ram
echo Creating swap ram...
create_swap() {
    sudo mkdir -p /var/cache/swap/   
    sudo dd if=/dev/zero of=/var/cache/swap/myswap bs=1M count=1024
    sudo chmod 600 /var/cache/swap/myswap
    sudo mkswap /var/cache/swap/myswap
    sudo swapon /var/cache/swap/myswap
    swap_line='/var/cache/swap/myswap   none    swap    sw  0   0'
    # Add the line only once 
    sudo grep -q -F "$swap_line" /etc/fstab || echo "$swap_line" | sudo tee --append /etc/fstab > /dev/null
    cat /etc/fstab
}

# Update OS
echo Updateing OS, please wait...
update_repos() {
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" update
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
}

# Download Crown client (Update link with new client)
download_package() {
    # Password change prompt
    echo Getting 0.12.5.1 client
    # Create temporary directory
    dir=`mktemp -d`
    if [ -z "$dir" ]; then
        # Create directory under $HOME if above operation failed
        dir=$HOME/crown-temp
        mkdir -p $dir
    fi
    # Change this later to take latest release version.
    wget "https://github.com/Crowndev/crown-core/releases/download/v0.12.5.1/Crown-RaspberryPi.zip" -O $dir/crown.zip
}

# Install Crown client
install_package() {
    sudo unzip -d $dir/crown $dir/crown.zip
    sudo cp -f $dir/crown/*/bin/* /usr/local/bin/
    sudo cp -f $dir/crown/*/lib/* /usr/local/lib/
    sudo rm -rf $tmp
}

# Firewall
echo Setting up firewall
configure_firewall() {
    sudo ufw allow ssh/tcp
    sudo ufw limit ssh/tcp
    sudo ufw allow 9340/tcp
    sudo ufw allow 53/udp
    sudo ufw allow 111/udp
    sudo ufw allow 123/udp
    sudo ufw allow 443/udp
    sudo ufw allow 1194/udp
    sudo ufw allow 8282/udp
    sudo ufw logging on
    sudo ufw --force enable
}

# Crown package
main() {
    # Stop crownd (in case it's running)
    sudo crown-cli stop
    # Install Packages
    install_dependencies
    # Download the latest release
    download_package
    # Extract and install
    install_package

    if [ "$install" = true ] ; then
        # Create swap to help with sync
        create_swap
        # Update Repos
        update_repos
        # Create folder structures and configure crown.conf
        configure_conf
        # Configure firewall
        configure_firewall
    fi

}

handle_arguments "$@"
main

# Crontab additions 
echo Adding to Crontab...
    (crontab -l 2>/dev/null; echo "@reboot sudo /usr/local/bin/crownd") | crontab -
    (crontab -l 2>/dev/null; echo "*/30 * * * * restart.sh") | crontab -

# Maintenance scripts
echo Downloading scripts and other useful tools, please wait...
    sudo wget "https://www.dropbox.com/s/kucyc0fupop6vca/crwrestart.sh?dl=0" -O restart.sh | bash && sudo chmod +x restart.sh
    sudo wget "https://www.dropbox.com/s/hbb7516orhf7saq/update.sh?dl=0" -O update.sh | bash && sudo chmod +x update.sh
    sudo wget "https://www.dropbox.com/s/gq4vxog7riom739/whatsmyip.sh?dl=0" -O whatsmyip.sh | bash && sudo chmod +x whatsmyip.sh





# Declare variable choice and assign value 4
echo Please choose your VPN provider...
choice=4
# Print to stdout
 echo "1. NordVPN"
 echo "2. VPN Area"
 echo "3. Example"
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
	sudo chmod 755 /etc/openvpn
	echo Please enter your NordVPN username and password, with the username at the top and password below the username.
	read -p "Press enter to continue"
	sudo nano /etc/openvpn/auth.txt
	sleep 5
	sudo ls -a /etc/openvpn/nordvpn
	echo 1 - Choose from the list of regions - EG sudo ls -a /etc/openvpn/usservers
	echo Once you have decided which server to use, edit this line with new server details, EG - sudo cp /etc/openvpn/nordvpn/usservers/us998.nordvpn.com.udp.ovpn /etc/openvpn/nordvpn.conf
	echo Use http://avaxhome.online/assets/nordvpn_full_server_locations_list.txt to see a full list of NordVPN servers.
        

else                   

        if [ $choice -eq 2 ] ; then
                 echo "You have chosen VPN Area"
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
                        echo "You have chosen word: Tutorial"
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


# Notes
echo -note- Please continue with the guide...
