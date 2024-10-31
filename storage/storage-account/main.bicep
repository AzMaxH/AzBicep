/*
Name : storage-account
Azure Resource : Storage Account
Description : Bicep module for creating a storage account on Azure
Version : 1.0
Contributor : Maxence Holvoet
*/

// Mandatory parameters
@description('Name of the storage account')
@maxLength(24)
param storageAccountName string

@description('Location/Region of the storage account')
param location string

// Optional parameters
@description('Tags to be assigned to the resources')
param tags object = {}

@description('Type of storage account')
@allowed([
  'Storage'
  'StorageV2'
  'BlobStorage'
  'FileStorage'
  'BlockBlobStorage'
])
param kind string = 'StorageV2'

@description('SKU of the storage account')
@allowed([
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GRS'
  'Standard_GZRS'
  'Standard_LRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
  'Standard_ZRS' 
])
param skuName string = 'Standard_LRS'

@description('Access tier used for billing blob storage')
@allowed([
  'Premium'
  'Hot'
  'Cool'
])
param accessTier string = 'Hot'

@description('Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key')
param allowSharedKeyAccess bool = false

@description('Allow or disallow cross AAD tenant object replication')
param allowCrossTenantReplication bool = false

@description('Enables or disables the hierarchical namespace for the Blob service')
param blobServiceHierarchicalNamespaceEnabled bool = false

@description('Enables or disables Secure File Transfer Protocol (SFTP) for the Blob service')
param blobServiceSftpEnabled bool = false

@description('Enables or disables NFSv3 support for the Blob service')
param blobServiceNfsV3Enabled bool = false

@description('Enables or disables public network access for the storage account')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Disabled'

@description('Specifies a list of IP ranges to allow access')
param allowedIpRanges array = []

@description('Specifies a list of subnet IDs to allow access')
param allowedSubnetIds array = []

@description('Defines the SMB file shares to create')
param smbFileShares smbFileShareDefinition[] = []

@description('Defines the NFS file shares to create')
param nfsFileShares nfsFileShareDefinition[] = []

// User Defined Types
type smbFileShareDefinition = {
  @minLength(3)
  @maxLength(63)
  name: string

  @minValue(1)
  @maxValue(5120)
  quotaGB: int
}

type nfsRootSquashValues = 'AllSquash' | 'NoRootSquash' | 'RootSquash'

type nfsFileShareDefinition = {
  @minLength(3)
  @maxLength(63)
  name: string

  @minValue(100)
  @maxValue(102400)
  quotaGB: int

  rootSquash: nfsRootSquashValues
}

// Variables
var supportsBlobService = kind == 'BlockBlobStorage' || kind == 'BlobStorage' || kind == 'StorageV2' || kind == 'Storage'
var supportsFileService = kind == 'FileStorage' || kind == 'StorageV2' || kind == 'Storage'
var supportsNFSFileShare = kind == 'FileStorage' && (skuName == 'Premium_LRS' || skuName == 'Premium_ZRS')

var effectivePublicNetworkAccess = (length(allowedIpRanges) > 0 || length(allowedSubnetIds) > 0) ? 'Enabled' : publicNetworkAccess

// Resources creation
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: location
  kind: kind
  sku: {
    name: skuName
  }
  tags: tags

  properties: {
    accessTier: kind == 'BlobStorage' ? accessTier : null
    allowBlobPublicAccess: false
    allowCrossTenantReplication: allowCrossTenantReplication
    allowSharedKeyAccess: allowSharedKeyAccess
    encryption: {
      keySource: 'Microsoft.Storage'
      services: {
        blob: supportsBlobService ? {
          enabled: true
        } : null
        file: supportsFileService ? {
          enabled: true
        } : null
        table: {
          enabled: true
        }
        queue: {
          enabled: true
        }
      }
      requireInfrastructureEncryption: kind != 'Storage'
    }
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: [for iprange in allowedIpRanges: {
        action: 'Allow'
        value: iprange
      }]
      virtualNetworkRules: [for subnetId in allowedSubnetIds: {
        action: 'Allow'
        id: subnetId
      }]
    }
    publicNetworkAccess: effectivePublicNetworkAccess
    supportsHttpsTrafficOnly: length(nfsFileShares) > 0 ? false : true
    isHnsEnabled: supportsBlobService ? (blobServiceHierarchicalNamespaceEnabled || blobServiceSftpEnabled || blobServiceNfsV3Enabled) : null
    isSftpEnabled: supportsBlobService ? blobServiceSftpEnabled : null
    isNfsV3Enabled: supportsBlobService ? blobServiceNfsV3Enabled : null
  }

  resource blobServices 'blobServices' = if (supportsBlobService) {
    name: 'default'
    properties: {
      containerDeleteRetentionPolicy: {
        days: 7
        enabled: true
      }
      deleteRetentionPolicy: {
        days: 7
        enabled: true
      }
    }
  }

  resource fileServices 'fileServices' = if (supportsFileService) {
    name: 'default'
    properties: {
      shareDeleteRetentionPolicy: {
        days: 7
        enabled: true
      }
    }
  }
}

resource saSMBFileShares 'Microsoft.Storage/storageAccounts/fileServices/shares@2023-01-01' = [for fs in smbFileShares: if (supportsNFSFileShare == false) {
  name: fs.name
  parent: storageAccount::fileServices
  properties: {
    enabledProtocols: 'SMB'
    shareQuota: fs.quotaGB
  }
}]

resource saNFSFileShares 'Microsoft.Storage/storageAccounts/fileServices/shares@2023-01-01' = [for fs in nfsFileShares: if (supportsNFSFileShare) {
  name: fs.name
  parent: storageAccount::fileServices
  properties: {
    enabledProtocols: 'NFS'
    rootSquash: fs.?rootSquash ?? 'NoRootSquash'
    shareQuota: fs.quotaGB
  }
}]

// Outputs
output id string = storageAccount.id
output name string = storageAccount.name
