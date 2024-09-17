#! /bin/bash 

echo "Updating and installing dependencies..."
sudo dnf update -y
sudo dnf install php8.1 php8.1-cli php8.1-mysqlnd php8.1-mbstring php8.1-xml php8.1-gd  php8.1-intl -y

#https://www.sparrowlinux.in/2022/07/install-glpi-on-amazon-linux-2-install.html
echo "Installing and configiring nginx..."
sudo yum install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx

#https://linux.how2shout.com/installing-mariadb-on-amazon-linux-2023/
echo "Installing and configiring mariadb..."
sudo dnf install mariadb105-server -y
sudo systemctl enable mariadb
sudo systemctl start mariadb
#sudo systemctl status mariadb

root_pass=admin@123
#sudo mysql_secure_installation
# Make sure that NOBODY can access the server without a password
sudo mysql -e "UPDATE mysql.user SET Password = PASSWORD('$root_password') WHERE User = 'root'"
# Kill the anonymous users
sudo mysql -e "DROP USER IF EXISTS ''@'localhost'"
# Because our hostname varies we'll use some Bash magic here.
sudo mysql -e "DROP USER IF EXISTS ''@'$(hostname)'"
# Kill off the demo database
sudo mysql -e "DROP DATABASE IF EXISTS test"

echo "Creation glpi database"

#mysql -u root -p
#https://ipv6.rs/tutorial/Alpine_Linux_Latest/GLPI/
sudo mysql -e "CREATE DATABASE IF NOT EXISTS staging"
sudo mysql -e "GRANT ALL all privileges on glpi.* to 'glpi'@'localhost' identified by 'passwd';"
#exit;

#https://medium.com/@elaurichetoho/how-to-install-glpi-on-linux-server-with-nginx-252074687e4
echo "Installing and configuring GLPI..."
wget https://github.com/glpi-project/glpi/releases/download/10.0.1/glpi-10.0.1.tgz
tar xvf glpi-10.0.1.tgz
sudo mv glpi /usr/share/nginx/html/

echo "Giving the prper permission to folders..."
sudo chown -R nginx:nginx /usr/share/nginx/html/glpi
sudo chmod -R 755 /usr/share/nginx/html/glpi

sudo chmod 777 -R  /usr/share/nginx/html/glpi/files/_log
sudo chmod 777 /usr/share/nginx/html/glpi/files/_cache
sudo chmod 777 /usr/share/nginx/html/glpi/files/_cache/remove.txt 
sudo chmod 777 /usr/share/nginx/html/glpi/config
sudo chmod 777 /usr/share/nginx/html/glpi/files/_cron
sudo chmod 777 /usr/share/nginx/html/glpi/files/_cron
sudo chmod 777 /usr/share/nginx/html/glpi/files
sudo chmod 777 /usr/share/nginx/html/glpi/files/_dumps
sudo chmod 777 /usr/share/nginx/html/glpi/files/_graphs
sudo chmod 777 /usr/share/nginx/html/glpi/files/_lock
sudo chmod 777  /usr/share/nginx/html/glpi/files/_pictures 
sudo chmod 777 /usr/share/nginx/html/glpi/files/_plugins 
sudo chmod 777 /usr/share/nginx/html/glpi/files/_rss 
sudo chmod 777  /usr/share/nginx/html/glpi/files/_sessions
sudo chmod 777  /usr/share/nginx/html/glpi/files/_tmp
sudo chmod 777 /usr/share/nginx/html/glpi/files/_uploads
sudo chmod 777 -R /usr/share/nginx/html/glpi/marketplace


#https://www.sparrowlinux.in/2022/07/install-glpi-on-amazon-linux-2-install.html

echo "Setup the fastcgi parameter"
#sudo vim /etc/nginx/fastcgi_params
#Change this line to     $server_name; to  $host;
#fastcgi_param  SERVER_NAME        $server_name;
#fastcgi_param  SERVER_NAME        $host;
sudo sed -i 's/$server_name/$host' /etc/nginx/fastcgi_params


# Default logins / passwords are:

# glpi/glpi for the administrator account
# tech/tech for the technician account
# normal/normal for the normal account
# post-only/postonly for the postonly account
# You can delete or modify these accounts as well as the initial data.

# root 
# admin
# passwd