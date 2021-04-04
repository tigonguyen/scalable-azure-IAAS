# Udacity Azure Operation Project

## Getting started
### Directory structure
```
udacity_project
|   .gitignore
|   README.md
|   tree.txt
|   
+---images
|       https_link.png
|       
+---packer
|       web-server-env.json
|       web-server-vault.json
|       
+---policy
|       tagging.json
|       
\---terraform
    |   main.tf
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
Define `tagging.json` policy file, then use follwing commands for assign the policy to resource group. Here, we just test with ther RG which contains Packer images.
```
az policy definition create --name tagging --rules <PATH-JSON-POLICY> --subscription <SUBSCRIPTION-NAME>
## Store the ID to the $varid
varid=<POLICY-ID>
az policy assignment create --name 'tagging-assignment' --resource-group <RG-NAME> --policy $varid
```

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
- `avset` module defines components which make up an `availability_set`. You can decide how many instances place in your set via `vm_count` variables. Besides, `admin_username` and `admin_password`, which are used for authenticating on the VMs, are required to be configured.

`./terraform/main.tf` contains 2 options that you can choose by yourselft, deploying entire project with secrets stored on `Vault` server or `./terraform/variables.tf` file.

Navigate to the `terraform` directory, then run following commands:
```
terraform init
terraform plan
terraform apply
## Then, destroy the created system
terraform destroy
```
