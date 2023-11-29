# 1. Add The experter python script to source cluster's toolbox pod under /etc/ceph
# 2. Exec into the toolbox and run these commands:
cd /etc/ceph
python3 ./create-external-cluster-resources.py --rbd-data-pool-name <pool_name> --namespace <namespace> --format bash

# 3. Set the output of the last command as Environment Variables and Run import Script (Kubeconfig = Consumer Cluster) to create Secrets and Configmaps
./import-external-cluster.sh

# 4. Apply The common.yaml, crds.yaml and operator.yaml manifests to install the operator
kubectl apply -f ./manifests/common.yaml
kubectl apply -f ./manifests/crds.yaml
kubectl apply -f ./manifests/operator.yaml

# 5. Apply the common-external.yaml and cluster-external.yaml to deploy the external cluster

kubectl apply -f ./manifests/common-external.yaml
kubectl apply -f ./manifests/cluster-external.yaml