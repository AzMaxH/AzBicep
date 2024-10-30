/*
Name : network-security-group
Azure Resource : Network Security Group (NSG)
Description : Bicep module for creating a Network Security Group on Azure, with support Application Security Groups (ASG)
Version : 1.0
Contributor : Maxence Holvoet
*/

// Mandatory parameters
@description('Name of the Network Security Group')
param nsgName string

@description('Location/Region of the Network Security Group')
param location string

// Non mandatory parameters
@description('Tags to be assigned to the Network Security Group')
param tags object = {}

@description('List of inbound security rules for the Network Security Group')
param inboundRules array = []

@description('List of outbound security rules for the Network Security Group')
param outboundRules array = []

// Resource creation
resource nsg 'Microsoft.Network/networkSecurityGroups@2024-01-01' = {
  name: nsgName
  location: location
  tags: tags
}

resource nsgInboundRules 'Microsoft.Network/networkSecurityGroups/securityRules@2024-01-01' = [for rule in inboundRules: {
  name: rule.name
  parent: nsg
  properties: {
    direction: 'Inbound'
    description: rule.description
    priority: rule.priority
    access: rule.access
    protocol: rule.protocol
    sourceApplicationSecurityGroups: rule.?sourceApplicationSecurityGroups ?? []
    sourceAddressPrefix: rule.?sourceAddressPrefix ?? null
    sourceAddressPrefixes: rule.?sourceAddressPrefixes ?? []
    sourcePortRange: rule.?sourcePortRange ?? null
    sourcePortRanges: rule.?sourcePortRanges ?? []
    destinationApplicationSecurityGroups: rule.?destinationApplicationSecurityGroups ?? []
    destinationAddressPrefix: rule.?destinationAddressPrefix ?? null
    destinationAddressPrefixes: rule.?destinationAddressPrefixes ?? []
    destinationPortRange: rule.?destinationPortRange ?? null
    destinationPortRanges: rule.?destinationPortRanges ?? []
  }
}]

resource nsgOutboundRules 'Microsoft.Network/networkSecurityGroups/securityRules@2024-01-01' = [for rule in outboundRules: {
  name: rule.name
  parent: nsg
  properties: {
    direction: 'Outbound'
    description: rule.description
    priority: rule.priority
    access: rule.access
    protocol: rule.protocol
    sourceApplicationSecurityGroups: rule.?sourceApplicationSecurityGroups ?? []
    sourceAddressPrefix: rule.?sourceAddressPrefix ?? null
    sourceAddressPrefixes: rule.?sourceAddressPrefixes ?? []
    sourcePortRange: rule.?sourcePortRange ?? null
    sourcePortRanges: rule.?sourcePortRanges ?? []
    destinationAddressPrefix: rule.?destinationAddressPrefix ?? null
    destinationAddressPrefixes: rule.?destinationAddressPrefixes ?? []
    destinationPortRange: rule.?destinationPortRange ?? null
    destinationPortRanges: rule.?destinationPortRanges ?? []
  }
}]
  
// Outputs
output nsgId string = nsg.id
output nsgName string = nsg.name
output nsgLocation string = location
