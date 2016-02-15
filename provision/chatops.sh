#!/usr/bin/env bash

name=$1
description=$2
HUBOT_SLACK_TOKEN=$3

DEFAULT_INSTALLATION_DIR="/opt/hubot"
source /vagrant/provision/utils.sh

# Install Slack and StackStorm plugins
exec_cmd "sudo -H -u stanley bash -c \"cd $DEFAULT_INSTALLATION_DIR && npm install hubot-slack hubot-stackstorm --save\""

# Add "hubot-stackstorm" entry into /opt/hubot/external-scripts.json file (only if it doesn't exist)
exec_cmd "grep -q 'hubot-stackstorm' $DEFAULT_INSTALLATION_DIR/external-scripts.json || sudo -H -u stanley sed -i 's/.*\[.*/&\n  \"hubot-stackstorm\",/' $DEFAULT_INSTALLATION_DIR/external-scripts.json"

# Create upstart script
sudo cp -f /vagrant/provision/hubot.conf /etc/init/hubot.conf
sudo chmod -x /etc/init/hubot.conf

# Substitute variables in /etc/init/hubot.conf
sudo sed -i "s/\${description}/$description/" /etc/init/hubot.conf
sudo sed -i "s|\${default_installation_dir}|$DEFAULT_INSTALLATION_DIR|" /etc/init/hubot.conf
sudo sed -i "s/\${name}/$name/" /etc/init/hubot.conf
sudo sed -i "s/HUBOT_SLACK_TOKEN.*/HUBOT_SLACK_TOKEN=${HUBOT_SLACK_TOKEN}/" /etc/init/hubot.conf

# Start hubot
print_status "Start hubot"
sudo rm -rf /var/log/upstart/hubot.log
ps aux | grep -v grep | grep hubot > /dev/null && sudo restart hubot || sudo start hubot

# Wait 30 seconds for Hubot to start
print_status "Wait 30 seconds for Hubot to start..."
for i in {1..30}; do
    #ACTIONEXIT=`nc -z 127.0.0.1 8181; echo $?`
    ACTIONEXIT=`sudo grep -q 'Slack client now connected' /var/log/upstart/hubot.log 2> /dev/null; echo $?`
    if [ ${ACTIONEXIT} -eq 0 ]; then
        break
    fi
    sleep 1
done

# Verify if hubot is up and running
print_status "Verify if hubot is up and running"
if [ ${ACTIONEXIT} -eq 0 ]; then
    st2 run hubot.post_message channel=general message='Ready for ChatOps!``` Brought to you by: http://stackstorm.com/ For available commands type: ```!help' > /dev/null
    echo " "
    echo "#############################################################################################"
    echo "###################################### All Done! ############################################"
    echo " "
    echo "Your bot should be online in Slack now. Your first ChatOps command:"
    echo "!help"
    echo " "
    echo " "
    echo "Visit:"
    echo "http://localhost:8080/ - for StackStorm control panel"
    echo " "
    exit 0
else
    echo " "
    echo "#############################################################################################"
    echo "####################################### ERROR! ##############################################"
    echo " "
    echo "Something went wrong, hubot failed to start"
    echo "Check /var/log/upstart/hubot.log for more info"
    echo " "
    exit 2
fi
