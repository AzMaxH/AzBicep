/*
Name : virtual-network-peering
Azure Resource : Virtual Network
Description : Bicep module for creating a peering between two VNets in Azure
Version : 1.0
Contributor : Maxence Holvoet
*/

// Mandatory parameters
@description('The name of the local VNet')
param vnetName string

@description('Name of the remote VNet')
param remoteVnetName string

@description('Resource ID of the remote VNet')
param remoteVnetId string

// Optional parameters
@description('Allow the local virtual network to receive forwarded traffic from the remote virtual network')
param allowForwardedTraffic bool = false

@description('Allow gateway in the local virtual network to forward traffic to the remote virtual network')
param allowGatewayTransit bool = false

@description('Allow the local virtual network to access to the remote virtual network')
param allowVirtualNetworkAccess bool = true

@description('Enable the local vnet to use the remote virtual network gateway')
param useRemoteGateways bool = false

// Resources dependencies
resource vnet 'Microsoft.Network/virtualNetworks@2024-01-01' existing = {
  name: vnetName
}

// Resources creation
resource peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-01-01' = {
  name: '${vnetName}-to-${remoteVnetName}'
  parent: vnet

  properties: {
    remoteVirtualNetwork: {
      id: remoteVnetId
    }
    allowVirtualNetworkAccess: allowVirtualNetworkAccess
    allowForwardedTraffic: allowForwardedTraffic
    allowGatewayTransit: allowGatewayTransit
    useRemoteGateways: useRemoteGateways
  }
}

// Outputs
output vnetPeeringId string = peering.id
