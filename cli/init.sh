#!/bin/bash

set -eux

# prompt
echo 'export PS1="[cli] \W # "' > /root/.bashrc

readonly NAT_PRIVATE_IP="172.19.0.3"

# configure NAT box as the default gateway
ip route del default
ip route add default via ${NAT_PRIVATE_IP}

# run shell
/bin/bash
