### Pod
* Smallest and simplest deployable compute in kubernetes.
* Containers within the pod shared the same network, namespace. They can communicate with each other via localhost.
* Each Pod is assigned a unique IP.
* Pods are ephemeral and stateless
* Pods are manage by higher-level controller, (deployment, statefulsets, jobs)

### Nginx Pod Manifest Example.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
```
### Basic Pod commands

```
#Create a pod from manifest file
kubectl apply -f nginx-pod.yaml

#List down all the available pods in the current namespace.
kubectl get pods

#Print out all the logs of the pod.
kubectl logs -f nginx-pod

#This will list out all the information related to the pod.
kubectl describe pod nginx-pod 

#SSH/exec into the pod
kubectl exec -it nginx-pod bash
```


NOTE: In every kubernetes manifest file, these four attributes are always present. 
```yaml
apiVersion: 

    It is the version of the kubernetes api to create an object. This vary from resource to resource and to list down all api version resources use 'kubectl api-resource'. This will list down all the kubernetes object and their apiVersion and some other details.

kind:

    It's the type of kubernetes object, which we want to create. e.g pod, deployment, service, ingress etc.

metadata:
 
    It's the information about the object.
    eg. name of object, labels , namespace 

spec:

    It specifies the desired state of the object. e.g container-image, container-name, container-port, replicas, selector, template.
    Note: The specification of the object and it's attribute may vary from object to object.
    
```

### Deployment:


