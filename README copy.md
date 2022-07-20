# Create React App on Azure Static Web Apps with Azure Developer CLI (azd)


Here's a quick sample to demo how we can quickly get a React app created with ["Create React App"](https://create-react-app.dev/) running in an Azure Static Web App with the Azure Developer CLI (azd).


## Prerequisites

Start by installing the following prerequisites or open this in the included DevContainer or Codespaces.

- [Azure CLI (v 2.38.0+)](https://docs.microsoft.com/cli/azure/install-azure-cli)
- [Node.js (v16+)](https://nodejs.org)
- [Azure Developer CLI (azd)](https://aka.ms/azure-dev/devhub)

The installation scripts can also be used to update `azd` in place. Run the script again to install the latest available version.

For advanced install scenarios see [Azure Developer CLI Installer Scripts](https://github.com/Azure/azure-dev/blob/main/cli/installer/README.md#advanced-installation-scenarios)

### Windows: 

```powershell
powershell -ex AllSigned -c "Invoke-RestMethod 'https://aka.ms/install-azd.ps1' | Invoke-Expression"
```

### MacOS/Linux: 

```bash
curl -fsSL https://aka.ms/install-azd.sh | bash
```

## Run `azd` up

The `up` command enables you to get the entire application up and running on Azure.

```
azd up -t jongio/azd-create-react-app-swa
```

You can also clone locally, open in DevContainer, or Codespaces and just run:

```
azd up
```

Once it is complete it will output a URL to the website that you can browse to.

## How does `azd` work?

Let's learn more about how `azd` works.  We'll talk about environments and what makes up an `azd` compatible template.

## Environments

An Azure Developer CLI environment contains information about an instance of your application on Azure. When you initialize an `azd` template, you provide a unique environment name, location, and Azure subscription Id. Those values get saved to a `.env` file found in `.azure/{envname}/.env`

Conventions:
1. Environments are created automatically by `azd` in the `.azure` folder.
1. The default environment is specified in the `.azure/config.json` file. This is the environment that will be used when you run commands without a `-e` flag. i.e. `azd up`
1. You can override the default environment with the `-e` flag.  i.e. `azd up -e yourenvname`.
1. You can change the default environment with the `azd env select` command.
1. You can find all environment related commands with `azd env -h`
1. The `.azure` folder should not be committed to source control as it may contain secrets. Please add `.azure` to your .gitignore file.

## `azd` Templates Explained
An `azd` compatible template is made of 3 primary artifacts, that you create.

1. Source Code (located in `src`)
1. Infrastructure Code (located in `infra`)
1. Metadata File (`azure.yaml`, located in the root of the project)



### Source Code

This is all your application source code and can be structured any way you like.

Conventions:
1. There are no required conventions to follow here.  You can put the code in any structure you like to suit your needs.
1. Code doesn't have to be located in the `src` folder, that is just a convention `azd` uses for consistency.

### Infrastructure Code

This is your code that describes your application resources.

Conventions: 
1. All infrastructure as code files must be located in a folder called `/infra`. (ability to override this coming soon)
1. Must have a file named `main.bicep` as the main entry point. (ability to override this coming soon) (overrides for this coming soon)
1. Must have a file named `main.parameters.json` for any parameters. (ability to override this coming soon)
1. By default `azd` templates use a `resources.bicep` file to define the resources the application needs. You can change that file name if you'd like. You can also organize your bicep files any way you'd like, including nesting them in subfolders or referencing bicep module repositories. Anything you can do with bicep, you can also do here.
1. By default `azd` templates provision resources at the subscription level, but the bicep can be modified to provision at the resource group level as well.
1. Bicep file outputs are automatically saved to the active environments .env file, so they can be used from within the application.  For example, if your `main.bicep` file has an output named `WEB_URI`, then `azd` will save a `WEB_URI` value to the `.env` file for the selected environment.
1. All resources are tagged with `azd-env-name` which matches the value of `AZURE_ENV_NAME` in the `.env` file.
1. Resources that you need to deploy code to, such as App Services, Static Web Apps, and Container Apps, also need to have the `azd-service-name` tag, which is equal to the service name found in the `azure.yaml` file. (more on how this works below)
1. All resource names use abbreviations defined in the [Cloud Adoption Framework abbreviations guidelines](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations).  For example, a resource could be named: `stapp-web-gq7unfkt65bpu`, the prefix `stapp-` is a recommendation pulled from that doc. 
1. All resource names include a `token` that is dynamically generated in the bicep file. This allows `azd` to use resource names that are guaranteed to be unique and compatible with [Azure naming restrictions](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/resource-name-rules). For example, a resource could be named: `stapp-web-gq7unfkt65bpu`, the suffix is a dynamically generated token. 


### Metadata File (azure.yaml)

The `azure.yaml` file tells `azd` where to find code, how to build and package it, and which Azure resource each service maps to.

Let's break down this `azure.yaml` line by line:

```yaml
name: create-react-app-azd-swa
# This is an arbitrary name of the project that you define
services:
# This is a collection of services that make up your application.
  web:
  # This is the service name. You define this value and it tells `azd` which resource to deploy the code to.  This value needs to match the `azd-service-name` tag of your target resource (see below for more details).
    project: src/my-app
    # This tells `azd` where to find the code for that service. It is relative to the root of the project
    dist: build
    # This tells `azd` where to find the compiled assets for your project. 'Create React App' outputs applications to the `build` folder, which is why this template has `dist` set to `build`.
    language: js
    # This tells `azd` which toolchain to use to build and package your application. `azd` currently supports js, python, and csharp. Java coming soon.
    host: staticwebapp
    # This tells `azd` what the target host type is, in this case `staticwebapp`. `azd` currently supports `appservice`, `staticwebapp`, `function`, and `containerapp` with more coming soon.
```

### Service Code to Azure Resource Mapping

Let's learn how `azd` determines which Azure resource to deploy code to. When you run `azd up` or `azd deploy`, `azd` will loop through all of the services found in `azure.yaml` and find the corresponding Azure resource to deploy the code to based on tags applied to the target resources.

Here's the relevant `azure.yaml` snippet that defines a service:

```yaml
services:
    web:
```

Here's the relevant `bicep` snippet that adds tags to the resource:

```yaml
resource web 'Microsoft.Web/staticSites@2021-03-01' = {
  name: 'stapp-web-${resourceNameToken}'
  tags: {
    'azd-env-name': environmentName
    'azd-service-name': 'web'
  }
}
```

When `azd` loops over the service list it will encounter a service named `web`. It now needs to find the Azure resource it should deploy that code to.  Here's the logic behind that discovery:

1. What is the service name?  `web`
1. What is the environment name? `cra-swa-001` (`   cra-swa-001` is just an example, your value will be equal to the name you gave your environment)
1. `azd` will then find an Azure resource that has the following tags:

    - `azd-env-name` = `cra-swa-001`
    - `azd-service-name` = `web`
    > If it doesn't find that resource it will fall back to looking for a resource with the following default name: `${environmentName}${serviceName}`, which in this case would be `cra-swa-001web`
1. `azd` will then use the value in the `host` property, in this case `staticwebapp` to determine how to deploy the code to that Azure resource, and then proceed with the deployment.

### Deploy an Individual Service

`azd up` will both provision your Azure resources and deploy your code to those resources.  If you want to only provision Azure resources you can call `azd provision` and if you only want to deploy the code you can call `azd deploy`.  In addition, if you only want to deploy an individual service you can call `azd deploy --service {serviceName}`, i.e. `azd deploy --service web`, to deploy only that one `web` service.

## Learn more...

There's a lot more to learn about the Azure Developer CLI (azd).  Please have a look at our doc here: https://aka.ms/azd



