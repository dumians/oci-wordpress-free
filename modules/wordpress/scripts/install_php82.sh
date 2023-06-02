#!/bin/bash
#set -x

yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(cat /etc/redhat-release  | sed 's/^[^0-9]*\([0-9]\+\).*$/\1/').noarch.rpm
rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
yum -y install https://rpms.remirepo.net/enterprise/remi-release-$(cat /etc/redhat-release  | sed 's/^[^0-9]*\([0-9]\+\).*$/\1/').rpm
# Install MySQL Community Edition 8.0
rpm -ivh https://dev.mysql.com/get/mysql80-community-release-$(uname -r | sed 's/^.*\(el[0-9]\+\).*$/\1/')-1.noarch.rpm
yum install -y mysql-shell-${mysql_version}
yum install -y mysql-community-server-${mysql_version}

mysqld  --initialize-insecure --user=mysql --datadir=/var/lib/mysql

mkdir ~${user}/.mysqlsh
cp /usr/share/mysqlsh/prompt/prompt_256pl+aw.json ~${user}/.mysqlsh/prompt.json
echo '{
    "history.autoSave": "true",
    "history.maxSize": "5000"
}' > ~${user}/.mysqlsh/options.json
chown -R ${user} ~${user}/.mysqlsh

echo "MySQL Shell successfully installed !"

dnf -y module enable php:remi-8.2
dnf -y install httpd php php-cli php-mysqlnd php-zip php-gd php-mcrypt php-mbstring php-xml php-json

echo "MySQL Shell & PHP successfully installed !"

yum -y install certbot mod_ssl

echo "Certbot has been installed !"

systemctl enable mysqld
systemctl start mysqld
