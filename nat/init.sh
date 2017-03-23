#!/bin/bash

nat_setup() {
  local timeout_init=30
  local timeout_established=180

#  sysctl -w net.netfilter.nf_conntrack_udp_timeout=${timeout_init}
#  sysctl -w net.netfilter.nf_conntrack_udp_timeout_stream=${timeout_established}

  # NAT configuration
  #
  # XXX(tho) Assumes a defined and fixed association between network interface
  # XXX(tho) names and networks.  Should use "docker network inspect" to work
  # XXX(tho) this info out.
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
}

set -eux

# prompt
echo 'export PS1="[nat] \W # "' > /root/.bashrc

ip route del default
nat_setup

# run shell
/bin/bash

# vim: ai ts=2 sw=2 et sts=2 ft=sh
