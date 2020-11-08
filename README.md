# b59s-aks
Implementing [BuildFive9s AKS sample](https://build5nines.com/terraform-create-an-aks-cluster/)

## What are the Steps
This will list all the steps needed to deploy AKS on windows

### Prerequisites

- VSCode
- Azure CLI (add to windows path)
- Terraform (add to windows path)

### Steps:

1. Open VSCode, in the terminal, login to Azure
    ```
    az login
    ```
1. In VSCode create a file ```backend-config-eng.tfvars``` (Note: typically this file is is environment specific) to copy all required values.
_NOTE: Make sure backend-config-*.tfvars is added to .gitignore_
1. Open Portal, make sure your account has permissions to ```Microsoft.Authorization/*/write```
1. Create a ServicePrincipal that is needed to execute Terraform from local machine
    ```
    az ad sp create-for-rbac --role 'contributor'  --scope '/subscriptions/<your-subscription-name>'
    ```
1. Copy the ```appId``` and ```password``` to ```backend-config-eng.tfvars```, that was created above, as key-value pair
1. Create a ResourceGroup, Deploy storageaccount and a container. 
1. Copy StorageAccount ```accesskey``` to ```backend-config-eng.tfvars```
1. Follow the instructions in the [Build5nines](https://build5nines.com/terraform-create-an-aks-cluster/)
1. Execute Terraform initialization, to prepare the environment
    ```terraform init -backend-config backend-config-eng.tfvars```
1. Execute Terraform plan, to view all the deployments that are planned within the subscription. Save it to file
    ```terraform plan```
1. Ready to deploy, Finally execute with auto approval (ofcouse optional)
    ```terraform apply -auto-approve```

If there was any deployment error, you know what to do.. debug 

### Test deployment
Once the deployment is complete, check what is deployed
```az aks show --resourcegroup-name '<your-resourcegroup-name>' --name '<name-of-aks>'```

### Access 
Yes almost there, within the deployment notice that the aks-administrator group is created without memebers, add members and checkout the behavior. 

That is it.. 