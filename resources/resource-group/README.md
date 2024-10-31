# Azure Resource Group Module

## Overview

This Bicep module creates a **Resource Group** on Azure with the option to add role assignments and manage locks to protect the resources.

- **Module Name**: resource-group
- **Azure Resource**: Resource Group
- **Version**: 1.0
- **Contributor**: Maxence Holvoet

## Parameters

| Name                  | Required | Type   | Description                                                                                      | Default Value |
|-----------------------|----------|--------|--------------------------------------------------------------------------------------------------|---------------|
| `resourceGroupName`   | Yes      | string | Name of the resource group to create                                                              | N/A           |
| `location`            | Yes      | string | Location/Region where the resource group should be created                                      | N/A           |
| `tags`                | No       | object | Tags to be assigned to the resource group                                                        | `{}`          |
| `LockCanNotDelete`    | No       | bool   | Protect the resource group with a delete lock                                                   | `false`       |
| `LockName`            | No       | string | Name of the lock                                                                                 | `DoNotDelete` |
| `roleAssignments`     | No       | array  | Array of role assignments to create                                                               | `[]`          |

## Usage Examples

Here are examples of how to use this module in a Bicep deployment.

### Basic Deployment Example

```bicep
module azrg 'https://github.com/AzMaxH/AzBicep/blob/main/resources/resource-group/main.bicep' = {
  name: 'resourceGroupDeployment'
  params: {
    resourceGroupName: 'myResourceGroup'
    location: 'East US'
    tags: {
      environment: 'test'
    }
    LockCanNotDelete: true
    LockName: 'DoNotDelete'
    roleAssignments: []
  }
}
```

### Deployment with Role Assignments Example

```bicep
module azrg 'https://github.com/AzMaxH/AzBicep/blob/main/resources/resource-group/main.bicep' = {
  name: 'resourceGroupWithRolesDeployment'
  params: {
    resourceGroupName: 'myResourceGroup'
    location: 'East US'
    tags: {
      environment: 'production'
    }
    LockCanNotDelete: true
    LockName: 'DoNotDelete'
    roleAssignments: [
      {
        principalId: 'fa3ba017-8753-4fb0-a323-d45b4e580b7c'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Contributor'
      }
    ]
  }
}
```

## Outputs

|   Name	                    |   Type	|   Description                             |
|-------------------------------|-----------|-------------------------------------------|
|   `resourceGroupId`	        |   string	|   ID of the created resource group        |
|   `resourceGroupNameOutput`	|   string	|   Name of the created resource group      |
|   `resourceGroupLocation`	    |   string	|   Location of the created resource group  |