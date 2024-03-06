Create a deployment using the command line. 

```bash
kubectl create deployment mynginx --image=nginx:1.15-alpine
```

List pods, replica sets and deployment from deployment of the line before

```bash
kubectl get deploy,rs,po -l app=mynginx
```

Scale the deployment to three replicas

```bash
kubectl scale deploy mynginx --replicas=3
```

show deployment infos

```bash
kubectl describe deploy mynginx 
```

for rolling updates and rollbacks

```bash
kubectl rollout history deploy nynginx 
```

performing an rolling update by upgrading `nginx-apline` version from `1.15` to `1.16`.

```bash
kubectl set image deployment mynginx nginx=1.16-apline
```

to rollback to revision 1

```bash
kubectl rollout undo deployment mynginx --to-revision=1
```

### daemon sets

you must create a daemon set in a yaml file first (eg. ../daemonsets/daemonset.yml)

then you can apply the daemon to the pods by doing so 

```bash
kubectl apply -f daemonset.yaml 
```

these are links to the offical documentation for deployment, replica sets pods and daemon set
https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/
https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
https://kubernetes.io/fr/docs/concepts/workloads/controllers/replicaset/
https://kubernetes.io/fr/docs/concepts/workloads/pods/pod/

