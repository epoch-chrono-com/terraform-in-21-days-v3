#!/usr/bin/env bash

yum update -y
yum install -y httpd git
git clone https://github.com/gabrielecirulli/2048.git
cp -rp 2048/* /var/www/html
systemctl enable --now httpd
