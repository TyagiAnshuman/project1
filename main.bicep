param cosmosDBAccountName string = 'toyrnd-${uniqueString(resourceGroup().id)}'
param cosmosDBDatabaseThroughoutput int = 400
var cosmosDBDatabaseName = 'FlightTests'
var cosmosDBContainerName = 'FlightTests'
var cosmosDBContainerpartitionKey = '/droneId'
param location string = resourceGroup().location
resource cosmosDBAccountName 'Microsoft.DocumentDB/databaseAccounts@2020-04-01' = {
  name : cosmosDBAccountName
  location: location
  properties: {
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: location
      }
      
    ]
  }
}

resource cosmosDBDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2020-04-01' = {
  parent: cosmosDBAccount
  name: cosmosDBDatabaseName
  properties: {
    resource: {
      id: cosmosDBDatabaseName
    }
    options: {
      throughput: cosmosDBDatabaseThroughput
    }
  }
  resource container 'containers' = {
    name: cosmosDBContainerName
    properties: {
      resource: {
        id: cosmosDBContainerName
        partitionKey: {
          kind : 'Hash'
          paths: [
            cosmosDBContainerpartitionKey
          ]
        }
      }
      options: {}
    }
  }
}
