#!/usr/bin/env bash

source /vagrant/provision/utils.sh

exec_cmd "sudo apt-get update"
exec_cmd "sudo apt-get install -y curl"

## install StackStorm
print_status "installing StackStorm..."
exec_cmd "curl -s https://downloads.stackstorm.net/releases/st2/scripts/st2_deploy.sh $1 | sudo bash"

# Set `enable = False` under `[auth]` section in file: `/etc/st2/st2/conf`
sudo sed -i '/^\[auth\]$/,/^\[/ s/^enable = True/enable = False/' /etc/st2/st2.conf

exec_cmd "sudo st2ctl restart && sleep 10"
exec_cmd "st2ctl status"

## install StackStorm Ansible And Hubot Packs
print_status "installing StackStorm Ansible And Hubot Packs"
exec_cmd "st2 run packs.install packs=hubot,ansible register=all"
