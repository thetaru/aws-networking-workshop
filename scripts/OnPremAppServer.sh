#!/bin/bash
# set up web server
dnf install -y httpd
echo "Hello, world." > /var/www/html/index.html
systemctl enable httpd.service
systemctl start httpd.service
