# Utilities and scripts for otp-gitops 

## Fix Submariner deployment 

### Prerequisites
* Submariner deployments can occasionally become tangled with dangling clusters or with connection issues. 
* One way to resolve these is by deleting all of the pods in the `submariner-operator` namespace. 
* For Submariner on Azure, occasionally submariner may fall into a degraded state due to NAT being turned off. The fix for this is to patch the azure clusters to enable NAT. 
* This can be done using the `fix_submariner_deployment.sh` script. 

### Running the script

* define the clusters you wish to apply the fix to in the list
* The fix submariner deployment can perform a hard reset of all of the clusters provided. 
* Replace the blank oc login command with either a token login, or kubeadmin credentials 
* Uncomment the ` # oc delete pods --all -n submariner-operator` line if you wish to refresh the pods. 
* Uncomment the `# oc -n submariner-operator scale deploy submariner-addon --replicas=0 # oc patch Submariner submariner --type=merge -p '{"spec":{"natEnabled": true}}' -n submariner-operator # oc -n submariner-operator scale deploy submariner-addon --replicas=1` lines should you wish to apply patches to azure clusters 

## Get ManagedCluster credentials

### Prerequisites 

* If a hub cluster fails and you need to gather credentials, or you wish to gather the kubeadmin credentials for all managed clusters you can use the `get_managedcluster_credentials.sh` script. 

### Running the script

* To run the script simply define the credentials for the RHACM hub cluster you wish to gather credentials for. 
* Run `get_managedcluster_credentials.sh`
