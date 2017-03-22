#!/bin/bash

#set -eux
set -x

# prompt
echo 'export PS1="[cli] \W # "' > /root/.bashrc

readonly NAT_PRIVATE_IP="$(host -t A nat | awk '{print $4}')"

# configure NAT box as the default gateway
ip route del default
ip route add default via ${NAT_PRIVATE_IP}

# run shell
/bin/bash
