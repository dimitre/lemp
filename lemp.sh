yum update -y
yum install nginx git lynx -y
sudo systemctl enable nginx

yum install epel-release -y
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
rpm -Uvh http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm

yum install php71w-fpm.x86_64 -y
sudo systemctl enable php-fpm
