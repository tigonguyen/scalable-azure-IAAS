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
git clone <https links>
git pull origin main
```

### Create Azure service principle for deployment
Login to `az` CLI, then run following commands:
```

```
