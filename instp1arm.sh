#!/bin/bash

apt update

###################################
#### Install Debian 12
###################################

apt upgrade -y 
apt install plocate sntp ntpdate software-properties-common curl -y
timedatectl set-timezone Europe/Zurich
hostnamectl set-hostname $2  # set hostname

apt update 

echo "root:$1" | chpasswd    # set root password -

###################################
#### Add gat (replacement for cat)
###################################

cd /usr/local/bin
wget https://github.com/koki-develop/gat/releases/download/v0.8.3/gat_Linux_arm64.tar.gz
tar -xvzf gat_Linux_arm64.tar.gz
chown root:root gat
chmod +x gat
rm gat_Linux_arm64.tar.gz
rm LICENSE
rm README.md

###################################
#### Add joshuto (cli filemanager)
###################################

cd /usr/local/bin
wget https://github.com/kamiyaa/joshuto/releases/download/v0.9.4/joshuto-v0.9.4-aarch64-unknown-linux-gnu.tar.gz
tar -vxzf joshuto-v0.9.4-aarch64-unknown-linux-gnu.tar.gz -C /usr/local/bin  --strip-components=1
chown root:root joshuto
chmod +x joshuto
rm joshuto-v0.9.4-aarch64-unknown-linux-gnu.tar.gz


###################################
#### Build aliases file
###################################

cd /root
touch .bash_aliases
echo "alias jos='joshuto'" >> .bash_aliases
echo "alias gc='gat'" >> .bash_aliases


##############################
#### Install Virtualmin
##############################

apt install gpg-agent -y

wget -O virtualmin-install_arm.sh https://raw.githubusercontent.com/fdmgit/install-debian-12/main/virtualmin-install_arm.sh
sh virtualmin-install_arm.sh -y
rm virtualmin-install_arm.sh
reboot
