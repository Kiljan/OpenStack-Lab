#! /bin/sh

cp /vagrant/hosts /etc/hosts

apt-get update -y
apt-get upgrade -y

apt-get install -y python3-jinja2 libssl-dev curl vim python3-pip

mkdir -p /home/vagrant/kolla
cp /vagrant/run-kolla.sh /home/vagrant/kolla

reboot
