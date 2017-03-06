## Abrindo a porta 80
sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
sudo firewall-cmd --reload 

# instalando NGINX
yum update -y
yum install nginx git lynx -y
sudo systemctl enable nginx
service nginx start

# instalando PHP
yum install epel-release -y
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
rpm -Uvh http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
yum install php71w-fpm.x86_64 -y
sudo systemctl enable php-fpm
service php-fpm start

# instalando MariaDB
cat >/etc/yum.repos.d/MariaDB.repo <<EOF
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.1/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF

yum install MariaDB-server