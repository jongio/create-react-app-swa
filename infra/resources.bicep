param environmentName string
param location string
param resourceNameToken string

resource web 'Microsoft.Web/staticSites@2021-03-01' = {
  name: 'stapp-web-${resourceNameToken}'
  location: location
  tags: {
    'azd-env-name': environmentName
    'azd-service-name': 'web'
  }
  sku: {
    name: 'Free'
    tier: 'Free'
  }
  properties: {
    provider: 'Custom'
  }
}
