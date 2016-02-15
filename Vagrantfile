# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  pref = YAML.load_file("config.yaml")
  if !pref.has_key?('32bit') or !pref.has_key?('memory')
    abort("Your config.yaml must specify a '32bit' and 'memory' setting.")
  end

  # Check Hubot Slack Token here
  if !pref.has_key?('hubot_slack_token')
    abort("Your config.yaml must specify a 'hubot_slack_token' setting.")
  else
    HUBOT_SLACK_TOKEN = pref['hubot_slack_token']
    unless HUBOT_SLACK_TOKEN.start_with?('xoxb-')
      puts "Error! 'hubot_slack_token' is required."
      puts "Please specify it in config.yaml."
      exit
    end
  end

  if pref['32bit']
    config.vm.box = "ubuntu/trusty32"
  else
    config.vm.box = "ubuntu/trusty64"
  end

  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "forwarded_port", guest: 9100, host: 9100
  config.vm.network "forwarded_port", guest: 9101, host: 9101

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  config.vm.hostname = "chatops"
  config.hostmanager.aliases = "chatops"

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", pref["memory"]]
    vb.name = "chatops"
  end

  if pref['use_sources_list']
    config.vm.provision "shell", path: "provision/apt_mirror.sh"
  end

  if pref['pip_mirror']
    config.vm.provision "shell", path: "provision/pip_conf.sh", args: pref['pip_mirror']
  end

  st2_configs = [pref['st2_version'].nil? ? "stable": pref['st2_version']]

  hubot_configs = [pref['npmmirror'].nil? ? "https://registry.npmjs.org/": pref['npmmirror'],
                   pref['owner'].nil? ? "Bot Wrangler": pref['owner'],
                   pref['name'].nil? ? "Hubot": pref['name'],
                   pref['description'].nil? ? "Delightfully aware robutt": pref['description']]

  chatops_configs = [hubot_configs[1], HUBOT_SLACK_TOKEN]

  config.vm.provision "shell", path: "provision/stackstorm.sh", args: st2_configs, privileged: false
  config.vm.provision "shell", path: "provision/hubot.sh", args: hubot_configs, privileged: false
  config.vm.provision "shell", path: "provision/chatops.sh", args: chatops_configs, privileged: false
end
