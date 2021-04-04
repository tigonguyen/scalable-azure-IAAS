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