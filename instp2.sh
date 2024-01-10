#!/bin/bash

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


##############################
#### install new PHP versions
##############################

apt -y install lsb-release apt-transport-https ca-certificates
echo | curl -sSL https://packages.sury.org/apache2/README.txt | sudo bash -xe
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
#echo "deb https://packages.sury.org/php/ buster main" | tee /etc/apt/sources.list.d/php.list
#echo "deb https://packages.sury.org/php/ bullseye main" | tee /etc/apt/sources.list.d/php.list
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
apt update
apt upgrade -y

systemctl restart apache2

apt update
apt upgrade -y

apt install php7.4-bcmath php7.4-bz2 php7.4-cgi php7.4-curl php7.4-dba -y
apt install php7.4-gd php7.4-gmp php7.4-imap php7.4-fpm php7.4-json php7.4-xml php7.4-common -y
apt install php7.4-intl php7.4-ldap php7.4-mbstring php7.4-mysql php7.4-odbc php7.4-pspell -y
apt install php7.4-soap php7.4-sqlite3 php7.4-tidy php7.4-xmlrpc php7.4-xsl php7.4-zip php7.4-imagick php7.4-redis -y

apt install php8.0-bcmath php8.0-bz2 php8.0-cgi php8.0-curl php8.0-dba php8.0-fpm php8.0-gd -y
apt install php8.0-gmp php8.0-igbinary php8.0-imagick php8.0-imap php8.0-intl php8.0-ldap php8.0-mbstring -y
apt install php8.0-mysql php8.0-odbc php8.0-opcache php8.0-pspell php8.0-readline -y
apt install php8.0-redis php8.0-soap php8.0-sqlite3 php8.0-tidy php8.0-xml php8.0-xmlrpc php8.0-xsl php8.0-zip -y

apt install php8.1-bcmath php8.1-bz2 php8.1-cgi php8.1-curl php8.1-dba php8.1-fpm -y
apt install php8.1-gd php8.1-gmp php8.1-igbinary php8.1-imagick php8.1-imap php8.1-intl php8.1-ldap php8.1-mbstring -y
apt install php8.1-mysql php8.1-odbc php8.1-opcache php8.1-pspell php8.1-readline -y
apt install php8.1-redis php8.1-soap php8.1-sqlite3 php8.1-tidy php8.1-xml php8.1-xmlrpc php8.1-xsl php8.1-zip -y

apt install php8.2-bcmath php8.2-bz2 php8.2-cgi php8.2-curl php8.2-dba php8.2-fpm -y
apt install php8.2-gd php8.2-gmp php8.2-igbinary php8.2-imagick php8.2-imap php8.2-intl php8.2-ldap php8.2-mbstring -y
apt install php8.2-mysql php8.2-odbc php8.2-opcache php8.2-pspell php8.2-readline -y
apt install php8.2-redis php8.2-soap php8.2-sqlite3 php8.2-tidy php8.2-xml php8.2-xmlrpc php8.2-xsl php8.2-zip -y

apt install php8.3-bcmath php8.3-bz2 php8.3-cgi php8.3-curl php8.3-dba php8.3-fpm -y
apt install php8.3-gd php8.3-gmp php8.3-igbinary php8.3-imagick php8.3-imap php8.3-intl php8.3-ldap php8.3-mbstring -y
apt install php8.3-mysql php8.3-odbc php8.3-opcache php8.3-pspell php8.3-readline -y
apt install php8.3-redis php8.3-soap php8.3-sqlite3 php8.3-tidy php8.3-xml php8.3-xmlrpc php8.3-xsl php8.3-zip -y

##############################
#### Change php.ini parameters
##############################

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



#####################################
#### Enable additional Apache modules
#####################################

a2enmod http2
a2enmod headers
a2enmod expires
a2enmod include
a2enmod proxy_http2


##############################
#### Restart Apache / PHP-FPM
##############################

systemctl restart apache2
systemctl restart php7.4-fpm.service
systemctl restart php8.0-fpm.service
systemctl restart php8.1-fpm.service
systemctl restart php8.2-fpm.service


######################################
#### install additional Python modules
######################################

apt install python3-venv -y
apt install python3-pip -y

cd /root


##############################
#### Install Redis Server
##############################

curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list
apt update
apt install redis -y
systemctl enable --now redis-server
systemctl restart redis-server

cat >> /etc/sysctl.conf <<'EOF'

vm.overcommit_memory = 1

EOF

###################################
#### add config files to Virtualmin
###################################

cd /etc/webmin/virtual-server/plans
wget https://raw.githubusercontent.com/fdmgit/virtualmin/main/160880314564582
cd /etc/webmin/virtual-server/templates
wget https://raw.githubusercontent.com/fdmgit/virtualmin/main/server-level.tar.gz
tar -xvzf server-level.tar.gz
rm server-level.tar.gz

cd /root

###################################
#### add logo and styles
###################################

wget https://raw.githubusercontent.com/fdmgit/virtualmin/main/logostyle.zip
unzip logostyle.zip
cp logo.png /etc/webmin/authentic-theme/
cp logo_welcome.png /etc/webmin/authentic-theme/
cp styles.css /etc/webmin/authentic-theme/
rm logo.png
rm logo_welcome.png
rm styles.css
rm logostyle.zip

cd /root

: <<'END'
wget https://raw.githubusercontent.com/fdmgit/virtualmin/main/settings.js
wget https://raw.githubusercontent.com/fdmgit/virtualmin/main/settings-root.js
cp settings.js /etc/webmin/authentic-theme/
cp settings-root.js /etc/webmin/authentic-theme/


###################################
#### left menu html
###################################

all_ip_addresses="$(hostname -I)";
ip_address_array=($all_ip_addresses);

local_host="$(hostname -s)";
local_host=${local_host^^};

leftmenu_user_html="<br /><kb><b><span style='font-size:20px;color:gold;'>""$local_host""</span></b></kb><br /><kb><span style='font-size:16px;color:gold;'>""${ip_address_array[0]}""</span></kb>";
leftmenu_user_html="settings_leftmenu_user_html='""$leftmenu_user_html""';";

sed -i "s|settings_leftmenu_user_html='';|$leftmenu_user_html|g" /etc/webmin/authentic-theme/settings.js
sed -i "s|settings_leftmenu_user_html='';|$leftmenu_user_html|g" /etc/webmin/authentic-theme/settings-root.js

cd /root
END

###################################
#### new fail2ban and jail
###################################

wget https://raw.githubusercontent.com/fdmgit/install-debian-12/main/jail-deb12.local
cd /etc/fail2ban
mv jail.local jail.local.orig
cp /root/jail-deb12.local jail.local
rm /root/jail-deb12.local
touch /var/log/auth.log

cd /root

#################################
#### Install Midnight Commander
#################################

cd /usr/share/keyrings
wget https://raw.githubusercontent.com/fdmgit/install-debian-12/main/tataranovich-keyring.gpg
echo "# Repository for Midnight Commander" > /etc/apt/sources.list.d/mc.list
echo "deb [signed-by=/usr/share/keyrings/tataranovich-keyring.gpg] http://www.tataranovich.com/debian bookworm main" >> /etc/apt/sources.list.d/mc.list

apt update
apt install mc -y


##############################
#### Update programs
##############################
apt update
apt upgrade -y


##############################
#### Update locate DB
##############################

updatedb

apt autoremove -y # clean installed apps

cd /root
rm instp1.sh
rm instp2.sh
rm load_inst_files.sh
rm -R .spamassassin

##############################
#### Install new Linux Kernel
##############################

apt install linux-image-6.5.0-0.deb12.4-amd64 -y

reboot
