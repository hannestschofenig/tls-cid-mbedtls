#!/bin/bash

set -exu

# XXX(tho) Assumes a defined and fixed association between network interface
#          names and networks.  Should use "docker network inspect" to work
#          this info out.
readonly PUBLIC_INTERFACE="eth1"

# Server port used by dtls_client and dtls_server
readonly DTLS_PORT=4433

# Default (S)NAT source port
readonly DEFAULT_SRC_PORT=10101

get_nat_rule_no() {
  iptables \
    --verbose \
    --list POSTROUTING \
    --table nat \
    --line-numbers \
  | grep ${DTLS_PORT} \
  | awk '{print $1}'
}

# Instruct NAT to rewrite the source port of packets headed to a DTLS server
# $1: an unused UDP port
set_source_port_nat() {
  readonly local src_port=$1

  iptables \
    --table nat \
    --append POSTROUTING \
    --out-interface ${PUBLIC_INTERFACE} \
    --protocol udp \
    --destination-port ${DTLS_PORT} \
    --jump MASQUERADE \
    --to-ports ${src_port}
}

get_udp_max_timeout() {
  local t="$(sysctl net.netfilter.nf_conntrack_udp_timeout_stream \
    | cut -d'=' -f2 \
    | cut -c2-)"
  echo "$t seconds"
}

# if a NAT binding is on, turn it off -- and viceversa
# $1 the source port to use for (S)NAT
switch_nat() {
  local src_port=$1
  local rule_no=$(get_nat_rule_no)

  if [ -n "${rule_no}" ]; then
    iptables --table nat --delete POSTROUTING ${rule_no}
    echo "wait $(get_udp_max_timeout) for the NAT binding to expire"
  else
    set_source_port_nat ${src_port}
  fi
}

# $1: the source port to use for (S)NAT
main() {
  local src_port=$1
  switch_nat ${src_port}
}

declare -ri SRC_PORT="${1-$DEFAULT_SRC_PORT}"

main ${SRC_PORT}

# vim: ai ts=2 sw=2 et sts=2 ft=sh
