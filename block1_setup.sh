#! /bin/sh

cp /vagrant/hosts /etc/hosts

apt-get update -y
apt-get upgrade -y

apt-get install -y python3 python3-simplejson
snap install glances
apt-get install -y lvm2 thin-provisioning-tools

pvcreate /dev/sdc
vgcreate cinder-volumes /dev/sdc

echo "configfs" >>/etc/modules
update-initramfs -u
systemctl daemon-reload

reboot
