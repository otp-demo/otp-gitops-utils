#!/bin/bash

oc login <token or creds for HUB CLUSTER>

Clusters=("aws0" "aws1" "aws2" "azure0" "azure1")

for clusterName in ${Clusters[@]}
do
clusterSecret=$(oc get clusterdeployment $clusterName -n $clusterName -o jsonpath='{.spec.clusterMetadata.adminPasswordSecretRef.name}')
username=$(oc get secret $clusterSecret  -n $clusterName -o jsonpath="{.data.username}" | base64 --decode)
password=$(oc get secret $clusterSecret  -n $clusterName -o jsonpath="{.data.password}" | base64 --decode)
apiURL=$(oc get clusterdeployment -n $clusterName -o jsonpath="{.items[0].status.apiURL}")

oc login $apiURL -u $username -p $password --insecure-skip-tls-verify

oc delete pods --all -n submariner-operator

oc -n submariner-operator scale deploy submariner-addon --replicas=0
oc patch Submariner submariner --type=merge -p '{"spec":{"natEnabled": true}}' -n submariner-operator
oc -n submariner-operator scale deploy submariner-addon --replicas=1

oc login <token or creds for HUB CLUSTER> 
done
subctl diagnose all
