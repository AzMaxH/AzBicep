# Azure Network Security Group (NSG) Module with ASG Support

## Overview

This Bicep module deploys a **Network Security Group (NSG)** in Azure, with support for **Application Security Groups (ASG)**. You can define inbound and outbound security rules using ASGs to group and manage your resources.

- **Module Name**: network-security-group
- **Azure Resource**: Network Security Group (NSG)
- **Version**: 1.0
- **Contributor**: Maxence Holvoet

## Parameters

| Name           | Mandatory | Type   | Description                                                                                     | Default Value       | Example                                       |
|----------------|-----------|--------|-------------------------------------------------------------------------------------------------|---------------------|-----------------------------------------------|
| `location`     | Yes       | string | Location/Region of the Network Security Group                                                   | N/A                 | `East US`                                    |
| `nsgName`      | Yes       | string | Name of the Network Security Group                                                              | N/A                 | `myNSG`                                      |
| `tags`         | No        | object | Tags to be assigned to the Network Security Group                                               | `{}`                | `{ environment: 'Prod' }`                    |
| `inboundRules` | No        | array  | List of inbound security rules for the Network Security Group                                   | `[]`                |  |
| `outboundRules`| No        | array  | List of outbound security rules for the Network Security Group                                  | `[]`                |  |

## Security Rules Configuration

### Inbound Rules Example
Here is an example of how to use this module in a Bicep deployment.

```bicep
module aznsg 'https://github.com/AzMaxH/AzBicep/blob/main/network/network-security-group/main.bicep' = {
  name: 'NsgDeployment'
  params: {
    nsgName: 'NSG'
    location: 'North Europe'
    tags: {
      environment: 'test'
    }
    inboundRules: [
      {
        access: 'Allow'
        name: 'AllowAzureLoadBalancer'
        description: 'Allow traffic from Azure LoadBalancer'
        protocol: 'Tcp'
        priority: 100
        sourceAddressPrefix: 'AzureLoadBalancer'
        sourcePortRange: '443'
        destinationAddressPrefix: '*'
        destinationPortRange: '443'
        
      }
    ]
    outboundRules: [
      {
        access: 'Deny'
        name: 'DenyOutboundToInternet'
        description: 'Deny outbound traffic to Internet'
        protocol: 'Tcp'
        priority: 200
        sourceAddressPrefix: '*'
        sourcePortRange: '*'
        destinationAddressPrefix: 'Internet'
        destinationPortRange: '*'
      }
    ]
  }
}
```

## Outputs
|Name | Type  | Description |
|-----|-------|-------------|
| `nsgId` | string  | The resource ID of the deployed Network Security Group  |
| `nsgName` | string  | The name of the deployed Network Security Group |
| `nsgLocation` | string  | The location/region of the deployed Network Security Group  |