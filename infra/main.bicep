targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Azure Developer environment name')
param environmentName string

@minLength(1)
@maxLength(64)
@description('Resource group name')
param resourceGroupName string

@minLength(1)
@description('Primary location for all resources')
param location string

var resourceNameToken = toLower(uniqueString(subscription().id, environmentName, location))

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
  tags: {
    'azd-env-name': environmentName
  }
}

module resources './resources.bicep' = {
  name: 'resources'
  scope: resourceGroup
  params: {
    environmentName: environmentName
    location: location
    resourceNameToken: resourceNameToken
  }
}

output WEB_URI string = resources.outputs.WEB_URI
