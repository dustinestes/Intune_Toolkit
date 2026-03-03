Get all applications that match the criteria "IsLatest eq true" and select only the relevent properties.

```PowerShell
# MECM - Get Applications
$API_Route = "SMS_Application"
$API_Filter = "?`$Select=CI_ID,Manufacturer,LocalizedDisplayName,SoftwareVersion,LocalizedCategoryInstanceNames,ModelName,IsLatest,IsSuperseded,DateCreated,CreatedBy,DateLastModified,LastModifiedBy,NumberOfDependentDTs,NumberOfDeployments,NumberOfDeploymentTypes&`$filter=IsLatest eq true"
$Temp_MECM_Applications = (Invoke-RestMethod -Uri "$($API_Root_MECM)$($API_Route)$($API_Filter)" -Method Get -ContentType "Application/Json" -UseDefaultCredentials).value

```

```yaml
CI_ID                          : 16859479
CreatedBy                      : FLIGHTSAFETY\V00004255.SA
DateCreated                    : 2025-05-25T22:14:25Z
DateLastModified               : 2025-05-25T22:24:53Z
IsLatest                       : True
IsSuperseded                   : False
LastModifiedBy                 : FLIGHTSAFETY\V00004255.SA
LocalizedCategoryInstanceNames : {Intune Sync}
LocalizedDisplayName           : Nessus Agent (x64) - 10.8.2.20009 (Intune Sync)_MatchExists
Manufacturer                   : Tenable
ModelName                      : ScopeId_/Application_8aa2ba0a-a5fd-420b-8a9e-2fc9b9e80e2d
NumberOfDependentDTs           : 0
NumberOfDeployments            : 0
NumberOfDeploymentTypes        : 1
SoftwareVersion                : 10.8.2.20009
```