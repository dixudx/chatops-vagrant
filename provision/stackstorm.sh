#!/usr/bin/env bash

source /vagrant/provision/utils.sh

exec_cmd "sudo apt-get update"
exec_cmd "sudo apt-get install -y curl"

## install StackStorm
print_status "installing StackStorm..."
curl -s https://downloads.stackstorm.net/releases/st2/scripts/st2_deploy.sh $st2_ver | sudo bash
# Set `enable = False` under `[auth]` section in file: `/etc/st2/st2/conf`
sudo sed -i '/^\[auth\]$/,/^\[/ s/^enable = True/enable = False/' /etc/st2/st2.conf
exec_cmd "sudo st2ctl restart"

## install StackStorm Ansible And Hubot Packs
print_status "installing StackStorm Ansible And Hubot Packs"
exec_cmd "st2 run packs.install packs=hubot,ansible register=all"
