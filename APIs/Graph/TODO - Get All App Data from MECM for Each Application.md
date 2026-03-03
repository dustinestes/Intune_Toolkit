## Get all of the relevant data subsets from MECM for each of the Applications included in the process.

Get the application's SDMPackageXML property content for analysis to extract the detailed configurations.

```powershell
# Get Application XML Data
$API_Route = "SMS_Application/$($Item.MECM.Metadata.Id)"
$API_Filter = ""
$Temp_SDMPackageXML = ([xml](Invoke-RestMethod -Uri "$($API_Root_MECM)$($API_Route)$($API_Filter)" -Method Get -ContentType "Application/Json" -UseDefaultCredentials).value.SDMPackageXML).AppMgmtDigest
```

```yaml
xmlns          : http://schemas.microsoft.com/SystemCenterConfigurationManager/2009/AppMgmtDigest
xsi            : http://www.w3.org/2001/XMLSchema-instance
Application    : Application
    AuthoringScopeId : ScopeId_
    LogicalName      : Application_8aa2ba0a-a5fd-420b-8a9e-2fc9b9e80e2d
    Version          : 3
    DisplayInfo      : DisplayInfo
    DeploymentTypes  : DeploymentTypes
    Title            : Title
    Description      : Description
    Publisher        : Publisher
    SoftwareVersion  : SoftwareVersion
    CustomId         : CustomId
    Owners           : Owners
    Contacts         : Contacts
DeploymentType : DeploymentType
    AuthoringScopeId     : ScopeId_
    LogicalName          : DeploymentType_94648195-d1a6-49ea-b961-cf720b2cf682
    Version              : 1
    Title                : Title
    DeploymentTechnology : GLOBAL/MSIDeploymentTechnology
    Technology           : MSI
    Hosting              : Native
    Installer            : Installer
Resources      : Resources
    Icon : Icon
```

Get the Deployment Type array of the Application (if Deployment Types exist) and then add the relevant data to the object's properties.

```powershell
if ($Item.MECM.Metadata.DeploymentTypes -gt 0) {
    # Get Valid Deployment Types (Latest Revision)
    $API_Route = "SMS_DeploymentType"
    $API_Filter = "?`$filter=AppModelName eq `'$($Item.MECM.Metadata.ModelName)`' and IsLatest eq true &`$select=CI_ID,PriorityInLatestApp,LocalizedDisplayName,ModelName,ContentId"
    $Temp_DTs = (Invoke-RestMethod -Uri "$($API_Root_MECM)$($API_Route)$($API_Filter)" -Method Get -ContentType "Application/Json" -UseDefaultCredentials).Value
    
    # Add Data to Object
    #...Omitted for Brevity...
}
```

```yaml
# Source: Deployment Type Details
# Route: https://0003wp-mecm-01v.flightsafety.com/AdminService/wmi/SMS_DeploymentType
# Filter: ?$filter=AppModelName eq 'ScopeId_/Application_8aa2ba0a-a5fd-420b-8a9e-2fc9b9e80e2d' and IsLatest eq true &$select=CI_ID,PriorityInLatestApp,LocalizedDisplayName,ModelName,ContentId

CI_ID                : 16859473
ContentId            : Content_9b480825-e817-4184-813c-7c329836be75
LocalizedDisplayName : Tenable, Inc. - Nessus Agent (x64) - 10.8.2.20009 (Silent x64)
ModelName            : ScopeId_/DeploymentType_94648195-d1a6-49ea-b961-cf720b2cf682
PriorityInLatestApp  : 1
```