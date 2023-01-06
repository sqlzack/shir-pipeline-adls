## Configuring Virtual Machine to Host SHIR and Data
### Summary
A Self Hosted Integration Runtime differentiates itself from a regular Azure Integration Runtime in Azure Data Factory by requiring infrastructure to be manually provisioned to host it. The steps in this walkthough serve as a guide to connect the Azure Data Factory resource to the Virtual Machine host. Also, you'll download some data to the host to be used in data loading and transformation exercises in ADF.
    
###  Steps
#### Log into Bastion Host
1)  Go to the Azure Portal and the Virtual Machine resource deployed in previous steps.
2)  On the Overview screen click Connect and select Bastion

      ![](./images/vmSetup01.png)
3) On the subsequent screen either manually input the Virtual Machine Username and Password as defined on deployment or use the Azure Key Vault Secret created in previous steps.


      ![](./images/vmSetup02.png)
4) This should open up a new browser window with your VM. If prompted to allow clipboard access you should allow as you'll likely be pasting text into Bastion in a future step.

#### Download Integration Runtime and Configure


#### Download Data and Set Up Share
<!-- 
1. Download Sample Files
2. Install IR
3. Set up shared folder and put files in it -->