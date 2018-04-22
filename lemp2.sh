## Abrindo a porta 80

echo -e "\e[92mBeginning Script in date time : $(date)\e[0m"

sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
sudo firewall-cmd --reload 

# instalando PHP
# yum install epel-release -y
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
rpm -Uvh http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm

# instalando MariaDB
cat >/etc/yum.repos.d/MariaDB.repo <<EOF
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.1/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF

# instalando NGINX
yum update -y
yum install -y nginx git lynx php71w-fpm.x86_64 php71w-mysql.x86_64 php71w-gd.x86_64 MariaDB-server MariaDB-client
sudo systemctl enable nginx
sudo systemctl enable php-fpm
sudo systemctl enable mariadb 

service mariadb start
service php-fpm start
service nginx start

echo -e "\e[92mEnding Script in date time : $(date)\e[0m"
