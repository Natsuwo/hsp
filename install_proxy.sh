#!/bin/bash
[[ ! "${1}" ]] && echo "Missing name" && exit 1

NGINX_CONFIG="server {
    listen 80;
    listen [::]:80;
    index index.html;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:9001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }}"
apt-get update  # To get the latest package lists
apt-get install -y curl nginx git unzip p7zip-full
curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash -
apt-get install -y nodejs
npm install pm2 -g
echo $NGINX_CONFIG > /etc/nginx/sites-available/your-domain.com
sudo rm /etc/nginx/sites-enabled/default
sudo ln -sf /etc/nginx/sites-available/your-domain.com /etc/nginx/sites-enabled/your-domain.com
sudo nginx -t
sudo systemctl restart nginx
sudo mkdir -p /home/dist
cd /home/dist
git clone https://github.com/Natsuwo/hsp.git .
7z  x  -pHARrbhrtkbJsaCkrHUaE hls-storage-proxy.zip
npm install
pm2 start --name ${1} npm -- start
#etc.