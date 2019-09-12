#!/bin/bash

echo "Configuring node........................................................."
apt-get install -y sshpass
sshpass -p "vagrant" scp -o StrictHostKeyChecking=no vagrant@192.168.50.10:/etc/kubeadm_join_cmd.sh .
sh ./kubeadm_join_cmd.sh
