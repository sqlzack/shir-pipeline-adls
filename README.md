# Simulate Loading On Prem Data in Azure Data Factory

## Summary 
The purpose of this repository is to allow you to simulate the process of bringing data from an On Prem File System to Azure Data Lake by using a Self Hosted Integration Runtime in Azure Data Factory. 

## Pre-requisites 
1) A sandbox Azure Resource Group where the deploying user has Contributor access. [More Info Here](https://learn.microsoft.com/en-us/azure/role-based-access-control/overview#role-assignments)
2) The necessary Resource Providers for Azure Data Factory, Key Vault, Virtual Machines (Compute), and Storage Accounts. [More Info Here](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/resource-providers-and-types)
3) Access to a means to deploy Bicep scripts. [Visual Studio Code](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-vscode) works well to iteratively work through the needed parameters in the event of a a deployment failure. [CLI](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-cli), [Powershell](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-powershell), and [Azure Cloud Shell](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-cloud-shell?tabs=azure-cli) are other options.

## Steps
1. [Clone the repository you're currently viewing into Visual Studio Code](https://learn.microsoft.com/en-us/azure/developer/javascript/how-to/with-visual-studio-code/clone-github-repository?tabs=create-repo-command-palette%2Cinitialize-repo-activity-bar%2Ccreate-branch-command-palette%2Ccommit-changes-command-palette%2Cpush-command-palette)
2. [Deploy Resources to Sandbox Resource Group](./docs/deploy/README.md)
3. [Prepare Azure Key Vault and Add Secrets](./docs/akv/setup.md)
4. [Create Self Hosted Integration Runtime in Azure Data Factory](./docs/adf/createShir.md)
5. [Prepare Virtual Machine](./docs/shirvm/setup.md)
6. [Set up Linked Services and Data Sets](./docs/adf/linkedServicesDatasets.md)