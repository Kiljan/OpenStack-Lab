#! /bin/sh

cp /vagrant/hosts /etc/hosts

apt-get update -y
apt-get upgrade -y

apt-get install -y python3 python3-simplejson
snap install glances

reboot
