{% include variables.md %}

# Configure DNS alias to {{ site.data.var.wlsFullBrandName }}

This page documents how to configure an existing deployment of {{ site.data.var.wlsFullBrandName }} with custom DNS alias.

## Prerequisites

### Environment for Setup

* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure), use `az --version` to test if `az` works.

### WebLogic Server Instance

The DNS Configuraton ARM template will be applied to an existing {{ site.data.var.wlsFullBrandName }} instance.  If you don't have one, please create a new instance from the Azure portal, by following the link to the offer [in the index](index.md).

### Registered Domain Name

You need to buy a domain name to create custom DNS alias, which can be accessed public.

### Azure DNS Zone

Optional.

If you create the DNS alias on an existing [Azure DNS Zone](https://docs.microsoft.com/en-us/azure/dns/dns-overview), make sure you have perfomed the [Azure DNS Delegation](https://docs.microsoft.com/en-us/azure/dns/dns-domain-delegation) with the following command.

```bash
$ nslookup -type=SOA wlseng-azuretest.com
Server:         172.29.80.1
Address:        172.29.80.1#53

Non-authoritative answer:
wlseng-azuretest.com
        origin = ns1-01.azure-dns.com
        mail addr = azuredns-hostmaster.microsoft.com
        serial = 1
        refresh = 3600
        retry = 300
        expire = 2419200
        minimum = 300
Name:   ns1-01.azure-dns.com
Address: 40.90.4.1
Name:   ns1-01.azure-dns.com
Address: 2603:1061::1

Authoritative answers can be found from:
```

We will strongly recommand you to create an Azure DNS Zone for domain management and reuse it for other perpose. Follow the [guide](https://docs.microsoft.com/en-us/azure/dns/dns-getstarted-portal) to create Azure DNS Zone.

### Azure Managed Indentify

If you are going to configure DNS alias based on an existing DNS Zone, you are required to input an ID of Azure user-assigned managed identity. 

Follow this [guide](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/how-to-manage-ua-identity-portal) to create a user-assigned managed identity.

To obtain ID of the indentify: go to Azure Portal; open the identity **Overview** page; click **JSON View** and copy the **Resource ID**.


## Prepare the Parameters

We provide an automation shell script for DNS configuration. You must specify the information of the existing Oracle WebLogic Server. This section shows how to obtain the values for the following required properties.

| Parameter&nbsp;Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Explanation |
|----------------|-------------|
| `--admin-vm-name`| Required. Name of vitual machine that hosts {{ site.data.var.wlsFullBrandName }} admin server. Must be the same value provided at initial deployment time.|
| `--admin-console-label` | Required. Label for {{ site.data.var.wlsFullBrandName }} admin console. Used to generate subdomain of admin console. | 
| `--artifact-location`| Required. See below for details. |
| `--resource-group` | Required. Name of resource group that has WebLogic cluster deployed. |
| `--location ` | Required. Must be the same region into which the server was initially deployed. |
| `--zone-name ` | Required. Azure DNS Zone name. |
| `--gateway-label` | Optional. Label for applciation gateway. Used to generate subdomain of application gateway. The parameter is only required if you want to create DNS alias for application gateway.|
| `--identity-id` | Optional. ID of Azure user-assigned managed identity. The parameter is only required if you are creating DNS alias on an existing DNS Zone.|
| `--zone-resource-group` | Optional. Name of resource group that has Azure DNS Zone deployed. The parameter is only required if you are creating DNS alias on an existing DNS Zone. |
| `--help` | Help. |

### `_artifactsLocation`

This value must be the following.

```bash
{{ armTemplateBasePath }}
```

## Invoke the Automation Script

We provide automation script to configure custom DNS alias. With the script, you are allowed to 

  * If you have an Azure DNS Zone, create DNS alias  for admin console and application gateway on the existing DNS Zone.
  * If you don't have an Azure DNS Zone, create the DNS Zone in the same resource group of WebLogic cluster, and create DNS alias for admin console and application gateway.

### Configure DNS Alias on an Existing Azure DNS Zone

To configure DNS alias on an existing Azure DNS Zone, besides the required parameters, you must specify an Azure user-assigned managed identity ID, resource group name of which has your DNS Zone deployed.

This is an example to create DNS alias `admin.consoto.com` for admin console and `applciations.consoto.com` for application gateway on an existing Azure DNS Zone.

```bash
$ curl -fsSL https://raw.githubusercontent.com/wls-eng/arm-oraclelinux-wls-cluster/2020-12-02-01-Q4/cli-scripts/custom-dns-alias-cli.sh \
  | /bin/bash -s -- \
  --resource-group `yourResourceGroup` \
  --admin-vm-name adminVM \
  --admin-console-label admin \
  --artifact-location {{ armTemplateBasePath }} \
  --location eastus \
  --zone-name consoto.com \
  --gateway-label applications \
  --identity-id `yourIndentityID` \
  --zone-resource-group 'yourDNSZoneResourceGroup'
```

An example output:

```text
Done!

Custom DNS alias:
    Resource group: haiche-dns-doc
    WebLogic Server Administration Console URL: http://admin.consoto.com:7001/console
    WebLogic Server Administration Console secured URL: https://admin.consoto.com:7002/console
  

    Application Gateway URL: http://applications.consoto.com
    Application Gateway secured URL: https://applications.consoto.com
```


### Configure DNS Alias on a New Azure DNS Zone

To configure DNS alias on a new Azure DNS Zone, you must specify the required parameters.

This is an example to create an Azure DNS Zone, and create DNS alias `admin.consoto.com` for admin console and `applciations.consoto.com` for application gateway. 

```bash
$ curl -fsSL https://raw.githubusercontent.com/wls-eng/arm-oraclelinux-wls-cluster/2020-12-02-01-Q4/cli-scripts/custom-dns-alias-cli.sh \
  | /bin/bash -s -- \
  --resource-group `yourResourceGroup` \
  --admin-vm-name adminVM \
  --admin-console-label admin \
  --artifact-location {{ armTemplateBasePath }} \
  --location eastus \
  --zone-name consoto.com \
  --gateway-label applications
```

An example output:

```text
DONE!
  

Action required:
  Complete Azure DNS delegation to make the alias accessible.
  Reference: https://aka.ms/dns-domain-delegation
  Name servers:
  [
  "ns1-02.azure-dns.com.",
  "ns2-02.azure-dns.net.",
  "ns3-02.azure-dns.org.",
  "ns4-02.azure-dns.info."
  ]

Custom DNS alias:
    Resource group: haiche-dns-doc
    WebLogic Server Administration Console URL: http://admin.consoto.com:7001/console
    WebLogic Server Administration Console secured URL: https://admin.consoto.com:7002/console
  

    Application Gateway URL: http://applications.consoto.com
    Application Gateway secured URL: https://applications.consoto.com
```

**Note:** The DNS aliases are not accessible now, you must perform Azure DNS delegation after the deployment. Follow [Delegation of DNS zones with Azure DNS](https://aka.ms/dns-domain-delegation) to complete the Azure DNS delegation.


## Verify the Custome Alias

Access the URL from output to verify if the custom alias works.
