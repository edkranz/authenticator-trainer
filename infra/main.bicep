targetScope = 'subscription'

@description('Location for all resources')
param location string = 'eastus2'

@description('Name of the resource group')
param resourceGroupName string = 'rg-authenticator-trainer'

@description('Name of the Static Web App')
param staticWebAppName string = 'auth-trainer'

resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
}

module staticWebApp 'staticWebApp.bicep' = {
  name: 'staticWebAppDeploy'
  scope: rg
  params: {
    name: staticWebAppName
    location: location
  }
}

output staticWebAppName string = staticWebApp.outputs.name
output defaultHostname string = staticWebApp.outputs.defaultHostname
output deploymentToken string = staticWebApp.outputs.deploymentToken
