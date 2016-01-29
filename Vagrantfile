# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  pref = YAML.load_file("config.yaml")
  if !pref.has_key?('32bit') or !pref.has_key?('memory')
    abort("Your config.yaml must specify a '32bit' and 'memory' setting.")
  end

  if pref['32bit']
    config.vm.box = "ubuntu/trusty32"
  else
    config.vm.box = "ubuntu/trusty64"
  end

  config.vm.box = "ubuntu/trusty64"

  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "base"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

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

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", pref["memory"]]
    vb.name = chatops
  end

  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  hubot_configs = [pref['npmmirror'].nil? ? "https://registry.npmjs.org/": pref['npmmirror'],
                   pref['owner'].nil? ? "Bot Wrangler": pref['owner'],
                   pref['name'].nil? ? "Hubot": pref['name'],
                   pref['description'].nil? ? "Delightfully aware robutt": pref['description'],
                   pref['adapter'].nil? ? "shell": pref['adapter']]

  config.vm.provision "shell", path: "provisioning/chatops.sh", args: hubot_configs, privileged: false
end
