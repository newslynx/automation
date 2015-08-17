EC2 Linux Install Guide
=======================

If you want to provision from an Amazon EC2 instance instead of using your local machine, here are the instructions to install Vagrant and Ansible.

Before doing any of the following, update your packages listing:

````shell
sudo apt-get update
````

## Downloading the Automation repo

````shell
# Install git
sudo apt-get install git

# Clone this repository
git clone https://github.com/newslynx/automation 
````

## Installing Vagrant

These instructions come in part from [Digital Ocean's guide](https://www.digitalocean.com/community/tutorials/how-to-install-vagrant-on-a-vps-running-ubuntu-12-04).

**Note:** The Digital Ocean Guide also covers installing VirtualBox but we haven't fully tested that method. Use the instructions below for provisioning to another AWS instance, which is the better strategy in any event.

````shell
# Install dpkg, which will help us install Vagrant
sudo apt-get install dpkg-dev
````

At the time of this writing (Aug 2015), the latest Vagrant version is 1.7.4. To check the latest, go to the [Vagrant downloads page](https://www.vagrantup.com/downloads.html). If an updated version exists, right-click on the "64-bit" link for "Linux (DEB)" and copy the download URL. Replace it with the one below in the next command.

````shell
# Download the Vagrant installer
wget https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.4_x86_64.deb

# Install it
# NOTE: If you're using an updated version, replace the name of the .deb file with the one you just downloaded
# An easy way to do this is to type `dpkg -i v` and then hit the `tab` key to autocomplete.
dpkg -i vagrant_1.7.4_x86_64.deb

# Install Kernel headers
sudo apt-get install linux-headers-$(uname -r)
````

And you're done!

## Installing Ansible

Ansible has their own instructions for installing via `apt-get` on Ubuntu that are [available here](http://docs.ansible.com/ansible/intro_installation.html#latest-releases-via-apt-ubuntu). At the time of this writing (Aug 2015), they are the following: 

````shell
sudo apt-get install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible
````

Hurray!

## Setting permissions

As a part of this process, you need to put your Amazon `.pem` file onto the AWS machine you're deploying from. This is the file whose path you set in [`servers.yaml`](https://github.com/newslynx/automation/blob/master/secrets.yaml.sample#L4). Importantly, only the super user can have read permissions to this file. To do this, run the following command on that file

````
chmod +r 400
````
