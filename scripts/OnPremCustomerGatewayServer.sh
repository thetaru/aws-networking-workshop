#!/bin/bash

# install OpenSWAN
yum install -y openswan
systemctl enable ipsec.service

# Enable IP forwarding
cat >> /etc/sysctl.conf<< EOF
net.ipv4.ip_forward = 1
net.ipv4.conf.default.rp_filter = 0
net.ipv4.conf.default.accept_source_route = 0
EOF

sysctl -p
