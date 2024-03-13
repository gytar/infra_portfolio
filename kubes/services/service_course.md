# Services

## Connecting users or applications to pods
pods are ephemeral, so you cannot use a static IP address. Kubernetes provides a high-level abstraction called **Service** for that. 

check the service exaple in ./service-example.yaml

Services labels are inside of `selector` in yml files.

Services can handle env variables and DNS connections


## documentation references
- [Traffic policies API](https://kubernetes.io/docs/reference/networking/virtual-ips/#traffic-policies)
- [French reference for Services](https://wiki.sfeir.com/kubernetes/architecture/composants/services/)

## Examples

Create a simple pod 

```bash
kubectl run pod-hello --image=pbitty/hello-from:latest --port=80 --expose=true
```
edit pod service
```bash
kubectl edit svc pod-hello
```
and then change CluserIP to NodePort

Check if it has worked: 
```bash
minikube service pod-hello
```
It should display an URL, and if you're lucky, open a new tab in your web browser pointing to the URL

What if you wanted to deploy multiple pods ? Don't worry I got you covered

- first create your deployment
```bash
kubectl crete deployment hello-deploy --image=pbitty/hello-from:latest --port=80 --replicas=3
```
- then expose it with a NodePort 
```bash
kubectl expose deployment hello-deploy --type=NodePort
```
- then if you do this command, your deployment can be opened in your favorite web browser
```bash
kubectl service hello-deploy
```

You can also curl to see that all three pods are being used (replace localhost:1234 by the service address given in the previous command)
```bash
for i in $(seq 1 10); do curl localhost:1234; printf "\n"; done
```

## Load balancers

Some kind of super NodePort. Can do most of what a NodePort can do and outputs the service to a static IP address. This is useful with cloud providers, as the service is exposed with the cloud provider's load balancers feature. Can only work if underlying infra supports Load Balancers (in AWS or GCP)
tags #service #kube-proxy
