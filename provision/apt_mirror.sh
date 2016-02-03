#!/usr/bin/env bash

source /vagrant/provision/utils.sh

if [ -z /vagrant/provision/sources.list ]; then
  exec_cmd "cp -f /etc/apt/sources.list /etc/apt/sources.list.bak"
  exec_cmd "cp -f /vagrant/provision/sources.list /etc/apt/sources.list"
else
  print_status "file provision/sources.list does not exist." && bail
fi
