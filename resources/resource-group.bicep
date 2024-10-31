/*
Name : resource-group
Azure Resource : Resource Group
Description : Bicep module for creating a resource group on Azure
Version : 1.0
Contributor : Maxence Holvoet
*/

// Type of resource to be deployed at subscription level
targetScope = 'subscription'

// Mandatory parameters
@description('The name of the Resource Group to create')
param resourceGroupName string

@description('The location/region where the Resource Group should be created')
param location string

// Optional parameters
@description('Tags to be assigned to the Resource Group')
param tags object = {}

@description('Protect resource group with a Delete lock')
param LockCanNotDelete bool = false

@description('Delete lock name')
param LockName string = 'DoNotDelete'

@description('Array of role assignments')
param roleAssignments array = []

// Resource creation
resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}

module lock 'modules/lock.bicep' = if (LockCanNotDelete == true) {
  name: '${resourceGroupName}-lock'
  params: {
    LockName: LockName
  }
  scope: resourceGroup
}

module resourceGroup_roleAssignments 'modules/roleAssignments.bicep' = if (!empty(roleAssignments ?? [])) {
  name: '${uniqueString(deployment().name, location)}-RG-RoleAssignments'
  params: {
    roleAssignments: roleAssignments
  }
  scope: resourceGroup
}

// Outputs
output resourceGroupId string = resourceGroup.id
output resourceGroupNameOutput string = resourceGroup.name
output resourceGroupLocation string = resourceGroup.location
