1. [Clone the repository you're currently viewing into Visual Studio Code](https://learn.microsoft.com/en-us/azure/developer/javascript/how-to/with-visual-studio-code/clone-github-repository?tabs=create-repo-command-palette%2Cinitialize-repo-activity-bar%2Ccreate-branch-command-palette%2Ccommit-changes-command-palette%2Cpush-command-palette)
2. [Deploy VM, AKV,Storage, and ADF](./docs/deploy/README.md)
3. AKV set up 
   1. Give ADF permission to AKV
   2. Add vmUserName and vmPassword secrets to AKV
4. ADF set up
   1. Add SHIR to ADF
5. Set up VM 
   1. Download Integration Runtime
   2. Download Sample Files
   3. Install IR
   4. Set up shared folder and put files in it
6. Set up Linked Services in 
   1. Add AKV Linked Service and Local Storage Linked Service
   2. Add Generic CSV dataset
7. 