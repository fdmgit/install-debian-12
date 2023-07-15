#!/bin/bash

wget https://raw.githubusercontent.com/fdmgit/install-debian-12/main/bashrc.ini
wget https://raw.githubusercontent.com/fdmgit/install-debian-12/main/instp1arm.sh
wget https://raw.githubusercontent.com/fdmgit/install-debian-12/main/instp2arm.sh

cp bashrc.ini /root/.bashrc
rm /root/bashrc.ini

chmod +x /root/instp1arm.sh
chmod +x /root/instp2arm.sh

reboot
