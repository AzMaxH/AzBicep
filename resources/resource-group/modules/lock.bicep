/*
Name : lock
Azure Resource : Resource Group
Description : Bicep module for creating a lock on a resource group on Azure
Version : 1.0
Contributor : Maxence Holvoet
*/

// Mandatory parameters
param LockName string

// Resource creation
resource lock 'Microsoft.Authorization/locks@2020-05-01' = {
  name: LockName
  properties: {
    level: 'CanNotDelete'
    notes: 'Lock to prevent resource group and its resources from being deleted'
  }
}
