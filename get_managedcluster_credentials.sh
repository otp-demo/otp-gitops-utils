#!/bin/bash
username=<hub cluster password>
password=<hub cluster kubadmin password>
apiURL=<hub cluster api url> 


oc login $apiURL -u $username -p $password --insecure-skip-tls-verify


declare -a managed_clusters=$(oc get managedclusters --no-headers -o custom-columns=":metadata.name")
for cluster in $managed_clusters
do

clusterSecret=$(oc get clusterdeployment $managedClusterName -n $managedClusterName -o jsonpath='{.spec.clusterMetadata.adminPasswordSecretRef.name}')
username=$(oc get secret $clusterSecret  -n $managedClusterName -o jsonpath="{.data.username}" | base64 --decode)
password=$(oc get secret $clusterSecret  -n $managedClusterName -o jsonpath="{.data.password}" | base64 --decode)
apiURL=$(oc get clusterdeployment -n $managedClusterName -o jsonpath="{.items[0].status.apiURL}")

# pipe these credentials to wherever you want 
# i.e. echo password > $managedClusterName_password.txt

done