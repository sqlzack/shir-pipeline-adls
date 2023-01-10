@description('Username for the Virtual Machine.')
param adminUsername string

@description('Password for the Virtual Machine.')
@minLength(12)
@secure()
param adminPassword string

// @description('Name for the Public IP used to access the Virtual Machine.')
// param publicIpName string

@description('The Windows version for the VM. This will pick a fully patched image of this given Windows version.')
param OSVersion string

@description('Size of the virtual machine.')
param vmSize string

@description('Name of the virtual machine.')
param vmName string

@description('Name of the Bastion Public IP')
param bastionPublicIpName string

@description('Name of the Bastion Host')
param bastionHostName string

@description('The name of the Azure Data Factory resource.')
param adfFactoryName string

@description('The name of the Azure Key Vault resource.')
param keyVaultName string

@description('The name of the storage account.')
param storageAccountName string

@description('The name of the storage account container.')
param storageAccountContainerName string

param location string = resourceGroup().location

module m_adfDeploy 'modules/adf.bicep' = {
  name: 'dataFactoryDeploy'
  params:{
    adfFactoryName: adfFactoryName
    location: location
  }
}

module m_akvDeploy 'modules/akv.bicep' = {
  name: 'keyVaultDeploy'
  params:{
    keyVaultName: keyVaultName
    location: location
  }
}

module m_shirVmDeploy 'modules/shirvm.bicep' = {
  name: 'selfHostedIRDeploy'
  params:{
    adminPassword: adminPassword
    adminUsername: adminUsername
    bastionHostName: bastionHostName
    bastionPublicIpName: bastionPublicIpName
    OSVersion: OSVersion
    // publicIpName: publicIpName
    vmName: vmName
    vmSize: vmSize
    location: location
  }
}

module m_storageDeploy 'modules/storage.bicep' = {
  name: 'storageDeploy'
  params: {
    location: location
    storageAccountContainerName: storageAccountContainerName
    storageAccountName: storageAccountName
  }
}
