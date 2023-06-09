#!/bin/bash

apt update

###################################
#### Install Debian 12
###################################

apt upgrade -y 
apt install plocate sntp ntpdate software-properties-common -y 
hostnamectl set-hostname $2  # set hostname

apt update 

echo "root:$1" | chpasswd    # set root password -

###################################
#### Add gat (replacement for cat)
###################################

cd /usr/local/bin
wget https://github.com/koki-develop/gat/releases/download/v0.8.2/gat_Linux_arm64.tar.gz
tar -xvzf gat_Linux_arm64.tar.gz
chown root:root gat
chmod +x gat
rm gat_Linux_arm64.tar.gz
rm LICENSE
rm README.md

##############################
#### Install Virtualmin
##############################

wget -O virtualmin-install_arm.sh https://raw.githubusercontent.com/fdmgit/install-debian-12/main/virtualmin-install_arm.sh
sh virtualmin-install_arm.sh -y
rm virtualmin-install_arm.sh
reboot
