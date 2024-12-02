# -*- mode: ruby -*-
# vi: set ft=ruby :
servers=[
  {
    :hostname => "controller",
    :box => "ubuntu/focal64",
    :ram => 10240,
    :cpu => 4,
    :disk => "20GB",
    :script => "sh /vagrant/controller_setup.sh",
	:mineip => "192.168.0.6",
	:mineippriv => "172.16.0.11"
  },
  {
    :hostname => "compute1",
    :box => "ubuntu/focal64",
    :ram => 4096,
    :cpu => 2,
    :disk => "10GB",
    :script => "sh /vagrant/compute1_setup.sh",
	:mineip => "192.168.0.7",
	:mineippriv => "172.16.0.31"
  },
  {
    :hostname => "block1",
    :box => "ubuntu/focal64",
    :ram => 2048,
    :cpu => 1,
    :disk => "10GB",
    :script => "sh /vagrant/block1_setup.sh",
	:mineip => "192.168.0.8",
	:mineippriv => "172.16.0.41"
  },
  {
    :hostname => "deployment",
    :box => "ubuntu/focal64",
    :ram => 2048,
    :cpu => 1,
    :disk => "40GB",
    :script => "sh /vagrant/deployment_setup.sh",
	:mineip => "192.168.0.9",
	:mineippriv => "172.16.0.100"
  }
]

Vagrant.configure(2) do |config|
    servers.each do |machine|
        config.vm.define machine[:hostname] do |node|
            node.vm.box = machine[:box]
            node.disksize.size = machine[:disk]
            node.vm.hostname = machine[:hostname]
			node.vm.network "public_network", ip: machine[:mineip]
			node.vm.network "private_network", ip: machine[:mineippriv]
			
            node.vm.provider "virtualbox" do |vb|
                vb.customize ["modifyvm", :id, "--memory", machine[:ram], "--cpus", machine[:cpu]]
                if machine[:hostname] == "block1"
                    file_to_disk = File.realpath( "." ).to_s + "/block1cinder.vdi"
                    vb.customize ['createhd', '--filename', file_to_disk, '--format', 'VDI', '--size', "30720"]
                   # In line below: 'SCSI' may have to be changed to possibly other name of Storage Controller Name of VirtualBox VM
                    vb.customize ['storageattach', :id, '--storagectl', 'SCSI', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
                end
              end
            node.vm.provision "shell", inline: machine[:script], privileged: true, run: "once"
            end
      end
end
