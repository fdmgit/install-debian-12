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


wget https://raw.githubusercontent.com/fdmgit/install-debian-12/main/bashrc.ini
wget https://raw.githubusercontent.com/fdmgit/install-debian-12/main/inst_deb12.sh

cp bashrc.ini /root/.bashrc
cp bashrc.ini /etc/skel/.bashrc
rm /root/bashrc.ini

echo "deb http://deb.debian.org/debian/ bookworm-backports main" | tee -a /etc/apt/sources.list

chmod +x /root/inst_deb12.sh

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

###################################
#### SSH Hardening
#### https://sshaudit.com
###################################

#### Re-generate the RSA and ED25519 keys
rm /etc/ssh/ssh_host_*
ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key -N ""
ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""

#### Remove small Diffie-Hellman moduli
awk '$5 >= 3071' /etc/ssh/moduli > /etc/ssh/moduli.safe
mv /etc/ssh/moduli.safe /etc/ssh/moduli

#### Restrict supported key exchange, cipher, and MAC algorithms
echo -e "# Restrict key exchange, cipher, and MAC algorithms, as per sshaudit.com\n# hardening guide.\n\nKexAlgorithms sntrup761x25519-sha512@openssh.com,curve25519-sha256,curve25519-sha256@libssh.org,gss-curve25519-sha256-,diffie-hellman-group16-sha512,gss-group16-sha512-,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha256\n\nCiphers aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr\n\nMACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com\n\nHostKeyAlgorithms sk-ssh-ed25519-cert-v01@openssh.com,ssh-ed25519-cert-v01@openssh.com,rsa-sha2-512-cert-v01@openssh.com,rsa-sha2-256-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,ssh-ed25519,rsa-sha2-512,rsa-sha2-256\n\nRequiredRSASize 3072\n\nCASignatureAlgorithms sk-ssh-ed25519@openssh.com,ssh-ed25519,rsa-sha2-512,rsa-sha2-256\n\nGSSAPIKexAlgorithms gss-curve25519-sha256-,gss-group16-sha512-\n\nHostbasedAcceptedAlgorithms sk-ssh-ed25519-cert-v01@openssh.com,ssh-ed25519-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,ssh-ed25519,rsa-sha2-512-cert-v01@openssh.com,rsa-sha2-512,rsa-sha2-256-cert-v01@openssh.com,rsa-sha2-256\n\nPubkeyAcceptedAlgorithms sk-ssh-ed25519-cert-v01@openssh.com,ssh-ed25519-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,ssh-ed25519,rsa-sha2-512-cert-v01@openssh.com,rsa-sha2-512,rsa-sha2-256-cert-v01@openssh.com,rsa-sha2-256\n\n" > /etc/ssh/sshd_config.d/ssh-audit_hardening.conf

sed -i "s|\#Port 22|Port 49153|g" /etc/ssh/sshd_config
sed -i "s|\#MaxAuthTries 6|MaxAuthTries 4|g" /etc/ssh/sshd_config
sed -i "s|X11Forwarding yes|X11Forwarding no|g" /etc/ssh/sshd_config
sed -i "s|session    required     pam_env.so user_readenv=1 envfile=/etc/default/locale|session    required     pam_env.so envfile=/etc/default/locale|g" /etc/pam.d/sshd

# Closing message
echo ""
echo -e "${YELLOW}ATTENTION\\n"
echo -e "${GREEN}The port for SSH has changed. To login use the following comand:\\n"
echo -e "        ssh root@${ip_address} -p 49153${NC}\\n"

cd /root
rm compl_files.sh
reboot
