# Azure Virtual Network (VNet) Module

## Overview

This Bicep module creates a **Virtual Network (VNet)** on Azure with advanced configuration options for subnets, Network Security Groups (NSG), route tables, and other network settings.

- **Module Name**: virtual-network
- **Azure Resource**: Virtual Network (VNet)
- **Version**: 1.0
- **Contributor**: Maxence Holvoet

## Parameters

| Name               | Required | Type   | Description                                                                            | Default Value |
|--------------------|----------|--------|----------------------------------------------------------------------------------------|---------------|
| `vnetName`         | Yes      | string | Name of the virtual network                                                            | N/A           |
| `location`         | Yes      | string | Location/Region of the virtual network                                                 | N/A           |
| `vnetAddressSpace` | Yes      | array  | Address space for the virtual network (e.g., 10.0.0.0/16)                              | N/A           |
| `vnetSubnets`      | Yes      | array  | List of subnet configurations                                                          | N/A           |
| `dnsServers`       | No       | array  | List of DNS server IP addresses for the virtual network                                | `[]`          |
| `tags`             | No       | object | Tags to be assigned to resources                                                       | `{}`          |

## Usage Examples

Here is examples of how to use this module in a Bicep deployment.

### Basic Deployment Example

```bicep
module azvnet 'https://github.com/AzMaxH/AzBicepModules/blob/main/network/vnet.bicep' = {
  name: 'vnetDeployment'
  params: {
    vnetName: 'myVNet'
    location: 'West Europe'
    vnetAddressSpace: [
      '10.0.0.0/16'
    ]
    vnetSubnets: [
      {
        name: 'webSubnet'
        addressPrefix: '10.0.1.0/24'
      }
    ]
    tags: {
      environment: 'test'
    }
  }
}
```

### Advanced Deployment Example

```bicep
module azvnet 'https://github.com/AzMaxH/AzBicepModules/blob/main/network/vnet.bicep' = {
  name: 'vnetDeployment'
  params: {
    vnetName: 'myVNet'
    location: 'West Europe'
    vnetAddressSpace: [
      '10.0.0.0/16'
    ]
    vnetSubnets: [
      {
        name: 'GatewaySubnet'
        addressPrefix: '10.0.0.0/24'
      }
      {
        name: 'webSubnet'
        addressPrefix: '10.0.1.0/24'
        networkSecurityGroup: 'NsgName'
        routeTable: 'RouteTableName'
        serviceEndpoints: [
          {
            service: 'Microsoft.Storage'
          }
          {
            service: 'Microsoft.Sql'
          }
        ]
        delegations: [
          {
            name: 'webSubnetDelegation'
            properties: {
              serviceName: 'Microsoft.Sql/managedInstances'
            }
          }
        ]
        privateEndpointNetworkPolicies: 'NetworkSecurityGroupEnabled'
      }
    ]
    tags: {
      environment: 'test'
    }
  }
}
```

## Outputs
| Name               |	Type  |	Description                         |
|--------------------|--------|-------------------------------------|
| `vnetId`	         | string	| ID of the virtual network resource  |
| `vnetName`	       | string	| Name of the virtual network         |
| `vnetLocation`	   | string	| Location of the virtual network     |