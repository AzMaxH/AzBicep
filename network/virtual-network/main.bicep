/*
Name : virtual-network
Azure Resource : Virtual Network
Description : Bicep module for creating a virtual network on Azure
Version : 1.0
Contributor : Maxence Holvoet
*/

// Mandatory parameters
@description('Name of the virtual network')
param vnetName string

@description('Location/Region of the virtual network')
param location string

@description('Address space for the virtual vetwork (e.g., 10.0.0.0/16)')
param vnetAddressSpace array

@description('List of subnet configurations for the virtual network')
param vnetSubnets array

// Optional parameters
@description('List of DNS server IP addresses for the virtual network (leave by default for using Azure-provided DNS)')
param dnsServers array = []

@description('Tags to be assigned to the resources')
param tags object = {}

// Variables
var allSubnets = [ for subnet in vnetSubnets: {
  name: subnet.name
  addressPrefix: subnet.addressPrefix
  networkSecurityGroup: contains(subnet, 'networkSecurityGroup') ? {
    id: resourceId('Microsoft.Network/networkSecurityGroups', subnet.networkSecurityGroup)
  } : null
  routeTable: contains(subnet, 'routeTable') ? {
    id: resourceId('Microsoft.Network/routeTables', subnet.routeTable)
  } : null
  serviceEndpoints: subnet.?serviceEndpoints ?? []
  delegations: subnet.?delegations ?? []
  privateEndpointNetworkPolicies: subnet.?privateEndpointNetworkPolicies ?? 'Disabled'
}]

// Resources creation
resource vnet 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: vnetName
  location: location
  
  properties: {
    addressSpace: {
      addressPrefixes: vnetAddressSpace
    }
    dhcpOptions: {
      dnsServers: dnsServers
    }

    subnets: [
      for subnet in allSubnets: {
        name: subnet.name
        properties: {
          addressPrefix: subnet.addressPrefix
          networkSecurityGroup: subnet.networkSecurityGroup
          routeTable: subnet.routeTable
          serviceEndpoints: subnet.serviceEndpoints
          delegations: subnet.delegations
          privateEndpointNetworkPolicies: subnet.privateEndpointNetworkPolicies
        }
      }
    ]
  }
  tags: tags
}

// Outputs
output vnetId string = vnet.id
output vnetName string = vnet.name
output vnetLocation string = location
