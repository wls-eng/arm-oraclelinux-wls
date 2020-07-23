{% include variables.md %}

# Delete nodes from {{ site.data.var.wlsFullBrandName }}

This page documents how to configure an existing deployment of {{ site.data.var.wlsFullBrandName }} to delete nodes using Azure CLI.

## Prerequisites

### Environment for Setup

* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure), use `az --version` to test if `az` works.

### WebLogic Server Instance

The template will be applied to an existing {{ site.data.var.wlsFullBrandName }} instance.  If you don't have one, please create a new instance from the Azure portal, by following the link to the offer [in the index](index.md).

## Prepare the Parameters JSON file

You must construct a parameters JSON file containing the parameters to the database ARM template.  See [Create Resource Manager parameter file](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/parameter-files) for background information about parameter files.   You must specify the information of the existing {{ site.data.var.wlsFullBrandName }} and nodes that to be deleted. This section shows how to obtain the values for the following required properties.

| Parameter Name | Explanation |
|----------------|-------------|
| `_artifactsLocation`| See below for details. |
| `adminVMName`| At deployment time, if this value was changed from its default value, the value used at deployment time must be used.  Otherwise, this parameter should be omitted. |
| `deletingManagedServerMachineNames`| The resource names of Azure Virtual Machine hosting managed nodes that you want to delete. |
| `wlsPassword` | Must be the same value provided at deployment time. |
| `wlsUserName` | Must be the same value provided at deployment time. |

### `_artifactsLocation`

This value must be the following.

```bash
{{ armTemplateDeleteNodeBasePath }}
```

### `deletingManagedServerMachineNames`

This value must be array, for example: ["mspVM1", "mspVM2"].

You can get the server names from WebLogic Server Administration Console, following the steps:

* Go to WebLogic Server Administration Console, http://admin-host:7001/console.

* Go to **Environment** -> **Machines**.

  Open the machine you want to delete.

  Click **Configuration** -> **Node Manager**, you will get compute name from **Listen Address**. 

 The Azure Virtual Machine name was set with the same value of compute name during {{ site.data.var.wlsFullBrandName }} deployment.

#### Example Parameters JSON

Here is a fully filled out parameters file.   Note that here did not include `adminVMName`.

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "_artifactsLocation":{
            "value": "{{ armTemplateDeleteNodeBasePath }}"
          },
          "deletingManagedServerMachineNames": {
            "value": ["mspVM1"]
          },
        "wlsPassword": {
          "value": "welcome1"
        },
        "wlsUserName": {
          "value": "weblogic"
        }
    }
}
```

## Invoke the delete-node script

To delete managed nodes completely, you have to delete managed nodes logically from WebLogic Server instance, and physically release Azure resources that host the managed nodes.  We realize the two purposes in different ways:
  * Delete machines logically from WebLogic Server instance by deploying delete-node ARM template with Azure CLI. You have to specify the parameters file.
    The cluster will restart after deleting the machines, and manages servers may be reallocated to another existing machine.
  * Release corresponding Azure resources by running Azure CLI commands. The following resources will be removed:
    * Virtual Machines that host managed nodes that will be deleted.
    * Data disks attached to the Virtual Machines
    * OS disks attached to the Virtual Machines
    * Network Interfaces added to the Virtual Machines
    * Public IPs attached to the Virtual Machines

We have provided an automation script for above two purposes, you can delete managed nodes easily with the following instructions.

### Download the script

After running the following command, you will get a shell script with name `deletenode-cli.sh`.

```bash
$ curl -LO {{ armTemplateDeleteNodeBasePath }}scripts/deletenode-cli.sh
```

Usage of the script:

```bash
$ ./deletenode-cli.sh -h
usage: deletenode-cli.sh -g resource-group [-f template-file] [-u template-url] -p paramter-file [-h]
  -g Azure Resource Group of the Vitural Machines that host deleting manages servers, must be specified.
  -f Path of ARM template to delete nodes, must be specified -f option or -u option.
  -u URL of ARM template, must be specified -f option or -u option.
  -p Path of ARM parameter, must be specified.
  -h Help

```

### Invoke the script

Assume your parameters file is available in the current directory and is named `parameters.json`.  Replace `yourResourceGroup` with the Azure resource group in which the {{ site.data.var.wlsFullBrandName }} is deployed.

```bash
$ ./deletenode-cli.sh -g yourResourceGroup -u {{ armTemplateDeleteNodeBasePath }}arm/mainTemplate.json -p parameters.json
```

The script will validate the template with your parameters file; deploy the template to delete managed servers from WebLogic Server cluster; run Azure CLI commands to delete corresponding Azure resources.

Before deleting any Azure resources, the script will prompt up to ask you to comfirm resource ids that will be deleted, and delete these resources if you input `Y/y`, otherwise, keep the resource and exit.

This is an example output of successful deployment, the  {{ site.data.var.wlsFullBrandName }} is deployed with Application Gateway.  Look for `Completed!` in your output.

```bash
$ ./deletenode-cli.sh -g yourResourceGroup -u {{ armTemplateDeleteNodeBasePath }}arm/mainTemplate.json -p parameters.json
{
  "error": null,
  "id": "/subscriptions/685ba005-af8d-4b04-8f16-a7bf38b2eb5a/resourceGroups/oraclevm-dcluster-07222/providers/Microsoft.Resources/deployments/mainTemplate",
  "name": "mainTemplate",
  "properties": {
    "correlationId": "be24f5de-1fdf-4fc6-be97-ac53af3ccd3c",
    "debugSetting": null,
    "dependencies": [
      {
        "dependsOn": [
          {
            "id": "/subscriptions/685ba005-af8d-4b04-8f16-a7bf38b2eb5a/resourceGroups/oraclevm-dcluster-07222/providers/Microsoft.Compute/virtualMachines/adminVM/extensions/newuserscript",
            "resourceGroup": "oraclevm-dcluster-07222",
            "resourceName": "adminVM/newuserscript",
            "resourceType": "Microsoft.Compute/virtualMachines/extensions"
          }
        ],
        "id": "/subscriptions/685ba005-af8d-4b04-8f16-a7bf38b2eb5a/resourceGroups/oraclevm-dcluster-07222/providers/Microsoft.Resources/deployments/pid-db9aa5e4-1e77-5f54-af38-9a7515cd27ab",
        "resourceGroup": "oraclevm-dcluster-07222",
        "resourceName": "pid-db9aa5e4-1e77-5f54-af38-9a7515cd27ab",
        "resourceType": "Microsoft.Resources/deployments"
      }
    ],
    "duration": "PT0S",
    "mode": "Incremental",
    "onErrorDeployment": null,
    "outputs": null,
    "parameters": {
      "_artifactsLocation": {
        "type": "String",
        "value": "{{ armTemplateDeleteNodeBasePath }}"
      },
      "_artifactsLocationSasToken": {
        "type": "SecureString"
      },
      "adminVMName": {
        "type": "String",
        "value": "adminVM"
      },
      "deletingManagedServerMachineNames": {
        "type": "Array",
        "value": [
          "mspVM1"
        ]
      },
      "location": {
        "type": "String",
        "value": "eastus"
      },
      "wlsForceShutDown": {
        "type": "String",
        "value": "true"
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
    "templateHash": "17905048512558945100",
    "templateLink": {
      "contentVersion": "1.0.0.0",
      "uri": "{{ armTemplateDeleteNodeBasePath }}arm/mainTemplate.json"
    },
    "timestamp": "2020-07-23T08:36:10.953240+00:00",
    "validatedResources": [
      {
        "id": "/subscriptions/685ba005-af8d-4b04-8f16-a7bf38b2eb5a/resourceGroups/oraclevm-dcluster-07222/providers/Microsoft.Resources/deployments/pid-a816a607-eb8a-5aa1-9475-c3fba6994679",
        "resourceGroup": "oraclevm-dcluster-07222"
      },
      {
        "id": "/subscriptions/685ba005-af8d-4b04-8f16-a7bf38b2eb5a/resourceGroups/oraclevm-dcluster-07222/providers/Microsoft.Compute/virtualMachines/adminVM/extensions/newuserscript",
        "resourceGroup": "oraclevm-dcluster-07222"
      },
      {
        "id": "/subscriptions/685ba005-af8d-4b04-8f16-a7bf38b2eb5a/resourceGroups/oraclevm-dcluster-07222/providers/Microsoft.Resources/deployments/pid-db9aa5e4-1e77-5f54-af38-9a7515cd27ab",
        "resourceGroup": "oraclevm-dcluster-07222"
      }
    ]
  },
  "resourceGroup": "oraclevm-dcluster-07222",
  "type": "Microsoft.Resources/deployments"
}
Command ran in 46.180 seconds (init: 0.064, invoke: 46.116)
Extension 'resource-graph' is already installed.
List resource Ids to be deleted: 
/subscriptions/685ba005-af8d-4b04-8f16-a7bf38b2eb5a/resourceGroups/oraclevm-dcluster-07222/providers/Microsoft.Compute/virtualMachines/mspVM1
/subscriptions/685ba005-af8d-4b04-8f16-a7bf38b2eb5a/resourceGroups/oraclevm-dcluster-07222/providers/Microsoft.Network/networkInterfaces/mspVM1NIC
/subscriptions/685ba005-af8d-4b04-8f16-a7bf38b2eb5a/resourceGroups/oraclevm-dcluster-07222/providers/Microsoft.Network/publicIPAddresses/mspVM1PublicIP
/subscriptions/685ba005-af8d-4b04-8f16-a7bf38b2eb5a/resourceGroups/ORACLEVM-DCLUSTER-07222/providers/Microsoft.Compute/disks/mspVM1_OsDisk_1_e490d8e72ef14081aea596eab709efef
/subscriptions/685ba005-af8d-4b04-8f16-a7bf38b2eb5a/resourceGroups/ORACLEVM-DCLUSTER-07222/providers/Microsoft.Compute/disks/mspVM1_lun_0_2_bb9f86a391c34e2d8dbe3b1b408d4952
Are you sure to delete these resources (y/n)?y
Deleting managed resources...Please do not stop.
[
  null,
  null,
  null,
  null,
  null
]
Command ran in 99.764 seconds (init: 0.068, invoke: 99.696)

Complete!
```

## Verify

### Verify if the managed servers are deleted from WebLogic Server instance.

* Go to the {{ site.data.var.wlsFullBrandName }} Administration Console.
* Go to Environment -> Machines.

  You should see the logical machine names (e.g. `machine-mspVM1`) that have been deleted is not listed in "Name" column.

### Verify if the Azure resources are deleted

* Go to Azure Portal, https://ms.portal.azure.com/.
* Go to resource group that the {{ site.data.var.wlsFullBrandName }} is deployed.

  You should see corresponding Vitual Machines, Disks, Network Interfaces, Public IPs have been removed.

  For example, I want to delete managed server `msp1`, corresponding Virtual Machine name is `mspVM1`, Azure resource names are:
    * Virtual Machine: `mspVM1`
    * Data Disk: `mspVM1_lun_0_2_9d41e2c965744665adb6965625c20d9a`
    * OS Disk: `mspVM1_OsDisk_1_05a8d81f5d01419a97ee17a45f974dca`
    * Network Interface: `mspVM1_NIC`
    * Public IP: `mspVM1_PublicIP`

  All of these resource should be deleted after the script finishes.

 
