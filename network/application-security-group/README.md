# Azure Application Security Group (ASG) Module

## Overview

This Bicep module deploys an **Application Security Group (ASG)** in Azure. ASGs are used to configure and manage network security rules in a way that simplifies the administration of VM security.

- **Module Name**: application-security-group
- **Azure Resource**: Application Security Group (ASG)
- **Version**: 1.0
- **Contributor**: Maxence Holvoet

## Parameters

| Name       | Mandatory | Type   | Description                                                | Default Value |
|------------|-----------|--------|------------------------------------------------------------|---------------|
| `asgName`  | Yes       | string | Name of the Application Security Group.                    | N/A           |
| `location` | Yes       | string | The Azure Region to deploy the ASG.                        | N/A           |
| `tags`     | No        | object | Tags to be applied to all resources in this module.        | `{}`          |

## Usage Example

Here is an example of how to use this module in a Bicep deployment.

```bicep
module azasg 'https://github.com/AzMaxH/AzBicep/blob/main/network/application-security-group/main.bicep' = {
  name: 'AsgDeployment'
  params: {
    asgName: 'myAppSecurityGroup'
    location: 'North Europe'
    tags: {
      environment: 'test'
    }
  }
}
```

## Outputs
|Name   |   Type    |   Description |
|-------|-----------|---------------|
| `id`  |   string  |   The resource ID of the deployed ASG |