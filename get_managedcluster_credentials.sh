#!/bin/bash
username=<hub cluster password>
password=<hub cluster kubadmin password>
apiURL=<hub cluster api url> 


oc login $apiURL -u $username -p $password --insecure-skip-tls-verify


declare -a managed_clusters=$(oc get managedclusters --no-headers -o custom-columns=":metadata.name")
for cluster in $managed_clusters
do

clusterSecret=$(oc get clusterdeployment $cluster -n $cluster -o=jsonpath='{.spec.clusterMetadata.adminPasswordSecretRef.name}')
username=$(oc get secret $clusterSecret  -n $cluster -o=jsonpath="{.data.username}" | base64 --decode)
password=$(oc get secret $clusterSecret  -n $cluster -o=jsonpath="{.data.password}" | base64 --decode)
apiURL=$(oc get clusterdeployment -n $cluster -o=jsonpath="{.items[0].status.apiURL}")

# pipe these credentials to wherever you want 

echo $cluster
echo "  ${apiURL}"
echo "  ${username}"
echo "  ${password}"

done
