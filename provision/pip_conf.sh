#!/usr/bin/env bash

source /vagrant/provision/utils.sh

print_status "change the default pip source to mirror $1..."

mkdir -p /home/vagrant/.pip
echo "[global]" > /home/vagrant/.pip/pip.conf
echo "index-url = $1" >> /home/vagrant/.pip/pip.conf
