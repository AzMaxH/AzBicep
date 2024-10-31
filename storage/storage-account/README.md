# Azure Storage Account Module

## Overview

This Bicep module creates an **Azure Storage Account** with advanced configuration options for storage services, access tiers, and other related settings.

- **Module Name**: storage-account
- **Azure Resource**: Storage Account
- **Version**: 1.0
- **Contributor**: Maxence Holvoet

## Parameters

| Name                       | Required | Type   | Description                                                                           | Default Value |
|----------------------------|----------|--------|---------------------------------------------------------------------------------------|---------------|
| `storageAccountName`       | Yes      | string | Name of the storage account to create                                                 | N/A           |
| `location`                 | Yes      | string | Azure region where the resources will be created                                      | N/A           |
| `tags`                     | No       | object | Standard tags to be applied to all resources                                         | `{}`          |
| `kind`                     | No       | string | Type of storage account to create (e.g., Storage, StorageV2, BlobStorage, etc.)     | `StorageV2`   |
| `skuName`                  | No       | string | SKU name of the storage account                                                       | `Standard_LRS`|
| `accessTier`               | No       | string | Access tier used for billing of block blob access                                    | `Hot`         |
| `allowSharedKeyAccess`     | No       | bool   | Allow or disallow requests to be authorized with the account access key via Shared Key| `false`       |
| `allowCrossTenantReplication` | No    | bool   | Allow or disallow cross-tenant object replication                                     | `false`       |
| `blobServiceHierarchicalNamespaceEnabled` | No | bool | Enable or disable the Blob Service Hierarchical Namespace                             | `false`       |
| `blobServiceSftpEnabled`   | No      | bool   | Enable or disable Secure File Transfer Protocol (SFTP) for the Blob Service          | `false`       |
| `blobServiceNfsV3Enabled`  | No      | bool   | Enable or disable NFSv3 for Blob Service                                             | `false`       |
| `publicNetworkAccess`      | No       | string | Allow or disallow public network access to the storage account                        | `Disabled`    |
| `allowedIpRanges`          | No       | array  | List of IP ranges to grant access to                                                  | `[]`          |
| `allowedSubnetIds`         | No       | array  | List of Subnet IDs to grant access to                                                 | `[]`          |
| `smbFileShares`            | No       | array  | List of SMB file share definitions                                                     | `[]`          |
| `nfsFileShares`            | No       | array  | List of NFS file share definitions                                                     | `[]`          |

## Usage Examples

Here are examples of how to use this module in a Bicep deployment.

### Basic Deployment Example

```bicep
module azstorageaccount 'https://github.com/AzMaxH/AzBicepModules/blob/main/storage/storage-account/main.bicep' = {
  name: 'storageAccountDeployment'
  params: {
    storageAccountName: 'mystorageaccount'
    location: 'West Europe'
    tags: {
      environment: 'test'
    }
  }
}
```

### Advanced Deployment Example (NFS File Share )

```bicep
module azstorageaccount 'https://github.com/AzMaxH/AzBicepModules/blob/main/storage/storage-account/main.bicep' = {
  name: 'storageAccountDeployment'
  params: {
    storageAccountName: 'mystorageaccount'
    location: 'West Europe'
    kind: 'FileStorage'
    skuName: 'Premium_LRS'
    allowedSubnetIds: [
      '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Network/virtualNetworks/{vnetName}/subnets/{subnetName}'
    ]
    nfsFileShares: [
      {
        name: 'nfs-share'
        quotaGB: 1024
        rootSquash: 'NoRootSquash'
      }
    ]
    tags: {
      environment: 'test'
    }
  }
}

```

## Outputs

|  Name	 |   Type	|   Description                 |
|--------|----------|-------------------------------|
| `id`	 |   string	|   ID of the storage account   |
| `name` |   string	|   Name of the storage account | 