# Set up Application Gateway to WebLogic Server Cluster Instance

This article introduces how to set up application gateway to an existing WebLogic Server cluster instance.

## Prerequisites

### Environment for Setup

* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure), use `az --version` to test if `az` works.

### WebLogic Server Instance

The applciation gateway tempate will be applied to an existing WebLogic Server cluster instance.  If you don't have one, please create a new instance from Azure portal, link to WebLogic offer is available from [Oracle WebLogic Server Cluster](https://portal.azure.com/#create/oracle.20191007-arm-oraclelinux-wls-cluster20191007-arm-oraclelinux-wls-cluster).  

### Download Template

Download arm-oraclelinux-wls-admin-version-arm-assembly.zip from latest release, e.g. now, the latest version is v1.0.20, download from this link: https://github.com/wls-eng/arm-oraclelinux-wls-cluster/releases/download/v1.0.20/arm-oraclelinux-wls-cluster-1.0.20-arm-assembly.zip.

Unzip the ARM template to your local machine, we will run nestedtemplates/appGatewayNestedTemplate.json to set up application gateway.

## Run Allication Gateway Template

We need to specify information of exsiting WebLogic Server and application gateway, please create parameters.json with the following variables, and change the value to yours.

First, use base64 to encode your application gateway certificate, and output to a file.  

```
base64 your-certificate.pfx -w 0 >temp.txt
```
Please note:

`_artifactsLocation`: please keep the vaule.  
`appGatewaySSLCertificateData`: must be base64 encode string, please disable line wrapping.

```
{
    "_artifactsLocation":{
        "value": "https://raw.githubusercontent.com/wls-eng/arm-oraclelinux-wls-cluster/master/arm-oraclelinux-wls-cluster/src/main/arm/"
    },
    "location": {
        "value": "eastus"
    },
    "adminVMName": {
        "value": "<admin-vm-name>"
    },
    "appGatewaySSLCertificateData": {
        "value": "<base64-code-of-certificate>"
    },
    "appGatewaySSLCertificatePassword": {
        "value": "<certificate-password>"
    },
    "dnsNameforApplicationGateway": {
        "value": "<agw-dns-name>"
    },
    "gatewayPublicIPAddressName": {
        "value": "<agw-public-ip-name>"
    },
    "managedServerPrefix": {
        "value": "<prefix-managed-server>"
    },
    "numberOfInstances": {
        "value": <instance-num>
    },
    "wlsDomainName": {
        "value": "<wls-domain-name>"
    },
    "wlsPassword": {
        "value": "<wls-psw>"
    },
    "wlsUserName": {
        "value": "<wls-user>"
    }
}
``` 

Replace the following parameters and run the command to set up application gateway to your WebLogic Server cluster.  

```
RESOURCE_GROUP=<resource-group-of-your-weblogic-server-instance>

# cd nestedtemplates
# Create parameters.json with above variables, and place it in the same folder with appGatewayNestedTemplate.json.
az group deployment create --verbose --resource-group $RESOURCE_GROUP --name agw --parameters @parameters.json --template-file appGatewayNestedTemplate.json
```

You will not get any error if application gateway is deployed successfully.

This is an example output of successful deployment.  

```
{
  "id": "/subscriptions/05887623-95c5-4e50-a71c-6e1c738794e2/resourceGroups/oraclevm-cluster-0604/providers/Microsoft.Resources/deployments/cli",
  "location": null,
  "name": "cli",
  "properties": {
    "correlationId": "4cc63f27-0f43-4244-9d89-a09bf417e943",
    "debugSetting": null,
    "dependencies": [
      {
        "dependsOn": [
          {
            "id": "/subscriptions/05887623-95c5-4e50-a71c-6e1c738794e2/resourceGroups/oraclevm-cluster-0604/providers/Microsoft.Network/publicIPAddresses/gwip",
            "resourceGroup": "oraclevm-cluster-0604",
            "resourceName": "gwip",
            "resourceType": "Microsoft.Network/publicIPAddresses"
          }
        ],
        "id": "/subscriptions/05887623-95c5-4e50-a71c-6e1c738794e2/resourceGroups/oraclevm-cluster-0604/providers/Microsoft.Network/applicationGateways/myAppGateway",
        "resourceGroup": "oraclevm-cluster-0604",
        "resourceName": "myAppGateway",
        "resourceType": "Microsoft.Network/applicationGateways"
      },
      {
        "dependsOn": [
          {
            "id": "/subscriptions/05887623-95c5-4e50-a71c-6e1c738794e2/resourceGroups/oraclevm-cluster-0604/providers/Microsoft.Network/applicationGateways/myAppGateway",
            "resourceGroup": "oraclevm-cluster-0604",
            "resourceName": "myAppGateway",
            "resourceType": "Microsoft.Network/applicationGateways"
          },
          {
            "apiVersion": "2019-11-01",
            "id": "/subscriptions/05887623-95c5-4e50-a71c-6e1c738794e2/resourceGroups/oraclevm-cluster-0604/providers/Microsoft.Network/publicIPAddresses/gwip",
            "resourceGroup": "oraclevm-cluster-0604",
            "resourceName": "gwip",
            "resourceType": "Microsoft.Network/publicIPAddresses"
          }
        ],
        "id": "/subscriptions/05887623-95c5-4e50-a71c-6e1c738794e2/resourceGroups/oraclevm-cluster-0604/providers/Microsoft.Compute/virtualMachines/adminVM/extensions/newuserscript",
        "resourceGroup": "oraclevm-cluster-0604",
        "resourceName": "adminVM/newuserscript",
        "resourceType": "Microsoft.Compute/virtualMachines/extensions"
      },
      {
        "dependsOn": [
          {
            "id": "/subscriptions/05887623-95c5-4e50-a71c-6e1c738794e2/resourceGroups/oraclevm-cluster-0604/providers/Microsoft.Compute/virtualMachines/adminVM/extensions/newuserscript",
            "resourceGroup": "oraclevm-cluster-0604",
            "resourceName": "adminVM/newuserscript",
            "resourceType": "Microsoft.Compute/virtualMachines/extensions"
          }
        ],
        "id": "/subscriptions/05887623-95c5-4e50-a71c-6e1c738794e2/resourceGroups/oraclevm-cluster-0604/providers/Microsoft.Resources/deployments/pid-36deb858-08fe-5c07-bc77-ba957a59a080",
        "resourceGroup": "oraclevm-cluster-0604",
        "resourceName": "pid-36deb858-08fe-5c07-bc77-ba957a59a080",
        "resourceType": "Microsoft.Resources/deployments"
      }
    ],
    "duration": "PT8M41.2104793S",
    "mode": "Incremental",
    "onErrorDeployment": null,
    "outputResources": [
      {
        "id": "/subscriptions/05887623-95c5-4e50-a71c-6e1c738794e2/resourceGroups/oraclevm-cluster-0604/providers/Microsoft.Compute/virtualMachines/adminVM/extensions/newuserscript",
        "resourceGroup": "oraclevm-cluster-0604"
      },
      {
        "id": "/subscriptions/05887623-95c5-4e50-a71c-6e1c738794e2/resourceGroups/oraclevm-cluster-0604/providers/Microsoft.Network/applicationGateways/myAppGateway",
        "resourceGroup": "oraclevm-cluster-0604"
      },
      {
        "id": "/subscriptions/05887623-95c5-4e50-a71c-6e1c738794e2/resourceGroups/oraclevm-cluster-0604/providers/Microsoft.Network/publicIPAddresses/gwip",
        "resourceGroup": "oraclevm-cluster-0604"
      }
    ],
    "outputs": {
      "appGatewayURL": {
        "type": "String",
        "value": "http://wlsgw9e6ed1-oraclevm-cluster-0604-wlsd.eastus.cloudapp.azure.com"
      }
    },
    "parameters": {
      "_artifactsLocation": {
        "type": "String",
        "value": "https://raw.githubusercontent.com/galiacheng/arm-oraclelinux-wls-cluster/deploy/arm-oraclelinux-wls-cluster/src/main/arm/"
      },
      "_artifactsLocationAGWTemplate": {
        "type": "String",
        "value": "https://raw.githubusercontent.com/galiacheng/arm-oraclelinux-wls-cluster/deploy/arm-oraclelinux-wls-cluster/src/main/arm/"
      },
      "_artifactsLocationSasToken": {
        "type": "SecureString"
      },
      "adminVMName": {
        "type": "String",
        "value": "adminVM"
      },
      "appGatewaySSLCertificateData": {
        "type": "String",
        "value": "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"
      },
      "appGatewaySSLCertificatePassword": {
        "type": "String",
        "value": "wlsEng@aug2019"
      },
      "dnsNameforApplicationGateway": {
        "type": "String",
        "value": "wlsgw"
      },
      "gatewayPublicIPAddressName": {
        "type": "String",
        "value": "gwip"
      },
      "guidValue": {
        "type": "String",
        "value": "9e6ed15b-d386-4cb9-a617-3cb6f785f6a0"
      },
      "location": {
        "type": "String",
        "value": "eastus"
      },
      "managedServerPrefix": {
        "type": "String",
        "value": "msp"
      },
      "numberOfInstances": {
        "type": "Int",
        "value": 4
      },
      "wlsDomainName": {
        "type": "String",
        "value": "wlsd"
      },
      "wlsPassword": {
        "type": "SecureString"
      },
      "wlsUserName": {
        "type": "String",
        "value": "weblogic"
      }
    },
    "parametersLink": null,
    "providers": [
      {
        "id": null,
        "namespace": "Microsoft.Resources",
        "registrationPolicy": null,
        "registrationState": null,
        "resourceTypes": [
          {
            "aliases": null,
            "apiVersions": null,
            "capabilities": null,
            "locations": [
              null
            ],
            "properties": null,
            "resourceType": "deployments"
          }
        ]
      },
      {
        "id": null,
        "namespace": "Microsoft.Network",
        "registrationPolicy": null,
        "registrationState": null,
        "resourceTypes": [
          {
            "aliases": null,
            "apiVersions": null,
            "capabilities": null,
            "locations": [
              "eastus"
            ],
            "properties": null,
            "resourceType": "publicIPAddresses"
          },
          {
            "aliases": null,
            "apiVersions": null,
            "capabilities": null,
            "locations": [
              "eastus"
            ],
            "properties": null,
            "resourceType": "applicationGateways"
          }
        ]
      },
      {
        "id": null,
        "namespace": "Microsoft.Compute",
        "registrationPolicy": null,
        "registrationState": null,
        "resourceTypes": [
          {
            "aliases": null,
            "apiVersions": null,
            "capabilities": null,
            "locations": [
              "eastus"
            ],
            "properties": null,
            "resourceType": "virtualMachines/extensions"
          }
        ]
      }
    ],
    "provisioningState": "Succeeded",
    "template": null,
    "templateHash": "12239709219097081949",
    "templateLink": null,
    "timestamp": "2020-06-04T03:17:01.168329+00:00"
  },
  "resourceGroup": "oraclevm-cluster-0604",
  "type": "Microsoft.Resources/deployments"
}

```

## Verify Application Gateway
We will deploy a testing application to verify if the appliaction gateway is enabled.  
Go to Admin Server Console and deploy [webtestapp.war](../resources/webtestapp.war).  

* Go to admin server console, click "Lock & Edit"
* Click Deployments
* Click Install
* Select file webtestapp.war
* Next. Install this deployment as an application
* Next. Select cluster-1 and All servers in the cluster
* Keep configuration as default and click Finish
* Activate Changes 

* Go to Deplyments
* Click Control
* Select webtestapp
* Start
* Servicing all requests

Then access the application with `<appGatewayHost>/webtestapp`, you will get a page with server host information if application gateway enables.