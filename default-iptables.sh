#!/bin/bash
# apt install iptables-persistent (Don't use the UFW)
# set default urles for ssh/http/https

# Set the default policies to allow everything while we set up new rules
# Prevents cutting yourself off when running from remote SSH
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# Flush any existing rules, leaving just the defaults
iptables -F

# Open port 22 for incoming SSH connections
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Open port 80 for incoming HTTP requests
iptables -A INPUT -p tcp --dport 80 -j ACCEPT

# Open port 443 for incoming HTTPS requests
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# iptables -A INPUT -p tcp --dport 333 -s 1.2.3.4 -j ACCEPT

# accept any localhost (loopback) calls
iptables -A INPUT -i lo -j ACCEPT

# allow any existing connection to remain
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# reset the default policies to stop all incoming and forward requests
iptables -P INPUT DROP
iptables -P FORWARD DROP

# accept any outbound requests from this server
iptables -P OUTPUT ACCEPT

# save the settings
iptables-save > /etc/iptables/rules.v4
ip6tables-save > /etc/iptables/rules.v6
# systemctl restart netfilter-persistent

# display the settings
iptables -L -v --line-numbers
