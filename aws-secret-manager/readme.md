## AWS Secret Manager

### Install Secret manager CSI driver 
helm repo add secrets-store-csi-driver https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts
helm install csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver --namespace kube-system --set syncSecret.enabled=true --set enableSecretRotation=true

### Install Secrets Manager CSI driver provider.
To enabe kubernetes to retrieve secrets from secrets manager we must deploy CSI driver provider

helm repo add aws-secrets-manager https://aws.github.io/secrets-store-csi-driver-provider-aws
helm install -n kube-system secrets-provider-aws aws-secrets-manager/secrets-store-csi-driver-provider-aws


### Create a Service Account and add the rolearn with relevant permission


### Create a secret provider class