#!/bin/bash

usage() {
  cat << EOF
  $0 <initialisation timeout> <established timeout>

  (Timeout values must be given in seconds)
EOF
  exit 1
}

# Set NAT timeouts for UDP associations.
# Values are in seconds.
# $1: timeout for initialising the association
# $2: timeout for an established association
set_udp_timeouts() {
  local timeout_initialisation=$1
  local timeout_established=$2

  sysctl -w net.netfilter.nf_conntrack_udp_timeout=${timeout_initialisation}
  sysctl -w net.netfilter.nf_conntrack_udp_timeout_stream=${timeout_established}
}

[ $# != 2 ] && usage

set -exu

declare -ri TIMEOUT_INITIALISATION=$1
declare -ri TIMEOUT_ESTABLISHED=$2

set_udp_timeouts ${TIMEOUT_INITIALISATION} ${TIMEOUT_ESTABLISHED}

# vim: ai ts=2 sw=2 et sts=2 ft=sh
