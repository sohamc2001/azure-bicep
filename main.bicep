targetScope = 'subscription'

@description('Name of the resource group to create')
param resourceGroupName string

@description('Location for the resource group and storage account')
param location string = 'eastus'

@description('Prefix for the storage account name (3-11 lowercase letters or numbers)')
@minLength(3)
@maxLength(11)
param storagePrefix string

// Create the resource group
resource newRG 'Microsoft.Resources/resourceGroups@2024-11-01' = {
  name: resourceGroupName
  location: location
}

// Generate a unique storage account name combining prefix and unique string based on the resource group ID
var uniqueStorageName = toLower('${storagePrefix}${uniqueString(newRG.id)}')

// Deploy the storage account module scoped to the newly created resource group
module storageModule './storageAccount.bicep' = {
  name: 'storageDeploy'
  scope: newRG
  params: {
    storageName: uniqueStorageName
    location: location  // Explicitly passing location, but module defaults to resourceGroup().location if omitted
    skuName: 'Standard_LRS'
  }
}

output resourceGroupName string = newRG.name
output storageAccountId string = storageModule.outputs.storageAccountId
