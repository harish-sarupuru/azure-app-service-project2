// ============================================================================
// Project 2 — Infrastructure as Code (Bicep)
// Provisions everything that was previously clicked together in the Azure
// Portal: an App Service Plan, a Linux App Service running Python, and
// Application Insights (+ its Log Analytics workspace) for monitoring.
//
// Scope: this template deploys INTO an existing Resource Group.
// Create the Resource Group first (one-time, see deploy commands below),
// then deploy this template into it.
// ============================================================================

@description('Name of the App Service (must be globally unique across Azure).')
param appServiceName string = 'harish-webapp-project2'

@description('Azure region for all resources.')
param location string = resourceGroup().location

@description('App Service Plan SKU. F1 = Free tier (1 app, no custom domain/SSL, 60 CPU min/day).')
@allowed([
  'F1'
  'B1'
])
param skuName string = 'F1'

@description('Python runtime version for the Linux App Service.')
param pythonVersion string = '3.12'

// --- App Service Plan (the compute that hosts the app) ---------------------
resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: 'ASP-${appServiceName}'
  location: location
  sku: {
    name: skuName
  }
  kind: 'linux'
  properties: {
    reserved: true // required for Linux plans
  }
}

// --- Log Analytics workspace (required by Application Insights) -----------
resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: '${appServiceName}-logs'
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

// --- Application Insights (monitoring / telemetry) -------------------------
resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appServiceName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalytics.id
  }
}

// --- App Service (the web app itself) --------------------------------------
resource appService 'Microsoft.Web/sites@2023-12-01' = {
  name: appServiceName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'PYTHON|${pythonVersion}'
      appCommandLine: 'gunicorn --bind=0.0.0.0 --timeout 600 app:app'
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsights.properties.InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsights.properties.ConnectionString
        }
        {
          name: 'SCM_DO_BUILD_DURING_DEPLOYMENT'
          value: 'true'
        }
      ]
    }
  }
}

// --- Outputs ----------------------------------------------------------------
output appServiceUrl string = 'https://${appService.properties.defaultHostName}'
output appServiceName string = appService.name
output appInsightsName string = appInsights.name
