#!/bin/bash
cd /home/dist
git pull
7z  x  -pHARrbhrtkbJsaCkrHUaE hls-storage-proxy.zip
npm install
pm2 restart all
#etc.