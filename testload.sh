#!/bin/bash

# Define colors
RED='\033[0;31m'
LRED='\033[0;91m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'

# Retrieve the IP address
ip_address=$(hostname -I | awk '{print $1}')

wget https://raw.githubusercontent.com/fdmgit/install-debian-12/main/instp1.sh
wget https://raw.githubusercontent.com/fdmgit/install-debian-12/main/instp2.sh


# Closing message
echo ""
echo -e "${YELLOW}ATTENTION\\n"
echo -e "${GREEN}The port for SSH has changed. To login use the following comand:\\n"
echo -e "        ssh root@${ip_address} -p 49153${NC}\\n"


reboot
