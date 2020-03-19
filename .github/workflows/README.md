# CI/CD Pipeline for arm-oraclelinux-wls
The pipeline is to build the template, validate it via Azure Resource Manager Template Toolkit, and test a deployed offer to make sure WebLogic Server work correctly after deployed.

## Platform
OS: ubuntu-latest  
JDK: OpenJDK 1.8

## Steps

0. Prerequisite
   * Set up secrets for azure and OTN  
   Create AZURE_CREDENTIALS following the guide [Set up Secrets in GitHub Action workflows](https://github.com/Azure/actions-workflow-samples/blob/master/assets/create-secrets-for-GitHub-workflows.md)  
   Create OTN_USERID and OTN_PASSWORD for Oracle Weblogic Install kit and Oracle JDK download.
   Create WLS_PASSWORD for WebLogic Server machine.

   * Set up global environment variables  
   Most of the steps are run on the virtual machine, azure cli will run on a new container. We can share variables by setting up with keyword [env](https://help.github.com/en/actions/configuring-and-managing-workflows/using-environment-variables) or GitHub API [set-env](https://help.github.com/en/actions/reference/development-tools-for-github-actions#set-an-environment-variable-set-env).
   ```
   env:
    myvariable:myvalue

   echo "::set-env name=variableName::variableValue"
   # or
   echo "##[set-env name=variableName;]variableValue"


1. Checkout source code  
   [azure-javaee-iaas](https://github.com/azure/aazure-javaee-iaas) Azure Marketplace Azure Application (formerly known as Solution Template) Helpers.  
   [arm-oraclelinux-wls](https://github.com/wls-eng/arm-oraclelinux-wls) WebLogic Server Single Node source code.  
   [arm-ttk](https://github.com/azure/arm-ttk) Azure Resource Manager Template Toolkit.  
   The working directory is '/home/runner/work/arm-oraclelinux-wls/arm-oraclelinux-wls', source code will checkout to this path as the following structure.
   ```
   ├── azure-javaee-iaas
   |   └── pom.xml
   ├── arm-oraclelinux-wls
   |   └── pom.xml
   ├── arm-ttk
   ```

2. Set up tools.  
   Set up JDK1.8 with action [actions/setup-java](https://github.com/marketplace/actions/setup-java-jdk)

3. Build azure-javaee-iaas  
   The working directory is '/home/runner/work/arm-oraclelinux-wls/arm-oraclelinux-wls',we have to specify pom.xml path to build this repo.
   ```
   mvn -DskipTests clean install --file azure-javaee-iaas/pom.xml
   ```

4. Build and validate template
   ```
   mvn -Ptemplate-validation-tests clean install --file arm-oraclelinux-wls/pom.xml
   ```

5. Deploy the template  
   * Login azure and create resource group   
   Use [azure/login](https://github.com/marketplace/actions/azure-login) to login azure.  
   Use [Azure CLI Action](https://github.com/marketplace/actions/azure-cli-action) to run azure commands.  
   Create resource group, name it wls-${{ github.run_id }}-${{ github.run_number }} to make sure it's unique.  
   ```
   az group create --verbose --name ${resourceGroup} --location ${location}
   ```
   * Replace parameters secrets value in test/data/parameters-test.json, we will deploy the template with the test parameters.
   * Deploy template with template file target/arm/mainTemplate.json.

6. Verify resource  
   * Check Network Security Group  
   Check if wls-nsg group is created. 
   ```
   az network nsg show -g ${resourceGroup} -n wls-nsg --query "name"
   ```
   The flow will fail if it does not exist.

7. Verify WebLogic Server  
   * Get access to the WebLogic Server VM  
   WebLogic Server does not start, we can not access wls for verification. Folder wlsserver will be created during WebLogic Server installation, we can check it.  
   We must access the machine to check wlsserver folder, however, the security rule will block now, we have to add Ip address of the machine that running build pipeline to security rule.  
   We can add IP with `az network nsg rule update`, but need to pay attension to the parameters, see [Multiply values on "--source-address-prefixes" field](https://github.com/Azure/azure-cli/issues/7439).  
   * Connect to wls machine and verify wls folder
   Now, we get permission to wls machine, we can connect to the machine and run any command for verification.  
   Execute test/scripts/verify-wls-path.sh, which will pass if the folder exists, otherwise, fail and exit the build process.
   ```
   sshpass -p ${wlsPassword} -v ssh -p 22 -o StrictHostKeyChecking=no -o ConnectTimeout=1000 -v -tt weblogic@${wlsPublicIP} 'bash -s' < arm-oraclelinux-wls/test/scripts/verify-wls-path.sh
   ```
   Note: we meet ssh timeout issue intermittently, to make it more stable, restarting wls machine after updating the security rule and scan the port with Netcat before executing the script.

8. Archive deploy package  
   Use [actions/upload-artifact](https://github.com/marketplace/actions/upload-artifact) to archive target/arm-oraclelinux-wls-version-arm-assembly.zip.  
   Note: actions/upload-artifact will zip the target folder/file again before uploading, we will unzip the package to target/arm-oraclelinux-wls-version-arm-assembly first.

9. Clean up  
   Delete the resource group that creating above.
   ```
   az group delete --yes --no-wait --verbose --name ${resourceGroup}
   ```

## Tips for CI/CD debugging
1. Trigger the build flow with command  
Firstly, add repository_dispatch trigger to the build.yml, we will raise the process with REST event.  
Before running the command, please set up your github token following [Creating a personal access token for the command line](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line)  
You will start a build process with the command:  
``
 curl -XPOST -u "github_account:token" -H "Accept: application/vnd.github.everest-preview+json" -H "Content-Type: application/json" https://api.github.com/repos/galiacheng/arm-oraclelinux-wls/dispatches --data '{"event_type": "production-deploy"}'
 ``

