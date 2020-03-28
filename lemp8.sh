#!/bin/sh
# necessario pra atualizar o PHP mais recente sem ser o 7.2 do appstream
echo -e "\e[32;3mBeginning Script in date time : $(date)\e[0m"
echo -e "\e[31;3mNGINX\e[0m"

# NGINX SESSION
cat >/etc/yum.repos.d/nginx.repo <<EOF
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/\$releasever/\$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true

[nginx-mainline]
name=nginx mainline repo
baseurl=http://nginx.org/packages/mainline/centos/\$releasever/\$basearch/
gpgcheck=1
enabled=0
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
EOF

dnf install nginx -y 

systemctl start nginx
systemctl enable nginx
systemctl status nginx

firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https
systemctl reload firewalld
chown nginx:nginx /usr/share/nginx/html -R


# MARIADB
echo -e "\e[31;3mMARIADB\e[0m"
wget https://downloads.mariadb.com/MariaDB/mariadb_repo_setup
chmod +x mariadb_repo_setup
./mariadb_repo_setup
dnf install perl-DBI libaio libsepol lsof boost-program-options -y
dnf install --repo="mariadb-main" MariaDB-server -y
dnf install MariaDB-server --disablerepo=AppStream --enablerepo=mariadb

systemctl start mariadb
systemctl enable mariadb
systemctl status mariadb
#mysql_secure_installation

# PHP
echo -e "\e[31;3mPHP\e[0m"



sudo dnf install dnf-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm
#dnf module list php
dnf module reset php
dnf module enable php:remi-7.4

sudo dnf install php php-opcache php-gd php-curl php-mysqlnd php-gd php-xml php-mbstring -y
systemctl start php-fpm
systemctl enable php-fpm
systemctl status php-fpm


cat >/etc/nginx/conf.d/neueserver.conf <<'EOF'
	server {
		listen			80 default_server;
		#listen			[::]:80 default_server;
		server_name		espiral.xyz;
		root 			/usr/share/nginx/html/cats1;

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

	server {
		listen			80 default_server;
		#listen			80[::]:80 default_server;
		server_name		_;
		root			/usr/share/nginx/html;

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

echo -e "\e[33;3mEnding Script in date time : $(date)\e[0m"
