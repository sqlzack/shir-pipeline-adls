param storageAccountName string
param location string
param storageAccountContainerName string

resource r_StorageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    isHnsEnabled: true
    supportsHttpsTrafficOnly: true
  }
}

resource r_StorageAccountBlobSvc 'Microsoft.Storage/storageAccounts/blobServices@2022-05-01' = {
  name: 'default'
  parent: r_StorageAccount
}

resource r_StorageAccountContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' = {
  name: storageAccountContainerName
  parent: r_StorageAccountBlobSvc
  }
