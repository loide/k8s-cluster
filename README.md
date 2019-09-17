# Kubernetes cluster

A vagrant script to deploy a Kubernetes cluster.

## Requirements
* Vagrant
* Virtualbox

## How to Deploy
Download the code and execute the following command in the same folder as the Vagrantfile:

```
vagrant up
```

It will create 3 nodes (1 master and 2 workers). If more than 2 nodes are
required, you can add more by editing the servers array in the Vagrantfile.
Also, the provision create and run nginx service on the cluster.

This process will take some time, so go grab a coffee :)

After all deployment, you should see a list with all running pods in all
namespaces.


## Testing
Get in to the mater node and run any kubectl command.

```
vagrant ssh k8s-master
kubectl get nodes
```

This last command should show the nodes status.

```
vagrant@k8s-master:~$ kubectl get nodes
NAME         STATUS   ROLES    AGE     VERSION
k8s-master   Ready    master   5m51s   v1.15.3
k8s-node1    Ready    <none>   3m41s   v1.15.3
k8s-node2    Ready    <none>   85s     v1.15.3
```

There is a python script on master vm's home that shows all the pods running. This
script is executed after the ```vagrant up```.

```
cd pyclient
python3 main.py
```


Also, you may open a browser and put 192.168.50.x:30180 to see nginx running.
Where x may be 10, 11 or 12 as defined on node's IPs.

## Cleanup
```
vagrant halt
vagrant destroy -f
```
