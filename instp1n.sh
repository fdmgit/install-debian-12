#!/bin/bash

RED='\033[0;31m'
LRED='\033[0;91m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'

function print_header () {
   clear
   echo ""
   echo -e "${YELLOW}     Welcome to the Debian 12 System installer!${NC}"
   echo -e "${GREEN}"
   echo "     I need to ask you a few questions before starting the setup."
   echo ""
}

function print_conf () {
   clear
   echo ""
   echo -e "${YELLOW}     Debian 12 System installer${NC}"
   echo -e "${GREEN}"
   echo "     Your input is:"
   echo ""
}

rpasswd=""
fqdn=""

print_header

until [ ${#rpasswd} -gt 11 ]; do
   echo -en "${GREEN}     Enter new root password [min. length is 12 char]: ${YELLOW} "
   read -e -i "${rpasswd}" rpasswd
   if [ ${#rpasswd} -lt 12 ]; then
      print_header
      echo -e "${LRED}     Password has too few characters"
   fi
done

print_header
echo -e "${GREEN}     Enter new root password [min. length is 12 char]:  ${YELLOW}${rpasswd}"

until [[ "$fqdn" =~ ^.*\..*\..*$ ]]; do
#   print_header
#   echo -e "${GREEN}     Enter new root password [min. length is 12 char]:  ${YELLOW}${rpasswd}"
   echo -en "${GREEN}     Enter a full qualified domain name:               ${YELLOW} "
   read -e -i "${fqdn}" fqdn
   if [[ "$fqdn" =~ ^.*\..*\..*$ ]]; then
      print_conf
      echo -e "${GREEN}     New root password:           ${YELLOW}${rpasswd}"
      echo -e "${GREEN}     Full qualified domain name:  ${YELLOW}${fqdn}"
   else
      print_header
      echo -e "${GREEN}     Enter new root password [min. length is 12 char]:  ${YELLOW}${rpasswd}"
      echo ""
      echo -e "${LRED}     The FQDN is not correct"   
   fi
done

echo -e "${NC}"
read -r -p "     Ready to start installation [Y/n] ? " start_inst
if [[ "$start_inst" = "" ]]; then
   start_inst="Y"
fi
if [[ "$start_inst" != [yY] ]]; then
   clear
   exit
fi   

apt update

###################################
#### Install Debian 12
###################################

apt upgrade -y 
apt install plocate sntp ntpdate software-properties-common curl nvme-cli smartmontools -y 
timedatectl set-timezone Europe/Zurich
hostnamectl set-hostname $fqdn  # set hostname

apt update 

echo "root:${rpasswd}" | chpasswd    # set root password -

###################################
#### Add gat (replacement for cat)
###################################

cd /usr/local/bin
wget https://github.com/koki-develop/gat/releases/download/v0.16.0/gat_Linux_x86_64.tar.gz
tar -xvzf gat_Linux_x86_64.tar.gz
chown root:root gat
chmod +x gat
rm gat_Linux_x86_64.tar.gz
rm LICENSE
rm README.md

###################################
#### Add joshuto (cli filemanager)
###################################

cd /usr/local/bin
wget https://github.com/kamiyaa/joshuto/releases/download/v0.9.6/joshuto-v0.9.6-x86_64-unknown-linux-gnu.tar.gz
tar -xvzf joshuto-v0.9.6-x86_64-unknown-linux-gnu.tar.gz
tar -vxzf joshuto-v0.9.6-x86_64-unknown-linux-gnu.tar.gz -C /usr/local/bin  --strip-components=1
chown root:root joshuto
chmod +x joshuto
rm joshuto-v0.9.6-x86_64-unknown-linux-gnu.tar.gz
rm -R joshuto-v0.9.6-x86_64-unknown-linux-gnu


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

#wget -O virtualmin-install.sh https://raw.githubusercontent.com/virtualmin/virtualmin-install/master/virtualmin-install.sh
wget -O virtualmin-install.sh https://software.virtualmin.com/gpl/scripts/virtualmin-install.sh
sh virtualmin-install.sh -y
rm virtualmin-install.sh
reboot

