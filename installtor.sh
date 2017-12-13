#!/bin/bash
yum install epel-release
echo "y" | yum install tor -y
echo "y" | yum install  privoxy -y
echo "/etc/tor/torrc ControlPort 9051 /etc/privoxy/config listen-address  0.0.0.0:31111 forward-socks5 / 127.0.0.1:9050"
