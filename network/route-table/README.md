# Azure Route Table Module

## Overview

This Bicep module deploys a **Route Table** in Azure with options for custom routes, subnet associations, and BGP route propagation settings.

- **Module Name**: route-table
- **Azure Resource**: Route Table
- **Version**: 1.0
- **Contributor**: Maxence Holvoet

## Parameters

| Name                      | Mandatory | Type   | Description                                                                | Default Value |
|---------------------------|-----------|--------|----------------------------------------------------------------------------|---------------|
| `routeTableName`          | Yes       | string | Name of the Route Table.                                                   | N/A           |
| `location`                | Yes       | string | Location/Region for the Route Table.                                       | N/A           |
| `tags`                    | No        | object | Resource group tags.                                                       | `{}`          |
| `routes`                  | No        | array  | List of custom routes. Each route requires `name`, `addressPrefix`, `nextHopType`, and optionally `nextHopIpAddress`. | `[]`          |
| `BgpRoutePropagation` | No     | bool   | Disallow propagation of routes from BGP.                                   | `false`       |

## Usage Example

Here is an example of how to use this module in a Bicep deployment.

```bicep
module azrt 'https://github.com/AzMaxH/AzBicep/blob/main/network/route-table/main.bicep' = {
  name: 'RouteTableDeployment'
  params: {
    routeTableName: 'RouteTable'
    location: 'West Europe'
    routes: [
      {
        name: 'toInternet'
        addressPrefix: '0.0.0.0/0'
        nextHopType: 'Internet'
      }
      {
        name: 'toAppliance'
        addressPrefix: '10.1.0.0/16'
        nextHopType: 'VirtualAppliance'
        nextHopIpAddress: '10.1.1.4'
      }
    ]
    tags: {
      environment: 'test'
    }
  }
}
```

## Outputs
| Name  |   Type    |   Description |
|-------|-----------|---------------|
| `routeTableId`  |   string  |   The resource ID of the deployed Route Table |
| `routeTableName`    | string    |   The name of the deployed Route Table |
| `routeTableLocation`    | string    | The location/region of the deployed Route Table   |