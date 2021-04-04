# Udacity Azure Operation Project

## Getting started
### Directory structure
```
availability_set
|   .gitignore
|   README.md
|   tree.txt
|   
+---packer  # This contains pakcer template 
|       web-server.json
|       
\---terraform
    |   main.tf 
    |   variables.tf
    |   
    \---modules # This contains reusable modules
        +---avset # Module for deploying avset
        |       main.tf
        |       variables.tf
        |       
        \---init # Module for deploying initial resources
                main.tf
                outputs.tf
                variables.tf
```
### Diagram

## Instruction
### Clone the repository
Switch your browser to Udacity Github site, get the `https` link from the forked repository.

![Get HTTPS link](./images/https_link.png)

Locate to where you want to clone the repository on your local computer:
```
git clone <HTTPS_link>
git pull origin main
```

### Create Azure service principle for deployment
Login to `az` CLI, then run following commands:
```
az account set --subscription="<SUBSCRIPTION_ID>"
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"
```

The command will output 5 values:
```
{
  "appId": "00000000-0000-0000-0000-000000000000",
  "displayName": "azure-cli-2017-06-05-10-41-15",
  "name": "http://azure-cli-2017-06-05-10-41-15",
  "password": "0000-0000-0000-0000-000000000000",
  "tenant": "00000000-0000-0000-0000-000000000000"
}
```
These values map to the Terraform variables like so:
- `appId` is the `client_id` defined in Packer template.
- `password` is the `client_secret` defined in Packer template.
- `tenant` is the `tenant_id` defined in Packer template.

### Deployment of tagging Policy

### Packer
Create a resource group for containing `packer image`
```
az group create --location southeastasia --name scalable-iaas
```
Here, we have 2 cases:
- If you have your own `Vault` server for storing secrets, you can use `web-server-vault.json` template for building image. Rememmber, `VAULT_ADDR` and `VAULT_TOKEN` environment variables are required to be configured first.
```
## On windows systems
$env:VAULT_ADDR="<YOUR-VAULT-SERVER-ADDRESS>"
$env:VAULT_TOKEN="<YOUR-ACCESS-TOKEN>"
```
- You can set the secrets' value with environment variables as the replacement. Then using `web-server-env.json` template for building image.
```
## On windows systems
$env:CLIENT_ID=<YOUR-CLIENT-ID>
$env:CLIENT_SECRET=<YOUR-CLIENT-SECRET>
$env:TENANT_ID=<YOUR-TENANT-ID>
$env:SUBSCRIPTION_ID=<YOUR-SUBSCRIPTION-ID>
```
Then, use `packer` to build the image:
```
packer build <PATH-TO-JSON-TEMPLATE>
```
Finally, verify with CLI command:
```
az image list
```

### Terraform
Structure of `terraform` directory:
```
terraform
|   main.tf
|   tree.txt
|   variables.tf
|   
\---modules
    +---avset
    |       main.tf
    |       variables.tf
    |       
    \---init
            main.tf
            outputs.tf
            variables.tf
```
Here, 2 modules have been includes:
- `init` module defines `resource_group` and `network` configurations which are using entire the project.
- `avset` modules defines components which make up an `availability_set`. You can decide how many instances place in your set via `vm_count` variables. Besides, `admin_username` and `admin_password`, which are used for authenticating on the VMs, are required to be configured.