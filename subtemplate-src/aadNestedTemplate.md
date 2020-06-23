# Enable Azure Active Directory in an Existing WebLogic Server with Admin Server Instance

This article introduces how to enable Azure Active Directory (AAD) to an existing WebLogic Server, with az cli.

## Prerequisites

### Environment for Setup

* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure), use `az --version` to test if `az` works.

### WebLogic Server Instance

The AAD tempate will be applied to an existing WebLogic Server instance.  If you don't have one, please create a new instance from Azure portal, link to WebLogic offer is available from [Oracle WebLogic Server with Admin Server](https://portal.azure.com/#create/oracle.20191009-arm-oraclelinux-wls-admin20191009-arm-oraclelinux-wls-admin).  

### Azure Active Directory LDAP Instance

To apply AAD to Weblogic Server, you must have an existing Azure Active Directory LDAP instance to use. If you don't have AAD LADP instance, please follow this [document](https://docs.microsoft.com/en-us/azure/active-directory-domain-services/tutorial-configure-ldaps) to set up.

### Download Template

Download arm-oraclelinux-wls-admin-version-arm-assembly.zip from latest release. For example, the latest version is v1.0.20, download from this link: https://github.com/wls-eng/arm-oraclelinux-wls-admin/releases/download/v1.0.20/arm-oraclelinux-wls-admin-1.0.20-arm-assembly.zip.

Unzip the ARM template to your local machine, we will run nestedtemplates/aadNestedTemplate.json to enable AAD.

## Run AAD Template

We need to specify information of exsiting WebLogic Server and AAD LDAP instance, please create parameters.json with the following variables, and change the value to yours.

Please note, 

1. For `_artifactsLocation`, please use the default value, `https://raw.githubusercontent.com/wls-eng/arm-oraclelinux-wls-admin/master/src/main/arm/`.

2. For `wlsLDAPSSLCertificate`, please use base64 to encode your AAD LDAP client certificate, disable line wrapping and output to a file.  

```
base64 your-certificate.cer -w 0 >temp.txt
```

```
{
    "_artifactsLocation": {
        "value": "https://raw.githubusercontent.com/wls-eng/arm-oraclelinux-wls-admin/master/src/main/arm/"
    },
    "location": {
        "value": "<location>"
    },
    "aadsPortNumber": {
        "value": "636"
    },
    "aadsPublicIP": {
        "value": "<aad-ldap-server-ip>"
    },
    "aadsServerHost": {
        "value": "<aad-ldap-server-host>"
    },
    "adminPassword": {
        "value": "<admin-vm-password>"
    },
    "adminVMName": {
        "value": "<admin-vm-name>"
    },
    "wlsDomainName": {
        "value": "<wls-domain-name>"
    },
    "wlsLDAPGroupBaseDN": {
        "value": "<group-base-dn>"
    },
    "wlsLDAPPrincipal": {
        "value": "<principal>"
    },
    "wlsLDAPPrincipalPassword": {
        "value": "<principal-password>"
    },
    "wlsLDAPProviderName": {
        "value": "<provider-name>"
    },
    "wlsLDAPSSLCertificate": {
        "value": "<certificate-base64-string>"
    },
    "wlsLDAPUserBaseDN": {
        "value": "<user-base-dn>"
    },
    "wlsPassword": {
        "value": "<wls-psw>"
    },
    "wlsUserName": {
        "value": "<wls-user>"
    }
}
``` 

Run the following command to apply database service to your WebLogic Server.  

```
RESOURCE_GROUP=<resource-group-of-your-weblogic-server-instance>

# cd nestedtemplates
# Create parameters.json with above variables, and place it in the same folder with aadNestedTemplate.json.
az group deployment create --verbose --resource-group $RESOURCE_GROUP --name aad --parameters @parameters.json --template-file aadNestedTemplate.json
```

You will not get any error if the AAD service is deployed successfully.

This is an example output of successful deployment.  

```
{
  "id": "/subscriptions/05887623-95c5-4e50-a71c-6e1c738794e2/resourceGroups/oraclevm-admin-06082/providers/Microsoft.Resources/deployments/cli",
  "location": null,
  "name": "cli",
  "properties": {
    "correlationId": "6d98e1c8-0778-4fa5-a30a-8f10bbbb6818",
    "debugSetting": null,
    "dependencies": [
      {
        "dependsOn": [
          {
            "id": "/subscriptions/05887623-95c5-4e50-a71c-6e1c738794e2/resourceGroups/oraclevm-admin-06082/providers/Microsoft.Compute/virtualMachines/adminVM/extensions/newuserscript",
            "resourceGroup": "oraclevm-admin-06082",
            "resourceName": "adminVM/newuserscript",
            "resourceType": "Microsoft.Compute/virtualMachines/extensions"
          }
        ],
        "id": "/subscriptions/05887623-95c5-4e50-a71c-6e1c738794e2/resourceGroups/oraclevm-admin-06082/providers/Microsoft.Resources/deployments/pid-8295df19-fe6b-5745-ad24-51ef66522b24",
        "resourceGroup": "oraclevm-admin-06082",
        "resourceName": "pid-8295df19-fe6b-5745-ad24-51ef66522b24",
        "resourceType": "Microsoft.Resources/deployments"
      }
    ],
    "duration": "PT2M59.6052694S",
    "mode": "Incremental",
    "onErrorDeployment": null,
    "outputResources": [
      {
        "id": "/subscriptions/05887623-95c5-4e50-a71c-6e1c738794e2/resourceGroups/oraclevm-admin-06082/providers/Microsoft.Compute/virtualMachines/adminVM/extensions/newuserscript",
        "resourceGroup": "oraclevm-admin-06082"
      }
    ],
    "outputs": {
      "artifactsLocationPassedIn": {
        "type": "String",
        "value": "https://raw.githubusercontent.com/galiacheng/arm-oraclelinux-wls-admin/deploy/src/main/arm/"
      }
    },
    "parameters": {
      "_artifactsLocation": {
        "type": "String",
        "value": "https://raw.githubusercontent.com/galiacheng/arm-oraclelinux-wls-admin/deploy/src/main/arm/"
      },
      "_artifactsLocationAADTemplate": {
        "type": "String",
        "value": "https://raw.githubusercontent.com/galiacheng/arm-oraclelinux-wls-admin/deploy/src/main/arm/"
      },
      "_artifactsLocationSasToken": {
        "type": "SecureString"
      },
      "aadsPortNumber": {
        "type": "String",
        "value": "636"
      },
      "aadsPublicIP": {
        "type": "String",
        "value": "40.76.11.111"
      },
      "aadsServerHost": {
        "type": "String",
        "value": "ladps.wls-security.com"
      },
      "adminPassword": {
        "type": "SecureString"
      },
      "adminVMName": {
        "type": "String",
        "value": "adminVM"
      },
      "location": {
        "type": "String",
        "value": "eastus"
      },
      "wlsDomainName": {
        "type": "String",
        "value": "adminDomain"
      },
      "wlsLDAPGroupBaseDN": {
        "type": "String",
        "value": "OU=AADDC Users,DC=wls-security,DC=com"
      },
      "wlsLDAPPrincipal": {
        "type": "String",
        "value": "CN=WLSTest,OU=AADDC Users,DC=wls-security,DC=com"
      },
      "wlsLDAPPrincipalPassword": {
        "type": "SecureString"
      },
      "wlsLDAPProviderName": {
        "type": "String",
        "value": "AzureActiveDirectoryProvider"
      },
      "wlsLDAPSSLCertificate": {
        "type": "String",
        "value": "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tDQpNSUlERkRDQ0FmeWdBd0lCQWdJUVpIbnRHT3Z5RzVSRmVTVzl5TERGQVRBTkJna3Foa2lHOXcwQkFRc0ZBREFkDQpNUnN3R1FZRFZRUUREQklxTG5kc2N5MXpaV04xY21sMGVTNWpiMjB3SGhjTk1qQXdNakkzTWpNd016QTNXaGNODQpNakV3TWpJM01qTXlNekEzV2pBZE1Sc3dHUVlEVlFRRERCSXFMbmRzY3kxelpXTjFjbWwwZVM1amIyMHdnZ0VpDQpNQTBHQ1NxR1NJYjNEUUVCQVFVQUE0SUJEd0F3Z2dFS0FvSUJBUURDOG9TZ0pMWi9jdWtRNVVVTytZeCtrUzZGDQo5UVF3ditOU0FrTmZFSG1ld1V1Q0EwTnRCY0duOExYYzJNZ1VHSHJmMTNxbiszeDlkeS9GQ1U5WHRXVTJjd0UwDQppbTRMaWlxbWxQdlliVVArVGFjN1RkMUR1UHg3NVFScm8rS1hGVys1OTJpWUl6ZVNPQi9iQXNGK3JQNWRuUmMwDQo0UjdITDVtWUZOWThpWHVTUEJPUCtpUFNlWjduUmxBMEJOa1JNVmxsSXAyZ2xHZk9uY01uRlYweHdqaHcwNFNpDQpBbVFqVGE2YmJtRU5HVWdNVTFmSG5aSFVHREY0S09SQS8zc1dTckcxOHVvQjkwNzQzNTRxM3piYzZmNVRFdU9yDQp5UGNrNTA2WjNPdEd5b0JzVXFzdzFSb2ZZdDNVbDBtWWJMMDlIUzU3QmIxODVzRFNpSFZyRlF6Wm9ibkJBZ01CDQpBQUdqVURCT01BNEdBMVVkRHdFQi93UUVBd0lGb0RBZEJnTlZIU1VFRmpBVUJnZ3JCZ0VGQlFjREFnWUlLd1lCDQpCUVVIQXdFd0hRWURWUjBPQkJZRUZBeE55MUFvWXZuVVBxQXUyQ2FWcnBROE5BLy9NQTBHQ1NxR1NJYjNEUUVCDQpDd1VBQTRJQkFRQTdJclNXaXZCTkRMMmFkcGpiMnNjcmFQenRtVm9yZ2pWbWY5OTdBUzM4SUJ0R2tXZkttTHlGDQpPZUkzS0g3WFIvUDA5cDBFTDNmNDgrTUJtMnhZTDlGV3RRdlcxckhGTzdOOU5qWHFQbXpxc1ZFelNIQVBHS2JIDQpJSUh1dmFYOHZOZ1lJb2lrNk5DMHFucWhCTUlBWmJEOVlaU0g3SGhzdmRna0tFWXdaRThOY2JkaVFSTEI4Z3NEDQp4WWhWY0E0Y0h2OUR0aWFhSXZodEt3U2x0SzdwQXR1aG5IS2tUZ2VQVVVWNWJyRm5IM1FpbS9WT21SSG1qZjdODQpmTFZER005ZStFRUtwaW5ETDB3c0VLSzh1Nm9hbTRLUHdYNXo0T0ljR3VXWkdlMGJQejlHRVZOR0xyY1pTSG8vDQpHNHRoUFZ5Q0VqOURlUUJzcW05b1N6TFFNV0ZRU2xkZw0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQ0K"
      },
      "wlsLDAPUserBaseDN": {
        "type": "String",
        "value": "OU=AADDC Users,DC=wls-security,DC=com"
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
    "templateHash": "2818584196763146470",
    "templateLink": null,
    "timestamp": "2020-06-09T07:07:03.444046+00:00"
  },
  "resourceGroup": "oraclevm-admin-06082",
  "type": "Microsoft.Resources/deployments"
}

```

## Verify AAD Integration

Follow the steps to check if AAD is enabled.

* Go to WebLogic Admin Server Console,  you can find it from output of WebLogic Instance deployment.
* Go to Security Realms -> myrealm -> Providers, you will find AAD provider e.g. `AzureActiveDirectoryProvider`
* Go to Security Realms -> myrealm -> Users and Groups, you will find users from AAD provider.
* Otherwise, AAD integration fails.



