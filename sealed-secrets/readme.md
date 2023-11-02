## Kubernetes sealed secrets 

Install client CLI kubeseal 


### Install controller/operator in the cluster.

Add sealed secret helm repo and install sealed secret controller using helm chart
```bash
helm repo add sealed-secrets https://bitnami-labs.github.io/sealed-secrets

helm install sealed-secrets -n kube-system --set-string fullnameOverride=sealed-secrets-controller sealed-secrets/sealed-secrets

```


### Testing if the kubeseal is communicating with our cluster. Run the below command to check 

```
kubeseal --fetch-cert
```
This will return the public certificate which means our client kubeseal is able to communicate with kubeseal controller installed in our cluster.


### Use a sample kubernetes secrets and sealed the secret kubeseal CLI

We will use the 'sample-secret.yaml' file as our base kubernetes secret. This file contains a sample secret object with key value.


```yaml
#sample-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: sealed-sample-secret
type: Opaque
data:
  sample-secret: YWRtaW4K  
```

To Seal this 'sample-secret.yaml' follow the below instruction.

```
kubeseal --controller-name sealed-secrets-controller  --controller-namespace kube-system --format yaml < sample-secret.yaml > sealed-sample-secret.yaml
```
The above command will encrypt the secrets values from 'sample-secret.yaml' file, create a new file with encrypted secret values 'sealed-sample-secret.yaml' and the values can only be decrypted by a kubeseal controller which will be running in the cluster. 

```yaml
#sealed-sample-secret.yaml
apiVersion: bitnami.com/v1alpha1
kind: SealedSecret
metadata:
  creationTimestamp: null
  name: sealed-sample-secret
  namespace: default
spec:
  encryptedData:
    sample-secret: AgCiorna9YlLiSTmg3FAvkwanlYYGIpjPdtrnw4jr4vHtzYvKt/MCqPGdKR4DtGfO57/+p/yTpPNMkFz3NTvCnGdm56Va1VhrIm9ctPV4fwLuuXBZwMDBwChUBg0fyvA6ex0Vst5S9gW9Z2mi3uoW7CcTsL67VJ1krGX7ESWDqseSkY9iqSQrvGsnA52AZRUOjEwXH09rZjCM+PmF8FkgwYLgCf2/Y5vNyjTE08gQZLLF1sEAakssNu2vP6MMSp41m03CbSIPrryvcPnYibpOKSCc2PVQfRVjAXiKAvF2p9GbKuXjEENwJXjx0pnjuIweIG/S0fRSd4ru6H4XzlXTSPV5jQeLtCfaFkDQ3PJjZs23xsBb61yf6WrQPoMC/4PfTFCMVxXMw6az8KV7oiN+a5SfxDRELmi2lJINJr5gOIT0uGKa41pjcF0ANClbJPHkwOvM40IaUiyNxhywA8gl0XqgxZFECxDbFZWEO23bxoT8EHBStdjO4180lGB6AraPneG7w/kS1GQ7AXcNhTCX5VjMawYwGG7wGY3QKNlSMBf3EvZ+T0R/NIpgvSi3/QNjuZ+MXf1H/P+Arb8seJ+8aibKAqI+NG4lpPChGkqWCMwnGdSSucqBDkyyFLU/irzTW6iFQJtykDQC+5FqwrC7CKi74KEbtQU7JBxsjfsimm0Iqdxnf9PLhvICPu1hfqW3LE1SklCUMQ=
  template:
    metadata:
      creationTimestamp: null
      name: sealed-sample-secret
      namespace: default
    type: Opaque
```

### Apply the sealed secret 

kubectl apply -f sealed-sample-secret.yaml


### Check the ownerReference of the secret deploy. 
kubectl get secret sealed-sample-secret -oyaml

The below yaml output shows the secret which we deploy is decrypted using sealed controller.
```yaml
apiVersion: v1
data:
  sample-secret: YWRtaW4K
kind: Secret
metadata:
  creationTimestamp: "2023-10-30T21:47:41Z"
  name: sealed-sample-secret
  namespace: default
  ownerReferences:
  - apiVersion: bitnami.com/v1alpha1
    controller: true
    kind: SealedSecret
    name: sealed-sample-secret
    uid: 1468785f-f550-4f0e-87d4-e8c6a4ba2a08
  resourceVersion: "101664"
  uid: 218a4056-155a-4836-b3c4-e083b0832a98
type: Opaque
```

### Encrypting using public certificate

kubeseal --fetch-cert > public-key-cert.pem

### Seal secret using the public-key-cert.pem file



### Pulling Image From Private Dockerhub Repo

* encode the file located at `~/.docker/config.json` using `cat ~/.docker/config.json | base64`
* Create kubernetes secret kind `kubernetes.io/dockerconfigjson`
* Reference the secret name in pod/deployment using `imagePullSecrets` property with name of the secret.
* This will pull the image from private dockerhub repo.

```yaml
#secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: imagepullsecret
  labels:
    docker-registry: loginCreds
data:
  .dockerconfigjson: <encode value from ~/.docker/config.json>
type: kubernetes.io/dockerconfigjson

```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: monitoring-app
spec:
  containers:
    - name: monitoring-app
      image: script0kid/imagepullsecrets:monitoring.v1
      ports:
        - containerPort: 5000
  imagePullSecrets:
    - name: imagepullsecret
```