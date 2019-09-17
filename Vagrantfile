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
        :cpu => "2"
    },
    {
        :name => "k8s-node2",
        :type => "node",
        :box => "ubuntu/xenial64",
        :ip => "192.168.50.12",
        :mem => "1024",
        :cpu => "2"
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
                config.vm.provision "file", source: "pyclient", destination: "pyclient"
            else
                config.vm.provision "shell", path: "scripts/configurenode.sh"
            end

            # trigger command on master after the last node is up
            config.trigger.after :up do |t|
                t.only_on = "k8s-node2"
                t.info = "Running after the last node is up"
                t.run = {inline: "vagrant ssh k8s-master -c 'pip3 install -r pyclient/requirements.txt  && python3 pyclient/main.py'"}
            end
        end
    end
end
