#!/bin/bash

apt update

###################################
#### Install updated Ubuntu Version
###################################

apt upgrade -y 
apt install plocate sntp ntpdate software-properties-common -y 
hostnamectl set-hostname $2


apt update 
#passwd root
echo "root:$1" | chpasswd   # set root password -

cd /usr/local/bin
wget https://github.com/koki-develop/gat/releases/download/v0.8.2/gat_Linux_arm64.tar.gz
tar -xvzf gat_Linux_arm64.tar.gz
chown root:root gat
chmod +x gat
rm gat_Linux_arm64.tar.gz
rm LICENSE
rm README.md

##############################
#### Prepare for MariDB 10.11
##############################

apt-get install apt-transport-https curl
mkdir -p /etc/apt/keyrings
curl -o /etc/apt/keyrings/mariadb-keyring.pgp 'https://mariadb.org/mariadb_release_signing_key.pgp'

wget https://raw.githubusercontent.com/fdmgit/install-debian-11/main/mariadb_repo
cp mariadb_repo /etc/apt/sources.list.d/mariadb.sources
rm mariadb_repo
apt update


##############################
#### Install Virtualmin
##############################

wget -O virtualmin-install_arm.sh https://raw.githubusercontent.com/fdmgit/install-ubuntu-22.04/main/virtualmin-install_arm.sh
sh virtualmin-install_arm.sh -y
reboot
