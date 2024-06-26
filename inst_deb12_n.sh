#!/bin/bash



##################################################
#             Var / Const Definition             #
##################################################

okinput=true

NC=$(echo -en '\001\033[0m\002')
RED=$(echo -en '\001\033[00;31m\002')
GREEN=$(echo -en '\001\033[00;32m\002')
YELLOW=$(echo -en '\001\033[00;33m\002')
BLUE=$(echo -en '\001\033[00;34m\002')
MAGENTA=$(echo -en '\001\033[00;35m\002')
PURPLE=$(echo -en '\001\033[00;35m\002')
CYAN=$(echo -en '\001\033[00;36m\002')
WHITE=$(echo -en '\001\033[01;37m\002')

LIGHTGRAY=$(echo -en '\001\033[00;37m\002')
LRED=$(echo -en '\001\033[01;31m\002')
LGREEN=$(echo -en '\001\033[01;32m\002')
LYELLOW=$(echo -en '\001\033[01;33m\002')
LBLUE=$(echo -en '\001\033[01;34m\002')
LMAGENTA=$(echo -en '\001\033[01;35m\002')
LPURPLE=$(echo -en '\001\033[01;35m\002')
LCYAN=$(echo -en '\001\033[01;36m\002')


##################################################
#                   Functions                    #
##################################################


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

function inst_logo_styles () {

###################################
#### add logo and styles
###################################

	cd /root

cat >> /root/inst_logo_styles.sh <<'EOF'

wget https://raw.githubusercontent.com/fdmgit/virtualmin/main/logostyle.zip
unzip logostyle.zip
cp logo.png /etc/webmin/authentic-theme/
cp logo_welcome.png /etc/webmin/authentic-theme/
cp styles.css /etc/webmin/authentic-theme/
rm logo.png
rm logo_welcome.png
rm styles.css
rm logostyle.zip
rm inst_logo_styles.sh

EOF

	chmod +x /root/inst_logo_styles.sh

}

function install_virtualmin_config () {

###################################
#### add config files to Virtualmin
###################################

	cd /etc/webmin/virtual-server/plans
	wget https://raw.githubusercontent.com/fdmgit/virtualmin/main/160880314564582
	cd /etc/webmin/virtual-server/templates
	wget https://raw.githubusercontent.com/fdmgit/virtualmin/main/server-level.tar.gz
	tar -xvzf server-level.tar.gz
	rm server-level.tar.gz

}

function inst_redis () {

##############################
#### Install Redis Server
##############################

	apt update
	apt install redis -y
	#systemctl enable --now redis-server
	#systemctl restart redis-server

cat >> /etc/sysctl.conf <<'EOF'

vm.overcommit_memory = 1

EOF

}

function inst_add_python () {

######################################
#### install additional Python modules
######################################

	apt install python3-venv -y
	apt install python3-pip -y
	apt install virtualenv -y

}

function inst_f2b () {

###################################
#### new fail2ban and jail
###################################

	cd /root

	wget -O fail2ban_newest.deb  https://github.com/fail2ban/fail2ban/releases/download/1.1.0/fail2ban_1.1.0-1.upstream1_all.deb
	dpkg -i --force-confnew fail2ban_newest.deb
	rm fail2ban_newest.deb

	#wget https://raw.githubusercontent.com/fdmgit/install-debian-12/main/jail-deb12.local
	#cd /etc/fail2ban
	#mv jail.local jail.local.orig
	#cp /root/jail-deb12.local jail.local
	#rm /root/jail-deb12.local
	touch /var/log/auth.log

}

function inst_pwgen () {

###################################
#### install password generator
###################################

	apt install pwgen -y

}


function inst_mc () {

#################################
#### Install Midnight Commander
#################################

	cd /usr/share/keyrings
	wget https://raw.githubusercontent.com/fdmgit/install-debian-12/main/tataranovich-keyring.gpg
	echo "# Repository for Midnight Commander" > /etc/apt/sources.list.d/mc.list
	echo "deb [signed-by=/usr/share/keyrings/tataranovich-keyring.gpg] http://www.tataranovich.com/debian bookworm main" >> /etc/apt/sources.list.d/mc.list

	apt update
	apt install mc -y

}

function inst_smart_nvme () {

######################################
#### Install smartmontools & nvme-cli
######################################

	cd /root
	wget  https://raw.githubusercontent.com/fdmgit/install-debian-12/main/smartmontools_7.4-2~bpo12+1_amd64.deb
	dpkg -i smartmontools_7.4-2~bpo12+1_amd64.deb
	rm smartmontools_7.4-2~bpo12+1_amd64.deb
	apt install nvme-cli -y

}

function inst_mariadb () {

##################################
#### Install MariaDB Repository
##################################

	curl -o /etc/apt/keyrings/mariadb-keyring.pgp 'https://mariadb.org/mariadb_release_signing_key.pgp'

	cd /etc/apt/sources.list.d
	touch mariadb.list

cat >> /etc/apt/sources.list.d/mariadb.list <<'EOF'

# deb.mariadb.org is a dynamic mirror if your preferred mirror goes offline. See https://mariadb.org/mirrorbits/ for details.
# deb [signed-by=/etc/apt/keyrings/mariadb-keyring.pgp] https://deb.mariadb.org/10.11/debian bookworm main

deb [signed-by=/etc/apt/keyrings/mariadb-keyring.pgp] https://mirror.mva-n.net/mariadb/repo/10.11/debian bookworm main
# deb-src [signed-by=/etc/apt/keyrings/mariadb-keyring.pgp] https://mirror.mva-n.net/mariadb/repo/10.11/debian bookworm main

EOF

	apt update
	apt upgrade -y

	cd /etc/mysql/mariadb.conf.d
	ls provider*.cnf | xargs -I{} mv {} {}.orig
	apt autoremove -y

}


function inst_kernel () {

##############################
#### Install new Linux Kernel
##############################

	apt install linux-image-6.6.13+bpo-amd64 -y
	apt install linux-headers-6.6.13+bpo-amd64 -y

}


function inst_sury_repo () {

##############################
#### install new PHP versions
##############################

	apt -y install lsb-release apt-transport-https ca-certificates
	echo | curl -sSL https://packages.sury.org/apache2/README.txt | sudo bash -xe
	wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
	echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
	apt update
	apt upgrade -y

}


function inst_php74 () {

	apt install php7.4-bcmath php7.4-bz2 php7.4-cgi php7.4-curl php7.4-dba -y
	apt install php7.4-gd php7.4-gmp php7.4-imap php7.4-fpm php7.4-json php7.4-xml php7.4-common -y
	apt install php7.4-intl php7.4-ldap php7.4-mbstring php7.4-mysql php7.4-odbc php7.4-pspell -y
	apt install php7.4-soap php7.4-sqlite3 php7.4-tidy php7.4-xmlrpc php7.4-xsl php7.4-zip php7.4-imagick php7.4-redis -y

cat >> /etc/php/7.4/fpm/php.ini <<'EOF'

[PHP]
output_buffering = Off
max_execution_time = 300
max_input_time = 300
memory_limit = 512M
post_max_size = 1024M
upload_max_filesize = 1024M
date.timezone = Europe/Zurich
max_input_vars = 10000
[Session]
session.gc_maxlifetime = 3600

EOF

cat >> /etc/php/7.4/cgi/php.ini <<'EOF'

[PHP]
output_buffering = Off
max_execution_time = 300
max_input_time = 300
memory_limit = 512M
post_max_size = 1024M
upload_max_filesize = 1024M
date.timezone = Europe/Zurich
max_input_vars = 10000
[Session]
session.gc_maxlifetime = 3600

EOF

cat >> /etc/php/7.4/cli/php.ini <<'EOF'

[PHP]
output_buffering = Off
max_execution_time = 300
max_input_time = 300
memory_limit = 512M
post_max_size = 1024M
upload_max_filesize = 1024M
date.timezone = Europe/Zurich
max_input_vars = 10000
[Session]
session.gc_maxlifetime = 3600

EOF

}

function inst_php80 () {

	apt install php8.0-bcmath php8.0-bz2 php8.0-cgi php8.0-curl php8.0-dba php8.0-fpm php8.0-gd -y
	apt install php8.0-gmp php8.0-igbinary php8.0-imagick php8.0-imap php8.0-intl php8.0-ldap php8.0-mbstring -y
	apt install php8.0-mysql php8.0-odbc php8.0-opcache php8.0-pspell php8.0-readline -y
	apt install php8.0-redis php8.0-soap php8.0-sqlite3 php8.0-tidy php8.0-xml php8.0-xmlrpc php8.0-xsl php8.0-zip -y

cat >> /etc/php/8.0/fpm/php.ini <<'EOF'

[PHP]
output_buffering = Off
max_execution_time = 300
max_input_time = 300
memory_limit = 512M
post_max_size = 1024M
upload_max_filesize = 1024M
date.timezone = Europe/Zurich
max_input_vars = 10000
[Session]
session.gc_maxlifetime = 3600     
[opcache]
opcache.enable=1
opcache.enable_cli=1
opcache.jit_buffer_size=256M

EOF

cat >> /etc/php/8.0/cgi/php.ini <<'EOF'

[PHP]
output_buffering = Off
max_execution_time = 300
max_input_time = 300
memory_limit = 512M
post_max_size = 1024M
upload_max_filesize = 1024M
date.timezone = Europe/Zurich
max_input_vars = 10000
[Session]
session.gc_maxlifetime = 3600     
[opcache]
opcache.enable=1
opcache.enable_cli=1
opcache.jit_buffer_size=256M

EOF

cat >> /etc/php/8.0/cli/php.ini <<'EOF'

[PHP]
output_buffering = Off
max_execution_time = 300
max_input_time = 300
memory_limit = 512M
post_max_size = 1024M
upload_max_filesize = 1024M
date.timezone = Europe/Zurich
max_input_vars = 10000
[Session]
session.gc_maxlifetime = 3600     
[opcache]
opcache.enable=1
opcache.enable_cli=1
opcache.jit_buffer_size=256M

EOF

}

function inst_php81 () {

	apt install php8.1-bcmath php8.1-bz2 php8.1-cgi php8.1-curl php8.1-dba php8.1-fpm -y
	apt install php8.1-gd php8.1-gmp php8.1-igbinary php8.1-imagick php8.1-imap php8.1-intl php8.1-ldap php8.1-mbstring -y
	apt install php8.1-mysql php8.1-odbc php8.1-opcache php8.1-pspell php8.1-readline -y
	apt install php8.1-redis php8.1-soap php8.1-sqlite3 php8.1-tidy php8.1-xml php8.1-xmlrpc php8.1-xsl php8.1-zip -y

cat >> /etc/php/8.1/fpm/php.ini <<'EOF'

[PHP]
output_buffering = Off
max_execution_time = 300
max_input_time = 300
memory_limit = 512M
post_max_size = 1024M
upload_max_filesize = 1024M
date.timezone = Europe/Zurich
max_input_vars = 10000
[Session]
session.gc_maxlifetime = 3600     
[opcache]
opcache.enable=1
opcache.enable_cli=1
opcache.jit_buffer_size=256M

EOF


cat >> /etc/php/8.1/cgi/php.ini <<'EOF'

[PHP]
output_buffering = Off
max_execution_time = 300
max_input_time = 300
memory_limit = 512M
post_max_size = 1024M
upload_max_filesize = 1024M
date.timezone = Europe/Zurich
max_input_vars = 10000
[Session]
session.gc_maxlifetime = 3600     
[opcache]
opcache.enable=1
opcache.enable_cli=1
opcache.jit_buffer_size=256M

EOF


cat >> /etc/php/8.1/cli/php.ini <<'EOF'

[PHP]
output_buffering = Off
max_execution_time = 300
max_input_time = 300
memory_limit = 512M
post_max_size = 1024M
upload_max_filesize = 1024M
date.timezone = Europe/Zurich
max_input_vars = 10000
[Session]
session.gc_maxlifetime = 3600     
[opcache]
opcache.enable=1
opcache.enable_cli=1
opcache.jit_buffer_size=256M

EOF

}

function inst_php82 () {

	apt install php8.2-bcmath php8.2-bz2 php8.2-cgi php8.2-curl php8.2-dba php8.2-fpm -y
	apt install php8.2-gd php8.2-gmp php8.2-igbinary php8.2-imagick php8.2-imap php8.2-intl php8.2-ldap php8.2-mbstring -y
	apt install php8.2-mysql php8.2-odbc php8.2-opcache php8.2-pspell php8.2-readline -y
	apt install php8.2-redis php8.2-soap php8.2-sqlite3 php8.2-tidy php8.2-xml php8.2-xmlrpc php8.2-xsl php8.2-zip -y

cat >> /etc/php/8.2/fpm/php.ini <<'EOF'

[PHP]
output_buffering = Off
max_execution_time = 300
max_input_time = 300
memory_limit = 512M
post_max_size = 1024M
upload_max_filesize = 1024M
date.timezone = Europe/Zurich
max_input_vars = 10000
[Session]
session.gc_maxlifetime = 3600     
[opcache]
opcache.enable=1
opcache.enable_cli=1
opcache.jit_buffer_size=256M

EOF


cat >> /etc/php/8.2/cgi/php.ini <<'EOF'

[PHP]
output_buffering = Off
max_execution_time = 300
max_input_time = 300
memory_limit = 512M
post_max_size = 1024M
upload_max_filesize = 1024M
date.timezone = Europe/Zurich
max_input_vars = 10000
[Session]
session.gc_maxlifetime = 3600     
[opcache]
opcache.enable=1
opcache.enable_cli=1
opcache.jit_buffer_size=256M

EOF


cat >> /etc/php/8.2/cli/php.ini <<'EOF'

[PHP]
output_buffering = Off
max_execution_time = 300
max_input_time = 300
memory_limit = 512M
post_max_size = 1024M
upload_max_filesize = 1024M
date.timezone = Europe/Zurich
max_input_vars = 10000
[Session]
session.gc_maxlifetime = 3600     
[opcache]
opcache.enable=1
opcache.enable_cli=1
opcache.jit_buffer_size=256M

EOF

}

function inst_php83 () {

	apt install php8.3-bcmath php8.3-bz2 php8.3-cgi php8.3-curl php8.3-dba php8.3-fpm -y
	apt install php8.3-gd php8.3-gmp php8.3-igbinary php8.3-imagick php8.3-imap php8.3-intl php8.3-ldap php8.3-mbstring -y
	apt install php8.3-mysql php8.3-odbc php8.3-opcache php8.3-pspell php8.3-readline -y
	apt install php8.3-redis php8.3-soap php8.3-sqlite3 php8.3-tidy php8.3-xml php8.3-xmlrpc php8.3-xsl php8.3-zip -y


cat >> /etc/php/8.3/cgi/php.ini <<'EOF'

[PHP]
output_buffering = Off
max_execution_time = 300
max_input_time = 300
memory_limit = 512M
post_max_size = 1024M
upload_max_filesize = 1024M
date.timezone = Europe/Zurich
max_input_vars = 10000
[Session]
session.gc_maxlifetime = 3600     
[opcache]
opcache.enable=1
opcache.enable_cli=1
opcache.jit_buffer_size=256M

EOF


cat >> /etc/php/8.3/cli/php.ini <<'EOF'

[PHP]
output_buffering = Off
max_execution_time = 300
max_input_time = 300
memory_limit = 512M
post_max_size = 1024M
upload_max_filesize = 1024M
date.timezone = Europe/Zurich
max_input_vars = 10000
[Session]
session.gc_maxlifetime = 3600     
[opcache]
opcache.enable=1
opcache.enable_cli=1
opcache.jit_buffer_size=256M

EOF

cat >> /etc/php/8.3/fpm/php.ini <<'EOF'

[PHP]
output_buffering = Off
max_execution_time = 300
max_input_time = 300
memory_limit = 512M
post_max_size = 1024M
upload_max_filesize = 1024M
date.timezone = Europe/Zurich
max_input_vars = 10000
[Session]
session.gc_maxlifetime = 3600     
[opcache]
opcache.enable=1
opcache.enable_cli=1
opcache.jit_buffer_size=256M

EOF

}

function enable_apache_mod () {

#####################################
#### Enable additional Apache modules
#####################################

	a2enmod http2
	a2enmod headers
	a2enmod expires
	a2enmod include
	a2enmod proxy_http2

}

function dis_services () {

##############################
#### Disable Services     ####
##############################

	systemctl disable named
	systemctl disable usermin
	systemctl disable dovecot
	systemctl disable proftpd
	systemctl disable clamav-freshclam
	systemctl disable clamav-daemon
	systemctl disable postgrey
	systemctl disable postfix

}


function post_inst () {

##############################
#### Update locate DB
##############################

	cd /root
	touch .bash_aliases
        echo "alias jos='joshuto'" >> .bash_aliases
        echo "alias gc='gat'" >> .bash_aliases
	cp .bash_aliases /etc/skel/.bash_aliases
	rm -R .spamassassin
	rm inst_deb12_n.sh
	updatedb

}

function inst_virtualmin () {

##############################
#### Install Virtualmin
##############################

	apt install gpg-agent -y

	cd /root

	#wget -O virtualmin-install.sh https://raw.githubusercontent.com/virtualmin/virtualmin-install/master/virtualmin-install.sh
	wget -O virtualmin-install.sh https://software.virtualmin.com/gpl/scripts/virtualmin-install.sh
	sh virtualmin-install.sh -y
	rm virtualmin-install.sh

}

function inst_gat () {

###################################
#### Add gat (replacement for cat)
###################################

	cd /usr/local/bin
	wget https://github.com/koki-develop/gat/releases/download/v0.17.0/gat_Linux_x86_64.tar.gz
	tar -xvzf gat_Linux_x86_64.tar.gz
	chown root:root gat
	chmod +x gat
	rm gat_Linux_x86_64.tar.gz
	rm LICENSE
	rm README.md

}

function inst_jos () {

###################################
#### Add joshuto (cli filemanager)
###################################

	cd /usr/local/bin
	wget https://github.com/kamiyaa/joshuto/releases/download/v0.9.8/joshuto-v0.9.8-x86_64-unknown-linux-gnu.tar.gz
	tar -xvzf joshuto-v0.9.8-x86_64-unknown-linux-gnu.tar.gz
	tar -vxzf joshuto-v0.9.8-x86_64-unknown-linux-gnu.tar.gz -C /usr/local/bin  --strip-components=1
	chown root:root joshuto
	chmod +x joshuto
	rm joshuto-v0.9.8-x86_64-unknown-linux-gnu.tar.gz
	rm -R joshuto-v0.9.8-x86_64-unknown-linux-gnu

}

function inst_base () {


###################################
#### Install Debian 12 Base
###################################
	apt update
	apt upgrade -y 
	apt install plocate sntp ntpdate software-properties-common curl -y 
	timedatectl set-timezone Europe/Zurich

	hostnamectl set-hostname $fqdn  # set hostname
	echo "root:${rpasswd}" | chpasswd    # set root password -

}



##################################################
#               Start Installation               #
##################################################



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


###########################################################################
###########################################################################


inst_base                # function
inst_smart_nvme          # function
inst_gat                 # function
inst_jos                 # function
inst_virtualmin          # function
inst_add_python          # function
dis_services             # function
inst_sury_repo           # function
inst_php74               # function
inst_php80               # function
inst_php81               # function
inst_php82               # function
inst_php83               # function
enable_apache_mod        # function
inst_redis               # function
inst_virtualmin_config   # function
inst_logo_styles         # function
inst_f2b                 # function
inst_pwgen               # function
inst_mc                  # function
inst_kernel              # function
inst_mariadb             # function
post_inst                # function


reboot


