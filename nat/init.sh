#!/bin/bash

set -eux

# prompt
echo 'export PS1="[nat] \W # "' > /root/.bashrc

# NAT configuration
readonly PRIVATE_INTERFACE="eth0"
readonly PUBLIC_INTERFACE="eth1"

iptables \
	--table nat \
	--append POSTROUTING \
	--out-interface ${PUBLIC_INTERFACE} \
	--jump MASQUERADE

iptables \
	--append FORWARD \
	--in-interface ${PUBLIC_INTERFACE} \
	--out-interface ${PRIVATE_INTERFACE} \
	--match state \
	--state RELATED,ESTABLISHED \
	--jump ACCEPT

iptables \
	--append FORWARD \
	--in-interface ${PRIVATE_INTERFACE} \
	--out-interface ${PUBLIC_INTERFACE} \
	--jump ACCEPT

# run shell
/bin/bash
