param location string
param resourceToken string
param tags object

resource web 'Microsoft.Web/staticSites@2021-03-01' = {
  name: 'stapp-web-${resourceToken}'
  location: location
  tags: union(tags, {
      'azd-service-name': 'web'
    })
  sku: {
    name: 'Free'
    tier: 'Free'
  }
  properties: {
    provider: 'Custom'
  }
}
