@description('The name of the storage account')
param storageName string

@description('The location for the storage account')
param location string = resourceGroup().location

@description('The SKU name for the storage account')
param skuName string = 'Standard_LRS'

resource storageAccount 'Microsoft.Storage/storageAccounts@2024-01-01' = {
  name: storageName
  location: location           // Uses the location parameter, defaults to resource group location
  sku: {
    name: skuName
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
  }
}

output storageAccountId string = storageAccount.id
