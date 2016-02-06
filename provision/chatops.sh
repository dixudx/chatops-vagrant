#!/usr/bin/env bash

owner=$1
HUBOT_SLACK_TOKEN=$2

DEFAULT_INSTALLATION_DIR="/opt/hubot"
source /vagrant/provision/utils.sh

sudo -H -u stanley bash -c 'cd $DEFAULT_INSTALLATION_DIR && npm install hubot-slack hubot-stackstorm --save'
sudo -H -u stanley sed -i 's/.*\[.*/&\n  "hubot-stackstorm",/' $DEFAULT_INSTALLATION_DIR/external-scripts.json

cd /opt/hubot && HUBOT_SLACK_TOKEN=$HUBOT_SLACK_TOKEN ST2_WEBUI_URL=http://chatops:8080 PORT=8181 bin/hubot --name "$owner" --adapter slack --alias !
