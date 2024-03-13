# Authentication, Authorisation and Admission Control

Pour accéder à une API de kuberentes, il faudra passer par ces différentes étapes.

## Authentication

il n'y a pas d'objets `user` dans kubernetes, et on ne store pas les nom d'utilisateurs. 

Il y a 2 types d'utilisateurs

- Normal: managé hors de k8s (Compte Google, certificats utilisateurs)
- Service Account

learn about different types of authentication (client ca, static token file, bootstrap token, service account token, openID connect token, webhook token auth, authenticating proxy)

## Attribute-Based Access Control (ABAC)

ABAC adds policy to kubernetes access API 

for example: 

```json
{
    "apiVersion": "abac.authorization.kubernetes.io/v1beta1",
    "kind": "Policy",
    "spec": {
        "user": "johndoe",
        "namespace": "ird476",
        "resource": "pods",
        "readonly": true
    }
}
```
In this file, john doe can only read pods from namespace "ird476"

To enable ABAC mode : start API server with `--authorization-mode=ABAC` option. Specify authorization policy with `--authorization-policy-file=PolicyFile.json`. 

- [For more info on abac](https://kubernetes.io/docs/reference/access-authn-authz/abac/)
- [Link to webhook mode](https://kubernetes.io/docs/reference/access-authn-authz/webhook/) 

## Role-Based Access Control (RBAC)
there are roles

Example: 
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: ird476
  name: pod-reader
rules:
- apiGoups: [""] # core API group
  resource: ["pods"]
  verbs: ["get", "watch", "list"]
```
and there are RoleBinding
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: roleBinding
metadata:
  name: pod-read-access
  namespace: ird476
subjects:
- kind: User
  name: johndoe
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```
API server with `--authorization-mode=RBAC` option enabled. 

[RBAC documenation](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)

## Authentication
create a user and add a ssl key and csr. 

`kubectl create namespace lfs158`

`sudo useradd -s /bin/bash bob`

`sudo passwd bob`

`openssl genrsa -out bob.key 2048`

`openssl req -new -key bob.key -out bob.csr -subj "/CN=bob*O=learner"`

get the certificate created : 

`cat bob.csr | base64 | tr -d '\n','%' | xlip -sel clip`

you must first create an authentication request in yaml format (see ../rbac/signing-request.yml)
then add the certificate to kubes using : `kubectl create -f signing-request.yml`
chcek the certificate name : `kubectl get csr`
approve with : `kubectl certificate approve bob-csr`

you must exctract the approved certificate from the certificate signing request, decode it with base64 and save it. 

`kubectl get csr bob-csr -o jsonpath='{.status.cerificate}' | base64 -d > bob.crt`

then set credentials 

`kubectl config set-credentials bob --client-certificate=bob.crt --client-key=bob.key`

if you check the config with `kubectl config view` you must see a new user and a new context

### Create a role
first create a role.yml file like in ../rbac/role.yaml

then `kubectl create -f role.yaml`

### Authentication
create a rolebinding, then add it to kubernetes clutser with `kubectl create -f role-binding.yaml`

Then get the rolebining. `kubectl -n lfs158 get rolebinding`

Then we can successfully list pods from new context bob-context

### Admission control

In a nutshell : 

> An admission controller is a piece of code that intercepts requests to the Kubernetes API server prior to persistence of the object, but after the request is authenticated and authorized.
> -- kubernetes.io

#### Default admission controllers in a minikube env

how to get it :
```bash
kubectl -n kube-system describe pod kube-apiserver-minikube | awk -F '=' '$1 ~ /admission {print $2}'
```
- NamespaceLifecycle
- LimitRanger
- ServiceAccount
- DefaultStorageClass
- DefaultTolerationSeconds
- NodeRestriction
- MutatingAdmissionWebhook
- ValidatingAdmissionWebhook
- ResourceQuota

#### how to change pull policy

First off, if you're using minikube, connect to it. 

```bash
minikube ssh
```

then check if `AlwaysPullImages` is already there

```bash
sudo grep AlwaysPullImages /etc/kubernetes/manifest/kube-apiserver.yaml
```

make a backup for `kube-apiserver.yaml`

```bash
sudo cp /etc/kubernetes/manifest/kube-apiserver.yaml /kube-apiser.yaml.backup
```

then add `AlwaysPullImages` in `kube-apiserver.yaml` in `--enable-admission-plugin` flag of kube-apiserver file. 

finally, exit minikube, and wait for kube culter to reload.

check if everything worked by getting all pods. 



#### references:

- [reference to admission controller in documentation](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/)
- [list of admission controllers](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/#what-does-each-admission-controller-do)
- [dynamic admission control](https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/)


