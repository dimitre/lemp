## Abrindo a porta 80

#echo -e "\e[92mBeginning Script in date time : $(date)\e[0m"
#http://jafrog.com/2013/11/23/colors-in-terminal.html
echo -e "\e[33;3mBeginning Script in date time : $(date)\e[0m"

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
baseurl = http://yum.mariadb.org/10.2/centos$releasever-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF

cat >/etc/yum.repos.d/nginx.repo <<EOF
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/\$releasever/\$basearch/
gpgcheck=0
enabled=1
EOF

# instalando NGINX
yum update -y
yum install -y lynx git
#yum --disablerepo "*" --enablerepo=nginx -y install nginx
yum --enablerepo=nginx -y install nginx
yum --enablerepo=mariadb -y install MariaDB-server MariaDB-client
yum --enablerepo=remi-php72 -y install php-common php-fpm php-gd php-mysqlnd php-pdo php-pecl-jsonc php-pecl-zip php-xml php-fpm

cat >/etc/nginx/conf.d/dimitre.conf <<EOF
    server {
        listen       80 default_server;
        listen       [::]:80 default_server;
        server_name  _;
        root         /usr/share/nginx/html;

		index index.php index.html index.htm;
		location ~ .php$ {
        	try_files $uri =404;
        	fastcgi_pass 127.0.0.1:9000;
        	fastcgi_index index.php;
        	fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        	include fastcgi_params;
		}
        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        location / {
        }

        error_page 404 /404.html;
            location = /40x.html {
        }

        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
    }
EOF


#yum install -y php71w-fpm.x86_64 php71w-mysql.x86_64 php71w-gd.x86_64 MariaDB-server MariaDB-client
sudo systemctl enable nginx
sudo systemctl enable php-fpm
sudo systemctl enable mariadb 

service mariadb start
service php-fpm start
service nginx start

echo -e "\e[33;3mEnding Script in date time : $(date)\e[0m"
