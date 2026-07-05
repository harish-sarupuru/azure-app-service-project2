# Infrastructure as Code — Project 2

This Bicep template (`main.bicep`) provisions the same resources that were
originally created by hand in the Azure Portal:

- App Service Plan (Linux, F1 Free tier)
- App Service (Python 3.12, running Gunicorn)
- Log Analytics workspace
- Application Insights (wired up to the App Service automatically)

## Why this matters

Clicking through the Portal is fine for learning, but real teams provision
infrastructure as **code** — so it's version-controlled, repeatable, and
reviewable (via pull requests) instead of a one-off manual setup that nobody
can reproduce. This is one of the most commonly expected skills for an Azure
Cloud Engineer role.

## Prerequisites

- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) installed
- Logged in: `az login`
- The right subscription selected: `az account set --subscription "<name-or-id>"`

## Deploy

```bash
# 1. Create the resource group (one-time, only if it doesn't already exist)
az group create --name rg-app-service-iac --location australiasoutheast

# 2. Preview what will be created (safe, makes no changes)
az deployment group what-if \
  --resource-group rg-app-service-iac \
  --template-file main.bicep \
  --parameters appServiceName=harish-webapp-project2-iac

# 3. Deploy for real
az deployment group create \
  --resource-group rg-app-service-iac \
  --template-file main.bicep \
  --parameters appServiceName=harish-webapp-project2-iac
```

> Note: `appServiceName` must be globally unique across all of Azure. If you
> deploy this as a second, parallel app (recommended, so you don't touch your
> already-working `harish-webapp-project2`), give it a distinct name like
> `harish-webapp-project2-iac`.

## After deploying

The App Service is created but empty — deploy your code to it the same way
as before (GitHub Actions + publish profile), or with:

```bash
az webapp deploy --resource-group rg-app-service-iac \
  --name harish-webapp-project2-iac --src-path release.zip --type zip
```

## Clean up (avoid ongoing cost)

```bash
az group delete --name rg-app-service-iac --yes --no-wait
```

## What to say in an interview

"I provisioned the App Service, its plan, and Application Insights using a
Bicep template instead of the Portal, so the whole environment is defined in
version control and can be redeployed identically with one command. I used
`what-if` to preview changes before applying them, which is how you'd safely
review infrastructure changes in a team setting."
