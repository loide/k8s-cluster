#!/bin/bash

echo "Configuring master......................................................."
# ip of this box
IP_ADDR=`ifconfig enp0s8 | grep -i Mask | awk '{print $2}'| cut -f2 -d:`

# install k8s master
HOST_NAME=$(hostname -s)
kubeadm init --apiserver-advertise-address=$IP_ADDR \
    --apiserver-cert-extra-sans=$IP_ADDR  \
    --node-name $HOST_NAME --pod-network-cidr=192.168.0.0/16

#copying credentials to regular user - vagrant
sudo --user=vagrant mkdir -p /home/vagrant/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown $(id -u vagrant):$(id -g vagrant) /home/vagrant/.kube/config

# install Calico pod network addon
export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl apply -f https://raw.githubusercontent.com/loide/k8s-cluster/master/calico/rbac-kdd.yaml
kubectl apply -f https://raw.githubusercontent.com/loide/k8s-cluster/master/calico/calico.yaml

kubeadm token create --print-join-command >> /etc/kubeadm_join_cmd.sh
chmod +x /etc/kubeadm_join_cmd.sh

# required for setting up password less ssh between guest VMs
sudo sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
sudo service sshd restart
