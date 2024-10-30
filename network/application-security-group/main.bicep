/*
Name : application-security-group
Azure Resource : Application security groups
Description : Bicep module for creating an application security group on Azure
Version : 1.0
Contributor : Maxence Holvoet
*/

// Mandatory pameters
@description('Name of the Application Security Group')
param asgName string

@description('Location/Region of the Application Security Group')
param location string

// Optional parameters
@description('Tags to be applied to all resources in this module')
param tags object = {}

// Resources creation
resource asg 'Microsoft.Network/applicationSecurityGroups@2024-01-01' = {
  name: asgName
  location: location
  tags: tags
  properties: {}
}

// Outputs
output asgId string = asg.id
