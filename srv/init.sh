#!/bin/bash

set -eux

# prompt
echo 'export PS1="[srv] \W # "' > /root/.bashrc

readonly NAT_PUBLIC_IP="$(host -t A nat | awk '{print $4}')"

# configure NAT box as the default gateway
ip route del default
ip route add default via ${NAT_PUBLIC_IP}

# run shell
/bin/bash

# vim: ai ts=2 sw=2 et sts=2 ft=sh
