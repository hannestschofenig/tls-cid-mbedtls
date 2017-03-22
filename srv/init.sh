#!/bin/bash

set -eux

# prompt
echo 'export PS1="[srv] \W # "' > /root/.bashrc

# run shell
/bin/bash
