@description('Username for the Virtual Machine.')
param adminUsername string

@description('Password for the Virtual Machine.')
@minLength(12)
@secure()
param adminPassword string

@description('Name for the Public IP used to access the Virtual Machine.')
param publicIpName string

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

@description('Location for all resources.')
param location string = resourceGroup().location

@description('Unique DNS Name for the Public IP used for Bastion Host')
var bastionDnsLabelPrefix = toLower('${bastionHostName}-${uniqueString(resourceGroup().id, bastionHostName)}')

@description('Unique DNS Name for the Public IP used to access the Virtual Machine.')
var dnsLabelPrefix = toLower('${vmName}-${uniqueString(resourceGroup().id, vmName)}')

@description('Allocation method for the Public IP used to access the Virtual Machine.')
var publicIPAllocationMethod = 'Dynamic'

@description('SKU for the Public IP used to access the Virtual Machine.')
var publicIpSku = 'Basic'

var storageAccountName = 'shirvmdx${uniqueString(resourceGroup().id)}'
var nicName = 'shirVmNic'
var addressPrefix = '10.0.0.0/16'
var subnetName = 'shirVmSubnet'
var subnetPrefix = '10.0.0.0/24'
var virtualNetworkName = 'shirVmVnet'
// var networkSecurityGroupName = 'shirVmNSG'

resource stg 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'Storage'
}

resource pip 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: publicIpName
  location: location
  sku: {
    name: publicIpSku
  }
  properties: {
    publicIPAllocationMethod: publicIPAllocationMethod
    dnsSettings: {
      domainNameLabel: dnsLabelPrefix
    }
  }
}

resource vn 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetPrefix
          // networkSecurityGroup: {
          //   id: securityGroup.id
          // }
        }
      }
    ]
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: pip.id
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vn.name, subnetName)
          }
        }
      }
    ]
  }
}

resource r_vm 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: OSVersion
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
      dataDisks: [
        {
          diskSizeGB: 128
          lun: 0
          createOption: 'Empty'
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: stg.properties.primaryEndpoints.blob
      }
    }
  }
}

resource r_pipBastion 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: bastionPublicIpName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    dnsSettings: {
      domainNameLabel: bastionDnsLabelPrefix
    }
  }
}

resource r_bastionSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' = {
  name: 'AzureBastionSubnet'
  parent: vn
    properties: {
      addressPrefix: '10.0.1.0/26'
    }
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
