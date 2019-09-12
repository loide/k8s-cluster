# -*- mode: ruby -*-
servers = [
    {
        :name => "k8s-master",
        :type => "master",
        :box => "ubuntu/xenial64",
        :ip => "192.168.50.10",
        :mem => "2048",
        :cpu => "2"
    },
    {
        :name => "k8s-node1",
        :type => "node",
        :box => "ubuntu/xenial64",
        :ip => "192.168.50.11",
        :mem => "1024",
        :cpu => "1"
    },
    {
        :name => "k8s-node2",
        :type => "node",
        :box => "ubuntu/xenial64",
        :ip => "192.168.50.12",
        :mem => "1024",
        :cpu => "1"
    }
]

Vagrant.configure("2") do |config|
    servers.each do |opts|
        config.vm.define opts[:name] do |config|
            config.vm.box = opts[:box]
            config.vm.hostname = opts[:name]
            config.vm.network "private_network", ip: opts[:ip]

            config.vm.provider "virtualbox" do |v|
                v.name = opts[:name]
                v.customize ["modifyvm", :id, "--memory", opts[:mem]]
                v.customize ["modifyvm", :id, "--cpus", opts[:cpu]]
            end
            config.vm.provision "shell", path: "scripts/configurebox.sh"

            if opts[:type] == "master"
                config.vm.provision "shell", path: "scripts/configuremaster.sh"
            else
                config.vm.provision "shell", path: "scripts/configurenode.sh"
            end
        end
    end
end
