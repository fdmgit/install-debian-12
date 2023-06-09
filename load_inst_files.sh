#!/bin/bash

wget https://raw.githubusercontent.com/fdmgit/install-debian-12/main/bashrc.ini
wget https://raw.githubusercontent.com/fdmgit/install-debian-12/main/instp1.sh
wget https://raw.githubusercontent.com/fdmgit/install-debian-12/main/instp2.sh

cp bashrc.ini /root/.bashrc
rm /root/bashrc.ini

chmod +x /root/instp1.sh
chmod +x /root/instp2.sh
