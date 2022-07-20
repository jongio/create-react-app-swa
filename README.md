# Create React App on Azure Static Web Apps with Azure Developer CLI (azd)


Here's a quick sample to demo how we can quickly get a React app running in an Azure Static Web App with the Azure Developer CLI (azd).


## Prerequisites
- [Git](https://git-scm.com/)
- [GitHub CLI v2.3+](https://github.com/cli/cli)
- [Azure CLI (v 2.38.0+)](https://docs.microsoft.com/cli/azure/install-azure-cli)
- [Node.js (v16+)](https://nodejs.org)
- [Azure Developer CLI (azd)](https://aka.ms/azure-dev/devhub)

The installation scripts can also be used to update `azd` in place. Run the script again to install the latest available version.

For advanced install scenarios see [Azure Developer CLI Installer Scripts](https://github.com/Azure/azure-dev/blob/main/cli/installer/README.md#advanced-installation-scenarios)

Windows: 

```powershell
powershell -ex AllSigned -c "Invoke-RestMethod 'https://aka.ms/install-azd.ps1' | Invoke-Expression"
```

MacOS/Linux: 

```bash
curl -fsSL https://aka.ms/install-azd.sh | bash
```

## Run azd up

With the Azure Developer CLI's up command, you can get the entire application up and running on Azure with a single command:

```
azd up -t jongio/azd-create-react-app-swa
```

You can also clone locally, open in DevContainer, or Codespaces and just run:

```
azd up
```

## Learn more...

There's a lot more to learn about the Azure Developer CLI (azd).  Please have a look at our doc here: https://aka.ms/azd



