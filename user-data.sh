#!/usr/bin/env bash

yum update -y
yum install -y httpd
systemctl enable --now httpd
