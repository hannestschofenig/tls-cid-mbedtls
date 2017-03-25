#!/bin/bash

set -eux

# prompt
echo 'export PS1="[nat] \W # "' > /root/.bashrc

# run shell
/bin/bash

# vim: ai ts=2 sw=2 et sts=2 ft=sh
