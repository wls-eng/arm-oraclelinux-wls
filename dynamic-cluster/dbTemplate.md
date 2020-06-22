# Apply Database Template to WebLogic Server with Admin Server Instance

This article introduces how to apply database template with az cli to an existing WebLogic Server.

## Prerequisites

### Environment for Setup

* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure), use `az --version` to test if `az` works.

### WebLogic Server Instance

The database tempate will be applied to an existing WebLogic Server instance.  If you don't have one, please create a new instance from Azure portal, link to WebLogic offer is available from [Oracle WebLogic Server with Admin Server](https://portal.azure.com/#create/oracle.20191009-arm-oraclelinux-wls-admin20191009-arm-oraclelinux-wls-admin).  

### Database Instance

To apply database to Weblogic Server, you must have an existing database instance to use. Three kinds of database are available now, Oracle, SQL Server, and Postgresql. If you do not have an instance, please create from Azure portal.

### Download Template

Download arm-oraclelinux-wls-admin-version-arm-assembly.zip from latest release. For example, the latest version is v1.0.20, download from this link: https://github.com/wls-eng/arm-oraclelinux-wls-admin/releases/download/v1.0.20/arm-oraclelinux-wls-admin-1.0.20-arm-assembly.zip.

Unzip the ARM template to your local machine, we will run nestedtemplates/dbTemplate.json to connect to database for WebLogic Server.

## Run Database Template

We need to specify information of exsiting WebLogic Server and database instance, please create parameters.json with the following variables, and change the value to yours.

Please note, 

1. For `dsConnectionURL`, the portal will give you a string like this:

```
jdbc:postgresql://ejb042302p.postgres.database.azure.com:5432/{your_database}?user=postgres@ejb042302p&password={your_password}&sslmode=require
```

But you have to strip some things out, it needs to be like this:

```
jdbc:postgresql://ejb042302p.postgres.database.azure.com:5432/postgres?sslmode=require 
```

2. For `_artifactsLocation`, please use the default value, `https://raw.githubusercontent.com/wls-eng/arm-oraclelinux-wls-admin/master/src/main/arm/`.

```
{
    "_artifactsLocation":{
        "value": "https://raw.githubusercontent.com/wls-eng/arm-oraclelinux-wls-admin/master/src/main/arm/"
      },
      "location": {
        "value": "<location>"
      },
      "databaseType": {
        "value": "<db-type>"
      },
      "dsConnectionURL": {
        "value": "<ds-string>"
      },
      "dbPassword": {
        "value": "<db-psw>"
      },
      "dbUser": {
        "value": "<db-user>"
      },
      "jdbcDataSourceName": {
        "value": "<jdbc-name>"
      },
      "wlsPassword": {
        "value": "<wls-psw>"
      },
      "wlsUserName": {
        "value": "<wls-user>"
      },
      "adminVMName":{
        "value": "<admin-vm-name>"
      }
    }
``` 

Run the following command to apply database service to your WebLogic Server.  

```
RESOURCE_GROUP=<resource-group-of-your-weblogic-server-instance>

# cd nestedtemplates
# Create parameters.json with above variables, and place it in the same folder with dbTemplate.json.
az group deployment create --verbose --resource-group $RESOURCE_GROUP --name db --parameters @parameters.json --template-file dbTemplate.json
```

You will not get any error if the database service is deployed successfully.

This is an example output of successful deployment.  

```
{
  "id": "/subscriptions/05887623-95c5-4e50-a71c-6e1c738794e2/resourceGroups/oraclevm-admin-0602/providers/Microsoft.Resources/deployments/db",
  "location": null,
  "name": "db",
  "properties": {
    "correlationId": "6fc805b9-1c47-4b32-b9b0-59745a21e559",
    "debugSetting": null,
    "dependencies": [
      {
        "dependsOn": [
          {
            "id": "/subscriptions/05887623-95c5-4e50-a71c-6e1c738794e2/resourceGroups/oraclevm-admin-0602/providers/Microsoft.Compute/virtualMachines/adminVM/extensions/newuserscript",
            "resourceGroup": "oraclevm-admin-0602",
            "resourceName": "adminVM/newuserscript",
            "resourceType": "Microsoft.Compute/virtualMachines/extensions"
          }
        ],
        "id": "/subscriptions/05887623-95c5-4e50-a71c-6e1c738794e2/resourceGroups/oraclevm-admin-0602/providers/Microsoft.Resources/deployments/3b35b279-0e94-5264-85f5-0d9d662f8a38",
        "resourceGroup": "oraclevm-admin-0602",
        "resourceName": "3b35b279-0e94-5264-85f5-0d9d662f8a38",
        "resourceType": "Microsoft.Resources/deployments"
      }
    ],
    "duration": "PT17.4377546S",
    "mode": "Incremental",
    "onErrorDeployment": null,
    "outputResources": [
      {
        "id": "/subscriptions/05887623-95c5-4e50-a71c-6e1c738794e2/resourceGroups/oraclevm-admin-0602/providers/Microsoft.Compute/virtualMachines/adminVM/extensions/newuserscript",
        "resourceGroup": "oraclevm-admin-0602"
      }
    ],
    "outputs": {
      "artifactsLocationPassedIn": {
        "type": "String",
        "value": "https://raw.githubusercontent.com/wls-eng/arm-oraclelinux-wls-admin/master/src/main/arm/"
      }
    },
    "parameters": {
      "_artifactsLocation": {
        "type": "String",
        "value": "https://raw.githubusercontent.com/wls-eng/arm-oraclelinux-wls-admin/master/src/main/arm/"
      },
      "_artifactsLocationDbTemplate": {
        "type": "String",
        "value": "https://raw.githubusercontent.com/wls-eng/arm-oraclelinux-wls-admin/master/src/main/arm/"
      }
      "adminVMName": {
        "type": "String",
        "value": "adminVM"
      },
      "databaseType": {
        "type": "String",
        "value": "postgresql"
      },
      "dbPassword": {
        "type": "SecureString"
      },
      "dbUser": {
        "type": "String",
        "value": "weblogic@oraclevm"
      },
      "dsConnectionURL": {
        "type": "String",
        "value": "jdbc:postgresql://oraclevm.postgres.database.azure.com:5432/postgres"
      },
      "jdbcDataSourceName": {
        "type": "String",
        "value": "jdbc/WebLogicCafeDB"
      },
      "location": {
        "type": "String",
        "value": "eastus"
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
    "templateHash": "6381424766408193665",
    "templateLink": null,
    "timestamp": "2020-06-02T06:05:03.141828+00:00"
  },
  "resourceGroup": "oraclevm-admin-0602",
  "type": "Microsoft.Resources/deployments"
}

```

## Verify Database Connection

Follow the steps to check if AAD is enabled.

* Go to WebLogic Admin Server Console,  you can find it from output of WebLogic Instance deployment.
* Go to Services -> DataSources
* Click JDBC database name, e.g. `jdbc/WebLogicDB`
* Click Monitoring -> Testing
* Select `admin` and click "Test Data Source"
* If the database is enbaled, you will get message like "Test of jdbc/WebLogicDB on server admin was successful."


