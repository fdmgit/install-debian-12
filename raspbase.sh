#!/bin/bash

wget https://raw.githubusercontent.com/fdmgit/install-debian-12/main/bashrc.ini

cp bashrc.ini /root/.bashrc
rm /root/bashrc.ini

###################################
#### Setup root key file
###################################

if [ -d /root/.ssh ]; then 
    echo ".ssh exists"
else
    mkdir /root/.ssh
fi

if [ -f /root/.ssh/authorized_keys ]; then
    echo "file authorized_keys exists"
else
    cd /root/.ssh
    wget https://raw.githubusercontent.com/fdmgit/virtualmin/main/authorized_keys
fi

apt update && apt upgrade -y

apt install curl sudo software-properties-common -y

apt install keyboard-configuration console-setup locale -y

dpkg-reconfigure keyboard-configuration

