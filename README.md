ChatOps Vagrant Machine
=======================

This is a ChatOps virtual machine, , which utilizes [Slack](https://slack.com) as an adapter connecting/interacting with [Hubot](https://hubot.github.com/) and [StackStorm](https://stackstorm.com/).

You can use it to play around with [ChatOps](https://stackstorm.com/2015/06/24/ansible-chatops-get-started-%F0%9F%9A%80/). It is not meant for any production usage.

Installation
------------

To get it working, you will need to first install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
and [Vagrant](https://www.vagrantup.com). Once you have these installed, clone
(or download) [this repository](https://github.com/dixudx/chatops-vagrant.git).

```bash
$ cd /to/your/directory
$ git clone https://github.com/dixudx/chatops-vagrant.git
$ cd chatops-vagrant
$ vagrant up
```

On the first run this might take some time and will download a large vm image.
After some time, you will get a running instance of **ChatOps** with [Hubot](https://hubot.github.com/) and [StackStorm](https://stackstorm.com/) installed.

Manage the Instance
-------------------

If you finished working, just enter `vagrant destroy` to throw away everything you
did (*Attention:* This will clear all actions you performed on the vm.) and you can start over again
the next time with `vagrant up` to bring up a fresh virtual machine.

If you just want to shutdown the virtual machine without destroying your
data use `vagrant suspend` and `vagrant resume` to start it again. In this
case all your data changes on the **ChatOps** will be persisted.

Configuration
-------------

There is a configuration file called `config.yaml` that you can edit with a text editor, to change
some settings.

### StackStorm Settings (Mandatory)

Register for a Slack account if you don’t have one yet. Enable Hubot integration in settings.

![](http://i.imgur.com/fJ6DpBZ.png)

Once you’re done, you’ll get one API Token.

| Hubot Option      | Description                                          |
|-------------------|------------------------------------------------------|
| hubot_slack_token | Hubot Integration API Token, e.g. "xoxb-12345-67890" |
| st2_version       | The version of StackStorm, e.g. "stable" or "latest" |

### General Settings (Optional)

You can choose to use your own **Ubuntu mirror** by setting `use_sources_list` to `true` in `config.yaml` and placing file `sources.list` in folder `provisioning`.

### Virtual Machine Customizations (Optional)

Set the `32bit` option to `true` if you run on a system, that only supports 32bit virtualization or
would like to test the 32 bit version for any other reason. You should normally not need this.

You can specify the amount of `memory` used by the virtual machine. It is set to `2048` (MB) by default,
since I think this is a good value that would work for the most users. If you however have very low memory
you can try to decrease this value or increase it, if you have enough memory left in your system.

### NPM Mirror Alternatives (Optional)

**IMPORTANT NOTICE:**

Remember to configure the right registry for [npm](https://www.npmjs.com/) with '**npmmirror**' in `config.yaml`,
which can speed up the installation of npm packages.

### Hubot Customizations (Optional)

Also you can customize the [Hubot](https://hubot.github.com/) with below parameters.

| Hubot Option  | Description                                       |
|---------------|---------------------------------------------------|
| owner         | Bot owner, e.g. "Bot Wrangler bw@example.com"     |
| name          | Bot name, e.g. "Hubot"                            |
| description   | Bot description, e.g. "Delightfully aware robutt" |
