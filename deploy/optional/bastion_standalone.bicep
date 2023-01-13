@description('Name of the existing Virtual Network')
param virtualNetworkName string

@description('Name of the existing Bastion Public IP')
param bastionPublicIpName string

@description('Name of the existing  Bastion Host')
param bastionHostName string

param subnetName string

param location string

resource r_virtualNetwork 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: virtualNetworkName
}

resource r_bastionSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' existing = {
  name: subnetName
  parent: r_virtualNetwork
}

resource r_pipBastion 'Microsoft.Network/publicIPAddresses@2021-02-01' existing = {
  name: bastionPublicIpName
}

resource r_bastionHost 'Microsoft.Network/bastionHosts@2022-07-01' = {
  name: bastionHostName
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    disableCopyPaste: false
    enableIpConnect: false
    enableShareableLink: false
    enableTunneling: false
    ipConfigurations: [
      {
        name: 'bastionIpConf'
        properties: {
          publicIPAddress: {
            id: r_pipBastion.id
          }
          subnet: {
            id: r_bastionSubnet.id
          }
        }
      }
    ]
    scaleUnits: 2
  }
}
