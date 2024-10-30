# Azure Virtual Network Peering Module

## Overview

This Bicep module creates a bidirectional **peering** between two Virtual Networks (VNets) in Azure, allowing network traffic to flow between them as configured.

- **Module Name**: virtual-network-peering
- **Azure Resource**: Virtual Network
- **Version**: 1.0
- **Contributor**: Maxence Holvoet

## Parameters

| Name                      | Required | Type   | Description                                                                                                 | Default Value |
|---------------------------|----------|--------|-------------------------------------------------------------------------------------------------------------|---------------|
| `vnetName`                | Yes      | string | Name of the local VNet                                                                                      | N/A           |
| `remoteVnetName`          | Yes      | string | Name of the remote VNet                                                                                     | N/A           |
| `remoteVnetId`            | Yes      | string | Resource ID of the remote VNet                                                                              | N/A           |
| `allowForwardedTraffic`   | No       | bool   | Allows the local VNet to receive forwarded traffic from the remote VNet                                     | `false`       |
| `allowGatewayTransit`     | No       | bool   | Allows gateway in the local VNet to forward traffic to the remote VNet                                      | `false`       |
| `allowVirtualNetworkAccess` | No     | bool   | Allows the local VNet to access the remote VNet                                                             | `true`        |
| `useRemoteGateways`       | No       | bool   | Enables the local VNet to use the remote VNet gateway                                                       | `false`       |

## Usage Example

```bicep
module azvnetpeering 'https://github.com/AzMaxH/AzBicepModules/blob/main/network/peering.bicep' = {
  name: 'vnetPeeringDeployment'
  params: {
    vnetName: 'localVnet'
    remoteVnetName: 'remoteVnet'
    remoteVnetId: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/remoteVnet'
    allowForwardedTraffic: true
    allowGatewayTransit: false
    allowVirtualNetworkAccess: true
    useRemoteGateways: false
  }
}
```

## Outputs
| Name          	| Type	  | Description                       |
|-----------------|---------|-----------------------------------|
| `vnetPeeringId`	| string	| ID of the virtual network peering |