#! /bin/sh

mount -a

cp /vagrant/.vagrant/machines/controller/virtualbox/private_key .ssh/controller.pem
cp /vagrant/.vagrant/machines/compute1/virtualbox/private_key .ssh/compute1.pem
cp /vagrant/.vagrant/machines/block1/virtualbox/private_key .ssh/block1.pem
chmod 600 .ssh/controller.pem
chmod 600 .ssh/compute1.pem
chmod 600 .ssh/block1.pem

ssh -i .ssh/controller.pem vagrant@controller echo "OK"
ssh -i .ssh/compute1.pem vagrant@compute1 echo "OK"
ssh -i .ssh/block1.pem vagrant@block1 echo "OK"

pip install ansible==2.9.27

pip install kolla-ansible==11.0.0

# defoult for modify
#/usr/local/share/kolla-ansible/etc_examples/kolla/globals.yml    => set up parts
#/usr/local/share/kolla-ansible/etc_examples/kolla/passwords.yml  => pass info
#/usr/local/share/kolla-ansible/ansible/inventory/multinode       => inventory
#/usr/local/share/kolla-ansible/init-runonce                      => set up additional network and secrets

#nvim /usr/local/share/kolla-ansible/ansible/roles/common/tasks/config.yml and change fluentd_binary to
#fluentd_binary: "{% if fluentd_labels.images.0.ContainerConfig.Labels.fluentd_binary is not defined %}{% if kolla_base_distro in 'ubuntu' and ansible_architecture == 'x86_64' %}td-agent{% else %}fluentd{% endif %}{% else %}{{ fluentd_labels.images.0.ContainerConfig.Labels.fluentd_binary }}{% endif %}"

#CorrectBEFORE_DEPLOY
#vim /usr/local/share/kolla-ansible/ansible/roles/common/templates/conf/filter/01-rewrite-0.12.conf.j2 and change ewerything to the rule
# example
#<rule>
#    key     programname
#    pattern ^(cinder-api-access|cloudkitty-api-access|gnocchi-api-access|horizon-access|keystone-apache-admin-access|keystone-apache-public-access|monasca-api-access|placement-api-access|panko-api-access)$
#    tag apache_access
#</rule>

mkdir -p /etc/kolla

#=>
cp /vagrant/globals.yml /etc/kolla
#cp /usr/local/share/kolla-ansible/etc_examples/kolla/globals.yml /etc/kolla

#=>
cp /usr/local/share/kolla-ansible/etc_examples/kolla/passwords.yml /etc/kolla

#=>
cp /vagrant/multinode /home/vagrant/kolla
#cp /usr/local/share/kolla-ansible/ansible/inventory/multinode /home/vagrant/kolla

#=>
cp /vagrant/init-runonce /home/vagrant/kolla
#cp /usr/local/share/kolla-ansible/init-runonce /home/vagrant/kolla

#=>
mkdir -p /etc/kolla/config/nova
cat <<EOF >/etc/kolla/config/nova/nova-compute.conf
[libvirt]
virt_type = qemu
cpu_mode = none
EOF

kolla-genpwd
kolla-ansible -i /home/vagrant/kolla/multinode bootstrap-servers
kolla-ansible -i /home/vagrant/kolla/multinode prechecks
kolla-ansible -i /home/vagrant/kolla/multinode deploy
kolla-ansible post-deploy

pip install python-openstackclient
cp /home/vagrant/kolla/init-runonce /usr/local/share/kolla-ansible/init-runonce
. /etc/kolla/admin-openrc.sh
cd /usr/local/share/kolla-ansible
./init-runonce

echo "Horizon available at 172.16.0.11, user 'admin', password below:"
grep keystone_admin_password /etc/kolla/passwords.yml
