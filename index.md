---
title:  "Using WebLogic Server (Oracle Linux x86-64) on {{ site.data.var.azureFullBrandName }}"
metatags: refresh
---

# Using {{ site.data.var.wlsFullBrandName }} (Oracle Linux x86-64) on {{ site.data.var.azureFullBrandName }}
{:.no_toc}

## Oracle® Fusion Middleware
{:.no_toc}

Using {{ site.data.var.wlsFullBrandName }} on {{ site.data.var.azureFullBrandName }} (Oracle Linux x86-64) {{ site.data.var.brandNameNumber }} ({{ site.data.var.versionOr }})

{{ site.data.var.partNumber }}

{{ site.data.var.publicationDate }}

This document describes how to configure and use {{ site.data.var.wlsFullBrandName }} on {{ site.data.var.azureFullBrandName }}.

It includes the following topics:

{% include toc.html %}

# Introduction

Oracle is committed to enabling you to embrace cloud computing by providing greater choice and flexibility in how you deploy Oracle software. In support of that commitment, Oracle has created several ready-to-deploy [Azure Applications](https://docs.microsoft.com/en-us/azure/marketplace/marketplace-solution-templates) in the Azure Marketplace that include pre-installed Oracle software. You can use these applications to easily create virtual machines in your Azure environment and run your applications on Oracle software.

This document describes how to use the Oracle {{ site.data.var.wlsFullBrandName }} {{ site.data.var.brandNameNumber }} Azure applications on {{ site.data.var.azureFullBrandName }}. You can find these and related offers in the [Azure Marketplace](https://azuremarketplace.microsoft.com/) by searching for Oracle WebLogic.

The Azure applications include the following products pre-installed:

* Oracle {{ site.data.var.wlsFullBrandName }} {{ site.data.var.versionOr }}

* {{ site.data.var.jdkVersion }}

* Oracle Linux {{ site.data.var.oracleLinuxVersion }}

When you create an Azure application based on the {{ site.data.var.wlsFullBrandName }} {{ site.data.var.brandNameNumber }} image, you use it just as you would use it on an on-premise virtual or physical machine. All of the configuration and management tooling is available. 

These applications are "Bring Your Own License" (BYOL).  Note that you must have an appropriate license to run Oracle software. See the following links for more information:

Oracle Fusion Middleware Licensing:

[http://docs.oracle.com/middleware/1212/core/FMWLC/index.html](http://docs.oracle.com/middleware/1212/core/FMWLC/index.html)

End User License Agreement for Oracle Products on Azure:

[http://www.oracle.com/technetwork/licenses/oracle-license-2016066.html](http://www.oracle.com/technetwork/licenses/oracle-license-2016066.html)

In addition, refer to your agreement with Oracle for details on software that you are licensed to use.

# Related Documentation

For related documentation, access the following URLs:

{{ site.data.var.azureFullBrandName }} Documentation

[https://docs.microsoft.com/en-us/azure/virtual-machines/](https://docs.microsoft.com/en-us/azure/virtual-machines/)

{{ site.data.var.wlsFullBrandName }} {{ site.data.var.versionOr }} online documentation library:

[https://docs.oracle.com/middleware/12213/wls/index.html](https://docs.oracle.com/middleware/12213/wls/index.html)

# {{ site.data.var.wlsFullBrandName }} on Azure IaaS Offers

This section documents aspects that are common to all of the {{
site.data.var.wlsFullBrandName }} on Azure IaaS Offers.  Following this
section are details that are specific to each of the individual {{
site.data.var.wlsFullBrandName }} offers.

## Accessing the VMs via SSH

For each of the offers documented here, after the offer has been
provisioned, you may SSH into the VM using the credentials you defined
on the "Credentials" blade during offer creation.  This section
documents how log in to any of the provisioned VMs via SSH.

** Note ** Depending on the security rules in your Azure subscription,
you may need to expose port 22, or whitelist the IP from which you are
initiating the SSH connection.  See [the Azure
documentation](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/nsg-quickstart-portal)
for instructions to do this.

1. In [https://portal.azure.com/](https://portal.azure.com/), visit the
   resource group for the offer.  This is the value that you entered in
   the "Basics" blade during offer creation.  
   
   a. Click on the [hamburger button](https://en.wikipedia.org/wiki/Hamburger_button) 
      in the side of the Azure portal.
   
   b. In the "Filter by name" text area type the resource group from the
      "Basics" blade.
      
   c. Find and click on the desired resource group 
   
2. Depending on the offer, you will see different quantities and
   varieties of resources in the resource group.
   
   ![Deployed Resource]({{ site.url }}/arm-oraclelinux-wls/assets/deployed-resource-01.PNG "Deployed Resource")   
   
3. Click on the desired Virtual machine type resource.  You can click on
   the "Type" column header to sort the rows by type, making it easier
   to locate the Virtual machine.  This brings you to the details pane for the
   Virtual machine.  Here you can see many useful metrics about the
   health and status of the VM.
   
4. On the Virtual machine details pane, click on the clipboard icon next to 
   the value of the "DNS name" field, as shown next.
   
   ![VM DNS address]({{ site.url }}/arm-oraclelinux-wls/assets/vm-dns-address.PNG "VM DNS address")
   
   This will cause the hostname to be copied to the clipboard.
   
5. Using an SSH client of your choice, and the credentials you gave for
   the admin account of the vm, ssh into the VM host.  For example.
   
   ```
   ssh weblogic@wls101401.eastus.cloudapp.azure.com
   [weblogic@WebLogicServerVM ~]$ pwd
   /home/weblogic
   [weblogic@WebLogicServerVM ~]$
   ```
   
6. Some of the directories will be only accessible to the `root` user.
   In this case, you can become root with the sudo command, as shown
   next.
   
   ```
   [weblogic@WebLogicServerVM wls]$ sudo su -

   We trust you have received the usual lecture from the local System
   Administrator. It usually boils down to these three things:

       #1) Respect the privacy of others.
       #2) Think before you type.
       #3) With great power comes great responsibility.

   [sudo] password for weblogic:
   [root@WebLogicServerVM ~]#
   ```   
   
## Accessing the Admin Console

For offers that start the Admin GUI, the steps in this section describe
how to access it.

1. Find and provision the appropriate offer as described elswhere [in
   this document](#finding-and-selecting-an-offer).

2. Follow the steps in [Accessing the VM via
   SSH](#accessing-the-vms-via-ssh) up to and including copying the DNS
   name to the clipboard.
   
3. Open a new browser tab and visit `http://<dnsname>:7001/console`.

4. Log in with the credentials you defined on the "Credentials" blade
during offer creation.

## WebLogic Server Virtual Machine Directory Structure

The following table shows the Oracle-specific directory structure for
each virtual machine that is created using the {{
site.data.var.wlsFullBrandName }} {{ site.data.var.versionOr }} Azure
applications. When referring to Oracle WebLogic Server documentation,
substitute these paths for the directory variables in the documentation.

| Directory Variable | Purpose | Directory Path |
|--------------------|---------|----------------|
| ORACLE_HOME        | Oracle home directory | /u01/app/wls/install/Oracle/Middleware/Oracle_Home |
| WL_HOME            | {{ site.data.var.wlsFullBrandName }} home directory | ${ORACLE_HOME}/wlserver |
| JAVA_HOME          | Java home directory | /u01/app/jdk/{{ site.data.var.jdkVersionNumber }} |

## Finding and selecting an offer

Oracle publishes several offers in the Azure marketplace, allowing you
to easily install and run Oracle software on Azure.  This document is
only concerned with Oracle WebLogic Server.

1. Visit
   [https://azuremarketplace.microsoft.com/en-us](https://azuremarketplace.microsoft.com/en-us)
   and sign in with your Azure credentials.  If you don't yet have an
   Azure account, you can sign up at
   [https://azure.microsoft.com/account/sign_up](https://azure.microsoft.com/account/sign_up).
   
2. In the search box at the top of the page, enter "Oracle {{
   site.data.var.wlsFullBrandName }} {{ site.data.var.versionOr }}.  The
   search results will include hits for a wide variety of offers, make
   sure to select the one that corresponds to the correct version of {{
   site.data.var.wlsFullBrandName }} for your needs.

   ![Marketplace Offer]({{ site.url }}/arm-oraclelinux-wls/assets/marketplace-offer-01.PNG "Marketplace Offer")

3. Click on the link "Get it now".  This will take you to the chosen offer,
   as shown next.  The actual page will like different depending on the
   chosen offer.

   ![Marketplace Offer]({{ site.url }}/arm-oraclelinux-wls/assets/marketplace-offer-02.PNG "Marketplace Offer")

   This page will have links, screenshots, and videos demonstrating the
   capabilities of the chosen offer.

4. When you are ready to proceed with the installation, click on "GET IT
   NOW".  You may be required at this point to enter some profile
   information.
   
   ![Marketplace Offer]({{ site.url }}/arm-oraclelinux-wls/assets/marketplace-offer-03.PNG "Marketplace Offer")   

   Once you have filled in the values, you will be able to click
   "Continue".  You may have to do additional authentication actions as
   the system takes you from the marketplace to the Azure portal.
   
5. There will be one more "Create" button to press before you finally
   get to the steps where you fill in the values to create the 
   {{ site.data.var.wlsFullBrandName }} instance(s).

Continue by following the instructions for your specific chosen offer.
There is a table of contents at the top of this page.

## {{ site.data.var.wlsFullBrandName }} Single Node Offers

The offers documented in this section provision a single Azure Oracle
Linux {{ site.data.var.oracleLinuxVersion }} VM and install {{
site.data.var.wlsFullBrandName }} and its required dependencies on it.
Before following the steps in this section, please follow the steps
above, [that pertain to all the offers in this
document](#finding-and-selecting-an-offer).

### {{ site.data.var.wlsFullBrandName }} Single Node with No Admin Server

This offer provisions a single VM and installs {{
site.data.var.wlsFullBrandName }} {{ site.data.var.versionOr }} on it.
It does not create a domain or start up the admin server.  With this
offer, you must SSH into the VM [as shown
above](#accessing-the-vms-via-ssh) and follow the steps in [Creating
WebLogic Domains Using WLST
Offline](https://docs.oracle.com/en/middleware/fusion-middleware/12.2.1.3/wlstg/domains.html#GUID-5FC3AA22-BCB0-4F98-801A-8EBC5E05DC6A).

[The following offer](#weblogic-server-single-node-with-admin-server)
automatically creates a domain and starts the admin server, so it is
much easier to use than this offer.

The remainder of the steps in this section must be executed after
following the steps [that pertain to all the offers in this
document](#finding-and-selecting-an-offer)

The Azure portal uses a UI concept called a "[resource
blades](https://azure.microsoft.com/en-us/blog/announcing-azure-preview-portal-improvements/)".
These are similar to tab panels, but can cascade across the page flow.

#### Basics Blade

The first blade in any Azure application is the "Basics" blade.

{% include dnsLabelPrefix.md %}

{% include subscription.md %}

{% include resourceGroup.md %}

{% include location.md %}

The completed Basics blade is shown next.

![Single Node Basics]({{ site.url }}/arm-oraclelinux-wls/assets/single-01-basics.PNG "Single Node Basics")

Click "OK" to proceed to the next blade.

#### Virtual Machine Settings Blade

This blade has only one control, the Virtual machine size chooser.
Sizing your VMs is an important choice, but is beyond the scope of this
document.  Please see the [Azure documentation on
Sizes](https://docs.microsoft.com/en-us/azure/cloud-services/cloud-services-sizes-specs)
for more details.  For this example, we will choose A3 Standard and
click "Select".

![A3 Standard]({{ site.url }}/arm-oraclelinux-wls/assets/single-02-size.PNG "A3 Standard")

Then click "OK"

#### Credentials for Server Creation Blade

This blade lets you fill out various credentials necessary to provision
the VM.

{% include credentials.md %}

5. Click Ok.

#### Summary Blade

{% include summary.md %}

![Summary breadcrumbs]({{ site.url }}/arm-oraclelinux-wls/assets/single-03-breadcrumbs.PNG "Summary breadcrumbs")

#### Buy Blade

{% include buy.md %}

### {{ site.data.var.wlsFullBrandName }} Single Node with Admin Server

This offer provisions a single VM and installs {{
site.data.var.wlsFullBrandName }} {{ site.data.var.versionOr }} on it.
It creates a domain and starts up the admin server.  The admin server is
set to automatically start when the VM starts.  After provisioning is
complete, the Admin server is available at HTTP port and path
`:7001/console` and HTTPS port and path `:7002/console`.  Note that
HTTPS SSL Certificate management is not handled by the offer and must be
configured after installation.  Please see [the Oracle
documentation](https://docs.oracle.com/middleware/12213/wls/SECMG/identity_trust.htm#SECMG365)
for details on how to configure the certificates and keystores.

#### Basics Blade

The Basics blade is exactly the same [as the preceding offer](#weblogic-server-single-node-with-no-admin-server) with one additional parameter.

* WebLogic Domain Name.  This value is the name of the domain that will
  be created by the offer.

#### Virtual Machine Settings Blade

The Virtual Machine Settings blade is exactly the same [as the preceding offer](#weblogic-server-single-node-with-no-admin-server).

#### Credentials for Offer Creation Blade

This blade lets you fill out various credentials necessary to provision
the VM.

{% include credentials.md %}

5. Username and password for WebLogic Administrator.  This credential is
   for access to the WebLogic admin console, which is automatically
   started as described at the start of this section.  The
   administration console is documented in the [WebLogic
   documentation](https://docs.oracle.com/middleware/12213/wls/INTRO/adminconsole.htm#INTRO146).
   
6. Click "OK".

#### Summary Blade

The summary blade is functionally the same as in the [as the preceding
offer](#weblogic-server-single-node-with-no-admin-server), but the
template is different because it contains the logic to provision and
start the admin server.

#### Buy Blade

The buy blade is exactly the same [as the preceding offer](#weblogic-server-single-node-with-no-admin-server).

## {{ site.data.var.wlsFullBrandName }} Cluster Offers

The offers documented in this section provision several Azure Oracle
Linux {{ site.data.var.oracleLinuxVersion }} VMs and install {{
site.data.var.wlsFullBrandName }} and its required dependencies on them.
These VMs are configured to automatically form a {{
site.data.var.wlsFullBrandName }} cluster and are set to start
automatically when the VMs start.  Before following the steps in this
section, please follow the steps above, [that pertain to all the offers
in this document](#finding-and-selecting-an-offer).

### {{ site.data.var.wlsFullBrandName }} N-Node Cluster

This offer creates a highly available cluster of {{
site.data.var.wlsFullBrandName }} VMs.  Please refer to the
documentation [for details on {{ site.data.var.wlsFullBrandName }}
Clustering](https://docs.oracle.com/middleware/12213/wls/INTRO/clustering.htm#INTRO185).

#### Basics Blade

The Basics blade is almost the same [as the preceding
offer](#weblogic-server-single-node-with-no-admin-server).  It has two
additional parameters.

* Managed Server Prefix.  This value is prepended to the VM names of
  each of the nodes in the cluster.  

* Number of VMs.  This value allows you to choose how many VMs will be
  created to form the cluster.

#### Virtual Machine Settings Blade

The Virtual Machine Settings blade is exactly the same [as the first offer](#weblogic-server-single-node-with-no-admin-server).

#### Credentials for Cluster Creation Blade

The Credentials for Cluster Creation blade is exactly the same [as the preceding offer](#weblogic-server-single-node-with-admin-server).

#### Summary Blade

The summary blade is functionally the same as in the [as the preceding
offer](#weblogic-server-single-node-with-no-admin-server), but the
template is different because it contains the logic to provision the
cluster and start the admin server.

#### Buy Blade

The buy blade is exactly the same [as the first offer](#weblogic-server-single-node-with-no-admin-server).

### {{ site.data.var.wlsFullBrandName }} N-Node Dynamic Cluster

This offer creates a highly available and scalable dynamic cluster of {{
site.data.var.wlsFullBrandName }} VMs.  Please refer to the
documentation [for details on {{ site.data.var.wlsFullBrandName }}
Dynamic Clustering](https://docs.oracle.com/middleware/12213/wls/ELAST/overview.htm#ELAST510).  

#### Basics Blade

The Basics blade is almost the same [as the preceding
offer](#weblogic-server-n-node-cluster).  It no Number of VMs parameter.
Rather, it has two additional parameters.

* Maximum Dynamic Cluster Size.  This is the maximum number of {{
  site.data.var.wlsFullBrandName }} nodes that will be available for
  running applications.  This number of VMs will be provisioned, and
  started, but their use as server nodes depends on the dynamic
  clustering feature.

* Initial Dynamic Cluster Size.  This is the starting number of nodes
  that will be running when the offer is provisioned.

#### Virtual Machine Settings Blade

The Virtual Machine Settings blade is exactly the same [as the first offer](#weblogic-server-single-node-with-no-admin-server).

#### Credentials for Cluster Creation Blade

The Credentials for Cluster Creation blade is exactly the same [as the preceding offer](#weblogic-server-single-node-with-admin-server).

#### Summary Blade

The summary blade is functionally the same as in the [as the preceding
offer](#weblogic-server-single-node-with-no-admin-server), but the
template is different because it contains the logic to provision the
cluster and start the admin server.

#### Buy Blade

The buy blade is exactly the same [as the first offer](#weblogic-server-single-node-with-no-admin-server).

### Connecting a Database to a Cluster

After the offer has been provisioned, you may take steps to connect one
or more databases.  For complete details on connecting databases to {{
site.data.var.wlsFullBrandName }}, please see [the release
notes](https://docs.oracle.com/middleware/12213/wls/NOTES/whatsnew.htm#NOTES155)
and [the
documentation](https://docs.oracle.com/middleware/12213/wls/INTRO/jdbc.htm#INTRO215).

Azure has great support for Oracle database, see
[https://azure.microsoft.com/en-us/solutions/oracle/](https://azure.microsoft.com/en-us/solutions/oracle/).
In addition to Oracle, Azure supports many other databases, including
[PostgreSQL](https://docs.microsoft.com/en-us/azure/postgresql/quickstart-create-server-database-portal) and [Azure SQL Server](https://docs.microsoft.com/azure/sql-database/sql-database-get-started-portal).

In this release of the offers, scripts are provided to take a
provisioned offer and configure a JDBC Data Source on it which
references a previously created Database VM.  For databases not
supported by the following scripts, you must follow the instructions for
that database.

* [`{{ site.data.var.oracleDBScriptName }}`]({{ site.data.var.oracleDBScriptDownloadUrl }}).
* [`{{ site.data.var.postgresqlDBScriptName }}`]({{ site.data.var.postgresqlDBScriptDownloadUrl }}).
* [`{{ site.data.var.azuresqlDBScriptName }}`]({{ site.data.var.azuresqlDBScriptDownloadUrl }}).

##### Preconditions for running a script

* The script needs access to the `ORACLE_HOME` of a {{
  site.data.var.wlsFullBrandName }} installation.  You can either run
  the script from the admin VM by putting the script on the admin vm
  host and then [accessing the VM via SSH](#accessing-the-vms-via-ssh),
  or you can install {{ site.data.var.wlsFullBrandName }} locally as
  described in [in the Oracle
  documentation](https://docs.oracle.com/en/middleware/fusion-middleware/12.2.1.3/wlsig/installing-weblogic-server-developers.html#GUID-207CA334-FEDD-4D35-9DCA-357E5FDFEB2E).
  It is easier to run the script directly on the admin VM, so this is
  the recommended approach.

* Each script requires the following arguments, so you must gather
  values for all of them before invoking the script.

   | Argument name | Purpose | Example value |
   |---------------|---------|---------------|
   | `<oracleHome>`| Oracle home directory | /u01/app/wls/install/Oracle/Middleware/Oracle_Home |
   | `<wlsAdminHost>` | Fully qualified hostname or IP of the running admin server | `wls1022030-102203rqoheafet-pyhfgreqbznva.eastus.cloudapp.azure.com` |
   | `<wlsAdminPort>` | Admin port, for T3 connection | `7001` |
   | `<wlsUserName>` | Username of WebLogic Administrator, as specified in the [credentials blade](#weblogic-server-single-node-with-admin-server) | `weblogic` |
   | `<wlsPassword>` | Password for WebLogic Administrator | REDACTED | 
   | `<jdbcDataSourceName>` | JDBC Datasource Name | `testJDBC` | 
   | `<dsConnectionURL>` | JDBC Connection String for database | `jdbc:oracle:thin:@benqoiz.southeastasia.cloudapp.azure.com:1521/cqo1` |
   | `<dsUser>` | Username of the database | `weblogic` |
   | `<dsPassword>` | Password for the database user | REDACTED | 

* The Database VM must be running and accessible via the arguments in
  the preceding point.

##### Configuring the Datasource

After SSHing into the admin VM and becoming `root`, assuming the
preconditions have been met, the following commands will fetch and run
the scripts.  Please replace argument values as described above.
   
```
sudo su -
export ORACLE_HOME=/u01/app/wls/install/Oracle/Middleware/Oracle_Home
wget {{ site.data.var.oracleDBScriptDownloadUrl }}
wget {{ site.data.var.postgresqlDBScriptDownloadUrl }}
wget {{ site.data.var.azuresqlDBScriptDownloadUrl }}
chmod ugo+x ./datasourceConfig*.sh
./{{ site.data.var.wildcardDBScriptName }} ${ORACLE_HOME} wls1022030-102203rqoheafet-pyhfgreqbznva.eastus.cloudapp.azure.com 7001 weblogic REDACTED testJDBC jdbc:oracle:thin:@benqoiz.southeastasia.cloudapp.azure.com:1521/cqo1 weblogic REDACTED
```

##### Obtaining the JDBC Connection Strings

The most complicated argument for the `datasourceConfig` script is the
`dsConnectionURL`.  This section aims to simplify deriving the value for
this argument for each of the databases supported by the
`datasourceConfig` scripts.

* Oracle

   The Oracle JDBC string is the simplest.  In most cases, the only
   values that change from deployment to deployment are the hostname and
   the database name, as shown here.
   
   ```
   jdbc:oracle:thin:@HOSTNAME:1521/DATABASENAME
   ```
   
   For example,
   
   ```
   jdbc:oracle:thin:@benqoiz.southeastasia.cloudapp.azure.com:1521/pdb1
   ```

* Azure Database for PostgreSQL

   Deploy an Azure Database PostgreSQL as described [in the
   documentation](https://docs.microsoft.com/en-us/azure/postgresql/quickstart-create-server-database-portal).
   Then, visit the service instance in `portal.azure.com` and visit the
   `Connection strings` area in the settings.
   
   ![Connection Strings]({{ site.url }}/arm-oraclelinux-wls/assets/jdbc-datasources-03-postgresql-01.png "Connection Strings")
   
   Locate the "JDBC" section and click the "copy" icon on the right.
   This should cause something like the following to be copied to your
   clipboard.

   ```
   jdbc:postgresql://20191015cbfgterfdy.postgres.database.azure.com:5432/{your_database}?user=jroybtvp@20191015cbfgterfdy&password={your_password}&sslmode=require
   ```
   
   When passing this value to the `datasourceConfig-postgres.sh` strip
   out the `user` and `password` name=value pairs and position them as
   arguments to the script.  In the above example, the `dsConnectionURL`
   would be similar to this.
   
   ```
   jdbc:postgresql://20191015cbfgterfdy.postgres.database.azure.com:5432/{your_database}?sslmode=require
   ```
   
* Azure SQL Server

   Deploy Azure SQL Server as described in [the
   documentation](https://docs.microsoft.com/azure/sql-database/sql-database-get-started-portal).
   Then, visit the service instance in `portal.azure.com` and visit the
   `Connection Strings` area in the settings.
   
   ![Connection Strings]({{ site.url }}/arm-oraclelinux-wls/assets/jdbc-datasources-04-azuresql-01.png "Connection Strings")
   
   Click the "JDBC" tab and click the "copy" icon on the right.
   This should cause something like the following to be copied to your
   clipboard.
   
   ```
   jdbc:sqlserver://rwo102804.database.windows.net:1433;database=rwo102804;user=jroybtvp@rwo102804;password={your_password_here};encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;
   ```

   When passing this value to the `datasourceConfig-azuresql.sh` strip
   out the `user` and `password` name=value pairs and position them as
   arguments to the script.  In the above example, the `dsConnectionURL`
   would be similar to this.
   
   ```
   jdbc:sqlserver://rwo102804.database.windows.net:1433;database={your_database};encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;
   ```

##### Testing the Datasource

The process for validating the database connection is the same
regardless which database is used.

1. Visit the admin console as described in [Accessing the admin
   console](#accessing-the-admin-console).
   
2. In the "Domain Structure" area of the UI, expand "Services".  You
   should see something similar to this.
   
   ![Domain Structure Data Sources]({{ site.url }}/arm-oraclelinux-wls/assets/jdbc-datasources-01.png "Domain Structure Data Sources")

3. Click on the name of the datasource in the table.  For example "testJDBC".

4. Click on "Monitoring" then "Testing".  Then select the radio button
   of one of the cluster nodes and click "Test Data Source" as shown here.

   ![Domain Structure Data Sources]({{ site.url }}/arm-oraclelinux-wls/assets/jdbc-datasources-02.png "Domain Structure Data Sources")
   
5. The status area should show "Test of &lt;datasource name&gt; on
   server &lt;server name&gt; was successful.
   
6. Do this for all the other nodes.

If any of the datasoucres do not return a successful test, see [the
documentation](https://docs.oracle.com/middleware/12213/wls/INTRO/jdbc.htm#INTRO215)
and resolve the problem before continuing.
