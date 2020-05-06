# Clearing any previous configuration
echo "Clearing any existing rules and setting default policy to ACCEPT."
iptables -t filter -F
iptables -t filter -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -t raw -F
iptables -t raw -X
iptables -t security -F
iptables -t security -X
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

echo "Default policy DROP any package except for localhost and docker0"
# Default policy DROP any package except forwaring (needed for Docker)
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD ACCEPT  ## Allow forwarding for Docker

# Allow any connections in localhost
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A FORWARD -o lo -j ACCEPT

## DOCKER ##
# Allow any connections in docker0
iptables -A INPUT -i docker0 -j ACCEPT
iptables -A OUTPUT -o docker0 -j ACCEPT
iptables -A FORWARD -o docker0 -j ACCEPT

# For docker-compose the iptables rules are set up differently by docker. Due
# to this, specific ip ranges need to be allowed by each network. In order to
# expose a service, in the  docker-compose YML file one of the below networks
# or a new one needs to be specified. If a new docker network gets created the
# iptables rules will have to be updated as well.
# See:
# https://runnable.com/docker/basic-docker-networking
# https://runnable.com/docker/docker-compose-networking

# Custom docker network bridge rules
# Enable redmine (docker network inspect redmine | grep Subnet)
iptables -A INPUT -s 172.21.0.0/16 -j ACCEPT
iptables -A OUTPUT -d 172.21.0.0/16 -j ACCEPT

# Enable deluge (docker network inspect deluge | grep Subnet)
iptables -A INPUT -s 172.22.0.0/16 -j ACCEPT
iptables -A OUTPUT -d 172.22.0.0/16 -j ACCEPT


echo "Setting up rules."
# Allow ICMP (outbound) connection
iptables -A INPUT -m state --state ESTABLISHED,RELATED -p icmp -j ACCEPT
iptables -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -p icmp -j ACCEPT
# Allow traceroute (outbound) connection
iptables -A INPUT -m state --state ESTABLISHED,RELATED -p udp --sport 33434:33524 -j ACCEPT
iptables -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -p udp --dport 33434:33524 -j ACCEPT
# Allow SSH TCP (inbound) connections [only used at work]
iptables -A INPUT -m state --state NEW,ESTABLISHED,RELATED -p tcp --dport 22 -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -p tcp --sport 22 -j ACCEPT
# Allow SSH TCP (outbound) connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -p tcp --sport 22 -j ACCEPT
iptables -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -p tcp --dport 22 -j ACCEPT
# Allow DNS TCP (outbound) connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -p tcp --sport 53 -j ACCEPT
iptables -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -p tcp --dport 53 -j ACCEPT
# Allow DNS UDP (outbound) connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -p udp --sport 53 -j ACCEPT
iptables -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -p udp --dport 53 -j ACCEPT
# Allow DHCP UDP (outbound) connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -p udp --sport 67:68 -j ACCEPT
iptables -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -p udp --dport 67:68 -j ACCEPT
# Allow HTTP TCP (outbound) connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -p tcp --sport 80 -j ACCEPT
iptables -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -p tcp --dport 80 -j ACCEPT
# Allow NTP UDP (outbound) connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -p udp --sport 123 -j ACCEPT
iptables -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -p udp --dport 123 -j ACCEPT
# Allow HTTPS TCP (outbound) connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -p tcp --sport 443 -j ACCEPT
iptables -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -p tcp --dport 443 -j ACCEPT
# Allow VPN UDP (outbound) connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -p udp --sport 500 -j ACCEPT
iptables -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -p udp --dport 500 -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -p udp --sport 4500 -j ACCEPT
iptables -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -p udp --dport 4500 -j ACCEPT
# Allow PROXY 8080 TCP (outbound) connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -p tcp --sport 8080 -j ACCEPT
iptables -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -p tcp --dport 8080 -j ACCEPT
# Allow GIT TCP (outbound) connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -p tcp --sport 9418 -j ACCEPT
iptables -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -p tcp --dport 9418  -j ACCEPT
# Allow GIT remote on 29418 (outbound) connections [only used at work]
iptables -A INPUT -m state --state ESTABLISHED,RELATED -p tcp --sport 29418 -j ACCEPT
iptables -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -p tcp --dport 29418  -j ACCEPT
# Allow DROPBOX UDP (outbound) connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -p udp --sport 17500 -j ACCEPT
iptables -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -p udp --dport 17500 -j ACCEPT
# Allow DROPBOX UDP (inbound) connections
iptables -A INPUT -m state --state NEW,ESTABLISHED,RELATED -p udp --dport 17500 -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -p udp --sport 17500 -j ACCEPT

echo "Setting up drop rules to avoid fludding the logs"
# Drop uPnP (inbound). It's mainly used to discover devices (i.e. Chromecast)
iptables -A INPUT -m state --state NEW,ESTABLISHED,RELATED -p udp --dport 1900 -j DROP

#LOGGING
# See https://linux.die.net/man/8/iptables
# and https://serverfault.com/a/213285
# --limit         The number of packets to let through per unit of time,
#                 default is 3/hour. For instance 2/m will allow just 2
#                 packages per minute.
#
#Level    name               Description
#  0      emerg or panic     Something is incredibly wrong; the system is probably about to crash
#  1      alert              Immediate attention is required
#  2      crit               Critical hardware or software failure
#  3      error              Usually used for reporting of hardware problems by drivers
#  4      warning            Something isn't right, but the problem is not serious
#  5      notice             No problems; indicates an advisory of some sort.
#  6      info               General information
#  7      debug              Deguging
#
# --log-uid       Log the userid of the process which generated the packet.
#
echo "Enabling logging (/var/log/messages)."
iptables -N LOGGING
iptables -A INPUT -j LOGGING
iptables -A OUTPUT -j LOGGING
iptables -A LOGGING -m limit --limit 2/min -j LOG \
    --log-level 6 \
    --log-prefix "iptables logging: " \
    --log-tcp-options \
    --log-ip-options \
    --log-uid
iptables -A LOGGING -j DROP

# Understanding iptables logging:
# Example 1:
# ==========
# Jan 18 15:27:22 hodei-hp kernel: [ 5316.768782] iptables logging: IN=wlp1s0 OUT=
# MAC=f8:34:41:67:ef:26:8c:59:73:84:5d:ec:08:00 SRC=192.168.1.1 DST=192.168.1.6
# LEN=28 TOS=0x00 PREC=0x00 TTL=255 ID=36156 PROTO=ICMP TYPE=8 CODE=0 ID=0 SEQ=0
#
# Explanation: A package has been received (IN) at interface wlp1s0 and it was
#              sent by 192.168.1.1 (router) to 192.168.1.6 (my laptop)
#
# Example 2:
# ==========
# Jan 18 15:37:42 hodei-hp kernel: [ 5936.724263] iptables logging: IN= OUT=wlp1s0
# SRC=192.168.1.6 DST=162.125.64.3 LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=6044 DF
# PROTO=TCP SPT=59218 DPT=443 WINDOW=491 RES=0x00 ACK RST URGP=0
#
# Explanation: A package has been sent (OUT) using interface wlp1s0 and it was
#              sent by 192.168.1.6 (my laptop) to 162.125.64.3 (apparently to
#              Dropbox)
