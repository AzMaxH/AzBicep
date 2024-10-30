/*
Name : route-table
Azure Resource : Route Table
Description : Bicep module for creating a route table in Azure
Version : 1.0
Contributor : Maxence Holvoet
*/

// Mandatory parameters
@description('The name of the Route Table')
param routeTableName string

@description('Location/Region of the Route Table')
param location string

// Optional parameters
@description('Resource group tags')
param tags object = {}

@description('List of route configurations for the route table')
param routes array = []

@description('Allow or disallow the propagation of routes from BGP')
param BgpRoutePropagation bool = false

// Resources creation
resource routeTable 'Microsoft.Network/routeTables@2024-01-01' = {
  name: routeTableName
  location: location
  properties: {
    disableBgpRoutePropagation: BgpRoutePropagation
    routes: [
      for route in routes: {
        name: route.name
        properties: {
          addressPrefix: route.addressPrefix
          nextHopType: route.nextHopType
          nextHopIpAddress: route.?nextHopIpAddress ?? null
        }
      }
    ]
  }
  tags: tags
}

// Outputs
output routeTableId string = routeTable.id
output routeTableName string = routeTable.name
output routeTableLocation string = location
