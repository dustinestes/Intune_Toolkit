# Intune Toolkit - Applications - Application Synchronization

<br>

- [Intune Toolkit - Applications - Application Synchronization](#intune-toolkit---applications---application-synchronization)
  - [Usage](#usage)
    - [Parameters](#parameters)
    - [Examples](#examples)
  - [Reference](#reference)
    - [Control Flow](#control-flow)
    - [Class Visualization](#class-visualization)
    - [Class Definitions](#class-definitions)
      - [Application](#application)
      - [AppConfig](#appconfig)
      - [MECMApp : AppConfig](#mecmapp--appconfig)
      - [IntuneApp : AppConfig](#intuneapp--appconfig)
      - [IntunePrepTool](#intunepreptool)
      - [DeploymentType](#deploymenttype)
      - [Program](#program)
      - [MECMProgram : Program](#mecmprogram--program)
      - [IntuneProgram : Program](#intuneprogram--program)
      - [Content](#content)
      - [Detection](#detection)
      - [ScriptDetection : Detection](#scriptdetection--detection)
      - [Requirements](#requirements)
      - [Deployment](#deployment)
      - [Metadata](#metadata)
      - [MECMMeta : Metadata](#mecmmeta--metadata)
      - [IntuneMeta : Metadata](#intunemeta--metadata)
    - [Enums](#enums)
      - [SyncState](#syncstate)
      - [Status](#status)
  - [Scripts](#scripts)
    - [PowerShell](#powershell)
    - [Go](#go)
  - [Appendices](#appendices)
    - [Apdx A: References](#apdx-a-references)
    - [Apdx B: Visual Studio Code](#apdx-b-visual-studio-code)
      - [Debug Configuration Files](#debug-configuration-files)
- [Notes from Other Markdown](#notes-from-other-markdown)
- [Applications](#applications)
  - [Query](#query)
  - [Properties](#properties)
- [Deployment Types](#deployment-types)
  - [Query](#query-1)
  - [Properties](#properties-1)
  - [SDMPackageXML](#sdmpackagexml)
    - [Query](#query-2)
    - [Application](#application-1)
      - [Root Properties](#root-properties)
      - [DisplayInfo Properties](#displayinfo-properties)
      - [DeploymentTypes Properties](#deploymenttypes-properties)
    - [DeploymentType Nodes](#deploymenttype-nodes)
      - [Root Properties](#root-properties-1)
      - [Installer Properties](#installer-properties)
- [Content](#content-1)
  - [Query](#query-3)
  - [Properties](#properties-2)
- [Deployment Type Configurations](#deployment-type-configurations)
- [Example Data](#example-data)
  - [SDMPackageXML](#sdmpackagexml-1)

<br>

## Usage

### Parameters

<br>

### Examples

<br>

## Reference

### Control Flow

The following outlines the control flow of the script and how it progresses through the setup, ETL, execution, output, and cleanup.

### Class Visualization

TODO: Provide a hierarchical representation of the classes embeded and inherited within the various object structures.

```
Application
├── Publisher
├── DisplayName
├── Version
├── MECM
│   ├── Publisher
│   ├── DisplayName
│   ├── Version
│   ├── Description
│   ├── Icon
│   ├── InfromationUrl
│   ├── PrivacyUrl
│   ├── Categories
│   ├── DeploymentTypes
│   ├── Deployments
│   └── Metadata
├── Intune
├── IntunePrepTool
├── Include
├── Rules
├── SyncState
└── Status


```
Generated using [tree.nathanfriend.com](https://tree.nathanfriend.com/)

### Class Definitions

#### Application

This is the parent class into which all other defined classes are embedded. This class only contains a minimal set of properties that are shared between all source environments. This ensures it can be dynamically applied no matter what source you use to derive your application objects from.

The embedded app configs are constructed using the various sources necessary to build out the pertinent data. When synchronizing, these configurations are compared to ensure both environments are working with the same configurations.

| Type              | PropertyName     | MECM Source                                           | Intune Source                                  | Example                     |
|-------------------|------------------|-------------------------------------------------------|------------------------------------------------|-----------------------------|
| [String]          | $Publisher       | SMS_Application.Manufacturer                          | deviceAppManagement/mobileApps.publisher       | Bomgar                      |
| [String]          | $DisplayName     | SMS_Application.LocalizedDisplayName                  | deviceAppManagement/mobileApps.displayName     | Bomgar Jump Client - 18.2.7 |
| [String]          | $Version         | SMS_Application.SoftwareVersion                       | deviceAppManagement/mobileApps.displayVersion  | 18.2.7                      |
| [MECMApp]         | $MECM            | See Class MECMAppConfig                               | N/A                                            | N/A                         |
| [IntuneApp]       | $Intune          | See Class IntuneAppConfig                             | N/A                                            | N/A                         |
| [IntunePrepTool]  | $IntunePrepTool  | See Class IntunePrepTool                              | N/A                                            | N/A                         |
| [Bool]            | $Include         | Script Internal                                       | N/A                                            | True                        |
| [Array]           | $Rules           | Script Internal                                       | N/A                                            | ("All Rules Passed")        |
| [SyncState]       | $SyncState       | Script Internal                                       | N/A                                            | Synced                      |
| [Status]          | $Status          | Script Internal                                       | N/A                                            | Pending                     |

<br>

#### AppConfig

This is a base class that contains all of the application configuration data that is utilized by all environments.

| Type               | PropertyName     | MECM Source                                                                                 | Intune Source                                         | Example                                                                                                 |
|--------------------|------------------|---------------------------------------------------------------------------------------------|-------------------------------------------------------|---------------------------------------------------------------------------------------------------------|
| [String]           | $Publisher       | SMS_Application/{SMS_Application.CI_ID}.SDMPackageXML.Application.Publisher.InnerText       | deviceAppManagement/mobileApps.publisher              | Bomgar                                                                                                  |
| [String]           | $DisplayName     | SMS_Application/{SMS_Application.CI_ID}.SDMPackageXML.Application.Title.InnerText           | deviceAppManagement/mobileApps.displayName            | Bomgar Jump Client                                                                                      |
| [String]           | $Version         | SMS_Application/{SMS_Application.CI_ID}.SDMPackageXML.Application.SoftwareVersion.InnerText | deviceAppManagement/mobileApps.version                | 18.2.7                                                                                                  |
| [String]           | $Description     | SMS_Application/{SMS_Application.CI_ID}.SDMPackageXML | deviceAppManagement/mobileApps.description            | Jump Clients let you control remote computers even when you don't control the remote network[Truncated] |
| [String]           | $Icon            | SMS_Application/{SMS_Application.CI_ID}.SDMPackageXML | deviceAppManagement/mobileApps.largeIcon              | Icon_9waLSND8C69Uj9B7VpFCOpVRxzcMAkWlwUiLvTRdgK[Truncated]                                              |
| [String]           | $InfromationUrl  | SMS_Application/{SMS_Application.CI_ID}.SDMPackageXML | deviceAppManagement/mobileApps.informationUrl         | https://www.userdocumentationlink.com                                                                   |
| [String]           | $PrivacyUrl      | SMS_Application/{SMS_Application.CI_ID}.SDMPackageXML | deviceAppManagement/mobileApps.privacyInformationUrl  | https://www.privacylink.com                                                                             |
| [Array]            | $Categories      | SMS_Application.LocalizedCategoryInstanceNames        | deviceAppManagement/mobileApps.                       | ("Intune Sync")                                                                                             |

<br>

#### MECMApp : AppConfig

This is a derived class that contains all of the parent properties as well as the MECM-specific properties.

| Type               | PropertyName     | MECM Source                                           | Intune Source | Example                                                                                                 |
|--------------------|------------------|-------------------------------------------------------|---------------|---------------------------------------------------------------------------------------------------------|
| [Int]              | $Revision        | See Class DeploymentType                              | N/A           | N/A                                                                                                     |
| [DeploymentType[]] | $DeploymentTypes | See Class DeploymentType                              | N/A           | N/A                                                                                                     |
| [Deployment[]]     | $Deployments     | See Class Deployment                                  | N/A           | N/A                                                                                                     |
| [MECMMeta]         | $Metadata        | See Class MECMMetadata                                | N/A           | N/A                                                                                                     |

<br>

#### IntuneApp : AppConfig

This is a derived class that contains all of the parent properties as well as the Intune-specific properties.

| Type               | PropertyName     | MECM Source | Intune Source                               | Example                                                                                                 |
|--------------------|------------------|-------------|---------------------------------------------|---------------------------------------------------------------------------------------------------------|
| [Program]          | $Program         | N/A         | See Class Program                           | N/A                                                                                                     |
| [Object]           | $Assignments     | N/A         | deviceAppManagement/mobileApps.Assignments  | N/A                                                                                                     |
| [Object]           | $Detection       | N/A         | deviceAppManagement/mobileApps.rules        | N/A                                                                                                     |
| [IntuneMeta]       | $Metadata        | N/A         | See Class IntuneMeta                        | N/A                                                                                                     |

<br>

#### IntunePrepTool

This is a class containing the important properties used by the Intune Content Prep process

| Type               | PropertyName     | Source           | Example                                                                                                 |
|--------------------|------------------|------------------|---------------------------------------------------------------------------------------------------------|
| [String]           | $CommandLine     | N/A              | N/A                                                                                                     |
| [Status]           | $Status          | Script Internal  | Pending                                                                                                 |

<br>

#### DeploymentType

This is a class containing all of the Deployment Type information that is specific to the MECM environment.

| Type            | PropertyName             | MECM Source                                                                  | Intune Source | Example                                                           |
|-----------------|--------------------------|------------------------------------------------------------------------------|---------------|-------------------------------------------------------------------|
| [String]        | $Id                      | SMS_DeploymentType.CI_ID                                                     | N/A           | 16859469                                                          |
| [Int]           | $Priority                | SMS_DeploymentType.PriorityInLatestApp                                       | N/A           | 1                                                                 |
| [String]        | $Name                    | SMS_DeploymentType.LocalizedDisplayName                                      | N/A           | Bomgar - Bomgar Jump Client - 18.2.7 (Silent x86)                 |
| [String]        | $ModelName               | SMS_DeploymentType.ModelName                                                 | N/A           | ScopeId_/DeploymentType_ff085ab2-d911-4f78-8844-9244d7f8d94b      |
| [String]        | $ContentID               | SMS_DeploymentType.ContentId                                                 | N/A           | Content_f9d07050-41b4-499a-8eb9-c0b2fcd691e9                      |
| [String]        | $Context                 | SMS_DeploymentType.SDMPackageXML.Installer.ExecutionContext                  | N/A           | System                                                            |
| [MECMProgram]   | $Installation            | See Class Program                                                            | N/A           | N/A                                                               |
| [MECMProgram]   | $Uninstallation          | See Class Program                                                            | N/A           | N/A                                                               |
| [Detection]     | $Detection               | See Class Detection                                                          | N/A           | N/A                                                               |

<br>

#### Program

This is a class containing all of the Installation and Uninstallation program information that overlaps both environments.

| Type       | PropertyName   | MECM Source                                                                                       | Intune Source                                                 | Example                                                   |
|------------|----------------|---------------------------------------------------------------------------------------------------|---------------------------------------------------------------|-----------------------------------------------------------|
| [String]   | $CommandLine   | SMS_DeploymentType.SDMPackageXML.Installer.{Install/Uninstall}Action.Args.Arg.InstallCommandLine  | deviceAppManagement/mobileApps.{install/uninstall}CommandLine | TODO                                                 |

<br>

#### MECMProgram : Program

This is a derived class containing all of the Installation and Uninstallation program information specifically for the MECM environment.

| Type       | PropertyName              | MECM Source                                                                                                       | Intune Source | Example                                                   |
|------------|---------------------------|-------------------------------------------------------------------------------------------------------------------|---------------|-----------------------------------------------------------|
| [String]   | $CommandLine              | SMS_DeploymentType.SDMPackageXML.DeploymentType.Installer.{Install/Uninstall}Action.Args.InstallCommandLine       | N/A           | [Unknown]                                                 |
| [String]   | $WorkingDirectory         | SMS_DeploymentType.SDMPackageXML.DeploymentType.Installer.{Install/Uninstall}Action.Args.WorkingDirectory         | N/A           | [Unknown]                                                 |
| [String]   | $RequiresLogOn            | SMS_DeploymentType.SDMPackageXML.DeploymentType.Installer.{Install/Uninstall}Action.Args.RequiresLogOn            | N/A           | [Unknown]                                                 |
| [Bool]     | $RequiresElevatedRights   | SMS_DeploymentType.SDMPackageXML.DeploymentType.Installer.{Install/Uninstall}Action.Args.RequiresElevatedRights   | N/A           | [Unknown]                                                 |
| [Bool]     | $RequiresUserInteraction  | SMS_DeploymentType.SDMPackageXML.DeploymentType.Installer.{Install/Uninstall}Action.Args.RequiresUserInteraction  | N/A           | [Unknown]                                                 |
| [Bool]     | $RequiresReboot           | SMS_DeploymentType.SDMPackageXML.DeploymentType.Installer.{Install/Uninstall}Action.Args.RequiresReboot           | N/A           | [Unknown]                                                 |
| [String]   | $UserInteractionMode      | SMS_DeploymentType.SDMPackageXML.DeploymentType.Installer.{Install/Uninstall}Action.Args.UserInteractionMode      | N/A           | [Unknown]                                                 |
| [String]   | $PostInstallBehavior      | SMS_DeploymentType.SDMPackageXML.DeploymentType.Installer.{Install/Uninstall}Action.Args.PostInstallBehavior      | N/A           | [Unknown]                                                 |
| [Int]      | $ExecuteTime              | SMS_DeploymentType.SDMPackageXML.DeploymentType.Installer.{Install/Uninstall}Action.Args.ExecuteTime              | N/A           | [Unknown]                                                 |
| [Int]      | $MaxExecuteTime           | SMS_DeploymentType.SDMPackageXML.DeploymentType.Installer.{Install/Uninstall}Action.Args.MaxExecuteTime           | N/A           | [Unknown]                                                 |
| [Bool]     | $RunAs32Bit               | SMS_DeploymentType.SDMPackageXML.DeploymentType.Installer.{Install/Uninstall}Action.Args.RunAs32Bit               | N/A           | [Unknown]                                                 |
| [String]   | $ContentId                | SMS_DeploymentType.SDMPackageXML.DeploymentType.Installer.Contents.Content.ContentId                              | N/A           | [Unknown]                                                 |
| [String]   | $ContentPath              | SMS_DeploymentType.SDMPackageXML.DeploymentType.Installer.Contents.Content.Location                               | N/A           | [Unknown]                                                 |
| [Object]   | $File                     | SMS_DeploymentType.SDMPackageXML.DeploymentType.Installer.Contents.Content.File                                   | N/A           | [Unknown]                                                 |

<br>

#### IntuneProgram : Program

This is a derived class containing all of the Installation and Uninstallation program information specifically for the Intune environment

| Type            | PropertyName             | MECM Source | Intune Source                                                                                       | Example                                                   |
|-----------------|--------------------------|-------------|-----------------------------------------------------------------------------------------------------|-----------------------------------------------------------|
| [String]        | $InstallCommandLine      | N/A         | deviceAppManagement/mobileApps.installCommandLine                                                   | [Unknown]                                                 |
| [String]        | $UninstallCommandLine    | N/A         | deviceAppManagement/mobileApps.uninstallCommandLine                                                 | [Unknown]                                                 |
| [String]        | $RunAs                   | N/A         | deviceAppManagement/mobileApps.installExperience.runAsAccount                                       | [Unknown]                                                 |
| [String]        | $RestartBehavior         | N/A         | deviceAppManagement/mobileApps.installExperience.deviceRestartBehavior                              | [Unknown]                                                 |
| [String]        | $ContentFile             | N/A         | deviceAppManagement/mobileApps.fileName                                                             | [Unknown]                                                 |
| [String]        | $SetupFile               | N/A         | deviceAppManagement/mobileApps.setupFilePath                                                        | [Unknown]                                                 |
| [Int]           | $SetupFileSize           | N/A         | deviceAppManagement/mobileApps.size                                                                 | [Unknown]                                                 |
| [ReturnCode[]]  | $ReturnCodes             | N/A         | deviceAppManagement/mobileApps.                                                                     | [Unknown]                                                 |
| [Object]        | $MSIInformation          | N/A         | deviceAppManagement/mobileApps.                                                                     | [Unknown]                                                 |

<br>

#### Content

This is a class containing all of the Content information specific to the Intune environment.

| Type       | PropertyName     | MECM Source | Intune Source                                          | Example                                                                                                 |
|------------|------------------|-------------|--------------------------------------------------------|---------------------------------------------------------------------------------------------------------|
| [Object]   | $MSIInformation  | N/A         | deviceAppManagement/mobileApps.msiInformation          | N/A                                                                                                     |
| [String]   | $Filename        | N/A         | deviceAppManagement/mobileApps.fileName                | N/A                                                                                                     |
| [String]   | $Version         | N/A         | deviceAppManagement/mobileApps.committedContentVersion | N/A                                                                                                     |
| [Int]      | $Size            | N/A         | deviceAppManagement/mobileApps.size                    | N/A                                                                                                     |

<br>

#### Detection

| Type       | PropertyName   | MECM Source                                                                             | Intune Source | Example                                                   |
|------------|----------------|-----------------------------------------------------------------------------------------|---------------|-----------------------------------------------------------|
| [String]   | $Provider      | SMS_DeploymentType.SDMPackageXML.Installer.DetectAction.Provider                        | N/A           | TODO                                                      |

<br>

#### ScriptDetection : Detection

| Type       | PropertyName   | MECM Source                                                                             | Intune Source | Example                                                   |
|------------|----------------|-----------------------------------------------------------------------------------------|---------------|-----------------------------------------------------------|
| [String]   | $Context       | SMS_DeploymentType.SDMPackageXML.Installer.DetectAction.Args.Arg.ExecutionContext       | N/A           | TODO                                                      |
| [String]   | $ScriptType    | SMS_DeploymentType.SDMPackageXML.Installer.DetectAction.Args.Arg.ScriptType             | N/A           | TODO                                                      |
| [String]   | $ScriptBody    | SMS_DeploymentType.SDMPackageXML.Installer.DetectAction.Args.Arg.ScriptBody             | N/A           | TODO                                                      |
| [Bool]     | $RunAs32Bit    | SMS_DeploymentType.SDMPackageXML.Installer.DetectAction.Args.Arg.RunAs32Bit             | N/A           | TODO                                                      |

Translation Tables

 - ScriptType
   - 0 = PowerShell
   - 1 = VBScript
   - 2 = JScript

<br>

#### Requirements

[Properties]

<br>

#### Deployment

[Properties]

<br>

#### Metadata

This is a base class containing all of the general application metadata that overlaps both environments.

| Type       | PropertyName             | MECM Source                             | Intune Source                                         | Example (MECM)         | Example (Intune)                     |
|------------|--------------------------|-----------------------------------------|-------------------------------------------------------|------------------------|--------------------------------------|
| [String]   | $Id                      | SMS_Application.CI_ID                   | deviceAppManagement/mobileApps.Id                     | 16859469               | b9309181-bb58-4c35-a567-b7d6ee07b0e5 |
| [DateTime] | $Created                 | SMS_Application.DateCreated             | deviceAppManagement/mobileApps.createdDateTime        | 2025-05-20T18:38:02Z   | 5/19/2025 6:57:29 PM                 |
| [DateTime] | $Modified                | SMS_Application.DateLastModified        | deviceAppManagement/mobileApps.lastModifiedDateTime   | 2025-05-24T14:51:29Z   | 5/19/2025 6:57:29 PM                 |

<br>

#### MECMMeta : Metadata

This is a derived class containing all of the application metadata that is specific to the MECM environment.

| Type       | PropertyName             | MECM Source                                                                                   | Intune Source | Example                                                   |
|------------|--------------------------|-----------------------------------------------------------------------------------------------|---------------|-----------------------------------------------------------|
| [Array]    | $Owners                  | SMS_Application/{SMS_Application.CI_ID}.SDMPackageXML.Application.Owners.User.ID              | N/A           | [LogonUserID]                                             |
| [Array]    | $Contacts                | SMS_Application/{SMS_Application.CI_ID}.SDMPackageXML.Application.Contacts.User.ID            | N/A           | [LogonUserID]                                             |
| [String]   | $CreatedBy               | SMS_Application.CreatedBy                                                                     | N/A           | Domain\Username                                           |
| [String]   | $ModifiedBy              | SMS_Application.LastModifiedBy                                                                | N/A           | Domain\Username                                           |
| [String]   | $ModelName               | SMS_Application.ModelName                                                                     | N/A           | ScopeId_/Application_6898df94-6941-43b2-b771-1023f0766952 |
| [Bool]     | $IsLatest                | SMS_Application.IsLatest                                                                      | N/A           | false                                                     |
| [Bool]     | $IsSuperseded            | SMS_Application.IsSuperseded                                                                  | N/A           | false                                                     |
| [int]      | $DependentDTs            | SMS_Application.NumberOfDependentDTs                                                          | N/A           | 0                                                         |
| [int]      | $Deployments             | SMS_Application.NumberOfDeployments                                                           | N/A           | 1                                                         |
| [int]      | $DeploymentTypes         | SMS_Application.NumberOfDeploymentTypes                                                       | N/A           | 2                                                         |

<br>

#### IntuneMeta : Metadata

This is a derived class containing all of the application metadata that is specific to the Intune environment.

| Type       | PropertyName   | MECM Source | Intune Source                               | Example                                                   |
|------------|----------------|-------------|---------------------------------------------|-----------------------------------------------------------|
| [String]   | $Owner         | N/A         | ?                                           | [Unknown]                                                 |
| [String]   | $Developer     | N/A         | ?                                           | [Unknown]                                                 |
| [String]   | $Notes         | N/A         | ?                                           | [Unknown]                                                 |

<br>

### Enums

A list of enumerators defined within the script and some information about each one.

#### SyncState

| Status        | Description                                                                                                                         | Logic Branch  |
|---------------|-------------------------------------------------------------------------------------------------------------------------------------|---------------|
| Pending       | (Default) The initial state of a property once it is first constructed.                                                             | Exists        |
| MatchFound    | A match was found between the source and the target environment so the two objects will be analyzed to ensure all settings match.   | Exists        |
| NotSynced     | A match was found but the settings between the two are not synced. The settings need to be pushed from the source to the target.    | Exists        |
| Synced        | A match was found and the settings between the source and the target are synced. No changes are necessary.                          | Exists        |
| NotExist      | A match was not found so the object only exists in the source and needs to be created within the target environment.                | New           |
| Created       | A match was not found and the object was successfuly created within the target environment.                                         | New           |

<br>

#### Status

| Status     | Description                                                                                     |
|------------|-------------------------------------------------------------------------------------------------|
| Pending    | (Default) The initial state of a property once it is first constructed.                         |
| InProgress | The execution logic of the script has begun operating on the object.                            |
| Success    | The execution logic of the script has successfully completed operating on the specified object. |
| Error      | The execution logic of the script encountered an error while operating on the specified object. |
| Skipped    | The object was filtered out using one, or more, of the defined filtering logic.                 |

<br>

## Scripts

### PowerShell

The following script can be exucuted within a user (manual) or service account's (automated) context.

```powershell
TODO: Paste code here when done building in dev environment
```

<br>

### Go

TODO: Description

```go
TODO: Develop same functionality within the Go language into a CLI or GUI based application.
```

<br>

## Appendices

A collection of sections that provide detailed explanation or understanding to the above topic but are not necessary within the main body of the topic.

### Apdx A: References

The following items are referenced in the code within this document. Familiarize yourself with them before moving on.

| Name                  | Type                        | Description                                                                                                       | Link |
|-----------------------|-----------------------------|-------------------------------------------------------------------------------------------------------------------|------|
| Math                  | .NET Class                  | Provides constants and static methods for trigonometric, logarithmic, and other common mathematical functions.    | [Microsoft Learn](https://learn.microsoft.com/en-us/dotnet/api/system.math?view=net-8.0) |

<br>


### Apdx B: Visual Studio Code

#### Debug Configuration Files

Add the appropriate snippet (updated where necessary) to your Visual Studio Code launch.json file for easy, one-click debugging within the IDE.

PowerShell Script Debugging

```json
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Application Sync",
            "type": "PowerShell",
            "request": "launch",
            "script": "${workspaceFolder}\\Applications - Synchronize MECM Applications to Intune.ps1",
            "args": [
                "-Source",
                  "MECM",
                "-SMSProvider",
                    "\"0001-mecm-01v.domain.com\"",
                "-AdminCategory",
                    "\"Intune Sync\"",
                "-IntunePrepToolPath",
                    "\"\\\\mecmcontent\\repo\\Applications\\Microsoft Corporation\\Microsoft Win32 Content Prep Tool\\1.8.6\\Install\\IntuneWinAppUtil.exe\"",
                "-Include",
                    "\"Bomgar Jump Client - 18.2.7 (Intune Sync)\"",
                "-Exclude",
                    "\"^$\"",
                "-GraphModules",
                    "All",
                // "-TenantId",
                //   "",
                // "-ClientId",
                //   "",
                // "-ClientSecret",
                //   "",
                "-OutputDir",
                    "\"\\\\mecmcontent\\repo\\Logging\\Maintenance Tasks\\Application Management\\Intune\\Synchronize MECM Applications to Intune\"",
                "-OutputName",
                    "\"Applications - Synchronize MECM Applications to Intune\"",
                "-Mode",
                    "Analyze",
                "-Logging",
                    "Debug"
            ]
        },
    ]
}
```






# Notes from Other Markdown

# Applications

## Query

https://<ServerFQDN>/AdminService/wmi/SMS_ApplicationLatest?$filter=CI_ID+eq+16852008
https://<ServerFQDN>/AdminService/wmi/SMS_ApplicationLatest?$filter=CI_ID+eq+16852008&$expand=AppMgmtDigest

## Properties

| Name | Example Value |
|-|-|
| CI_ID | 16852008 |
| CI_UniqueID | ScopeId_99ED2923-6EDE-4D65-AC0E-21876AE0D204/Application_aa511366-3ac0-4d93-84ec-356bc18cd266/3 |
| CIVersion | 3 |
| DateCreated | 2025-01-07T14:03:20Z |
| DateLastModified | 2025-01-07T14:11:52Z |
| HasContent | true |
| IsDeployable | true |
| IsDeployed | true |
| IsEnabled | true |
| IsExpired | false |
| IsHidden | false |
| IsLatest | true |
| IsSuperseded | false |
| IsSuperseding | false |
| LocalizedCategoryInstanceNames | [] |
| LocalizedDescription |  |
| LocalizedDisplayName | Nessus Agent (x64) - 10.8.2.20009 |
| Manufacturer | Tenable, Inc. |
| ModelID | 16847796 |
| ModelName | ScopeId_99ED2923-6EDE-4D65-AC0E-21876AE0D204/Application_aa511366-3ac0-4d93-84ec-356bc18cd266 |
| NumberOfDependentDTs | 0 |
| NumberOfDependentTS | 10 |
| NumberOfDeployments | 2 |
| NumberOfDeploymentTypes | 1 |
| PackageID | "" |
| SoftwareVersion | "10.8.2.20009" |

<br>

# Deployment Types

SMS_ApplicationLatest.ModelName -> SMS_DeploymentType.AppModelName

## Query

https://<ServerFQDN>/AdminService/wmi/SMS_DeploymentType

## Properties

| Name | Example Value | Map |
|-|-|-|
| AppModelName | ScopeId_99ED2923-6EDE-4D65-AC0E-21876AE0D204/Application_aa511366-3ac0-4d93-84ec-356bc18cd266 | |
| CI_ID | 16852009 | |
| CI_UniqueID | ScopeId_99ED2923-6EDE-4D65-AC0E-21876AE0D204/DeploymentType_b7b4c4f1-f014-491e-8495-5581ce232f31/2 | |
| CIVersion | 2 | |
| ContentId | Content_5a073a8b-08ad-4120-a86d-de0b81a47998 | |
| ExecutionContext | 0 | 0 = System; 1 = User |
| IsEnabled | true | |
| IsExpired | false | |
| IsHidden | false | |
| IsLatest | true | |
| IsSuperseded | false | |
| LocalizedCategoryInstanceNames | [] | |
| LocalizedDescription |  | |
| LocalizedDisplayName | Tenable, Inc. - Nessus Agent (x64) - 10.8.2.20009 (Silent x64) | |
| ModelID | 16847797 | |
| ModelName | ScopeId_99ED2923-6EDE-4D65-AC0E-21876AE0D204/DeploymentType_b7b4c4f1-f014-491e-8495-5581ce232f31 | |
| NumberOfDependedDTs | 0 | |
| NumberOfDependentDTs | 0 | |
| Technology | MSI | |

## SDMPackageXML

### Query

### Application

#### Root Properties

| Path | Example Value |
|-|-|
| AppMgmtDigest.Application.Publisher | Tenable, Inc. |
| AppMgmtDigest.Application.Title | Nessus Agent (x64) - 10.8.2.20009 |
| AppMgmtDigest.Application.SoftwareVersion | 10.8.2.20009 |
| AppMgmtDigest.Application.Owners.User | <User Qualifier="LogonName" Id="V00004255.SA" /> |
| AppMgmtDigest.Application.Contacts.User | <User Qualifier="LogonName" Id="V00004255.SA" /> |

#### DisplayInfo Properties

| Path | Example Value |
|-|-|
| AppMgmtDigest.Application.DisplayInfo.Info.Publisher | Tenable, Inc. |
| AppMgmtDigest.Application.DisplayInfo.Info.Title | Nessus Agent (x64) |
| AppMgmtDigest.Application.DisplayInfo.Info.Version | 10.8.2.20009 |

#### DeploymentTypes Properties

Lists all deployment types associated with an Application.

| Path | Example Value |
|-|-|
| AppMgmtDigest.Application.DeploymentTypes | LogicalName="DeploymentType_b7b4c4f1-f014-491e-8495-5581ce232f31" |


### DeploymentType Nodes

Expanded property and configurations nodes for each deployment type that an Application has in its model.

> This is just an example of one.

| Path | Example Value |
|-|-|
| AppMgmtDigest.Application.DeploymentType | LogicalName="DeploymentType_b7b4c4f1-f014-491e-8495-5581ce232f31" |

#### Root Properties

| Path | Example Value |
|-|-|
| AppMgmtDigest.Application.DeploymentType.Title | Tenable, Inc. - Nessus Agent (x64) - 10.8.2.20009 (Silent x64) |
| AppMgmtDigest.Application.DeploymentType.Description |  |
| AppMgmtDigest.Application.DeploymentType.Technology | MSI |

#### Installer Properties

| Path | Example Value |
|-|-|
| AppMgmtDigest.Application.DeploymentType.Installer.ExecutionContext | System |
| AppMgmtDigest.Application.DeploymentType.Installer.Contents.Content | ContentId="Content_5a073a8b-08ad-4120-a86d-de0b81a47998" |
| AppMgmtDigest.Application.DeploymentType.Installer.Contents.Content.File | Name="NessusAgent-10.8.2-x64.msi" |
| AppMgmtDigest.Application.DeploymentType.Installer.Contents.Content.Location | \\mecmcontent\repo\Applications\Tenable, Inc\Nessus Agent (x64)\10.8.2.20009\Install\ |
| AppMgmtDigest.Application.DeploymentType.Installer.DetectionAction.Provider | Script |
| AppMgmtDigest.Application.DeploymentType.Installer.DetectionAction.Args.Arg | <Arg Name="ExecutionContext" Type="String">System</Arg> |
| AppMgmtDigest.Application.DeploymentType.Installer.DetectionAction.Args.Arg | <Arg Name="ScriptType" Type="Int32">0</Arg> |
| AppMgmtDigest.Application.DeploymentType.Installer.DetectionAction.Args.Arg | <Arg Name="ScriptBody" Type="String">[LargeScriptBody]</Arg> |
| AppMgmtDigest.Application.DeploymentType.Installer.InstallAction.Provider | MSI |
| AppMgmtDigest.Application.DeploymentType.Installer.InstallAction.Args.Arg | <Arg Name="InstallCommandLine" Type="String">MsiExec.exe /i "NessusAgent-10.8.2-x64.msi" /qn /l*v "%MECM_Directory_Logs%\Applications\Install\Tenable,Inc._NessusAgent(x64)_10.8.2.20009_Install.log" NESSUS_GROUPS="Test Group" NESSUS_SERVER="cloud.tenable.com:443" NESSUS_KEY=KeyGoesHere</Arg> |
| AppMgmtDigest.Application.DeploymentType.Installer.InstallAction.Args.Arg | <Arg Name="ExecutionContext" Type="String">System</Arg> |
| AppMgmtDigest.Application.DeploymentType.Installer.UninstallAction.Provider | MSI |
| AppMgmtDigest.Application.DeploymentType.Installer.UninstallAction.Args.Arg | <Arg Name="InstallCommandLine" Type="String"> MsiExec.exe /x {8BDE7E7C-9AC3-4255-BC0A-A1109B440107} /qn /l*v "%MECM_Directory_Logs%\Applications\Uninstall\Tenable,Inc._NessusAgent(x64)_10.8.2.20009_Uninstall.log"</Arg> |
| AppMgmtDigest.Application.DeploymentType.Installer.UninstallAction.Args.Arg | <Arg Name="ExecutionContext" Type="String">System</Arg> |


<br>

# Content

Content is on a per-Deployment Type basis, not on a per-Application basis. This is because you can have more than one DT for each Appliation and each DT can have different content to satisfy different configurations.

## Query


## Properties

| Name | Example Value | Map |
|-|-|-|

<br>

# Deployment Type Configurations

SMS_DeploymentType.AppModelName


# Example Data

## SDMPackageXML

```xml
<?xml version="1.0" encoding="utf-16"?>
<AppMgmtDigest
    xmlns="http://schemas.microsoft.com/SystemCenterConfigurationManager/2009/AppMgmtDigest"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <Application AuthoringScopeId="ScopeId_99ED2923-6EDE-4D65-AC0E-21876AE0D204"
        LogicalName="Application_aa511366-3ac0-4d93-84ec-356bc18cd266" Version="3">
        <DisplayInfo DefaultLanguage="en-US">
            <Info Language="en-US">
                <Title>Nessus Agent (x64)</Title>
                <Publisher>Tenable, Inc.</Publisher>
                <Version>10.8.2.20009</Version>
            </Info>
        </DisplayInfo>
        <DeploymentTypes>
            <DeploymentType AuthoringScopeId="ScopeId_99ED2923-6EDE-4D65-AC0E-21876AE0D204"
                LogicalName="DeploymentType_b7b4c4f1-f014-491e-8495-5581ce232f31" Version="2" />
        </DeploymentTypes>
        <Title ResourceId="Res_341260763">Nessus Agent (x64) - 10.8.2.20009</Title>
        <Publisher ResourceId="Res_2117722051">Tenable, Inc.</Publisher>
        <SoftwareVersion ResourceId="Res_1501510248">10.8.2.20009</SoftwareVersion>
        <Owners>
            <User Qualifier="LogonName" Id="V00004255.SA" />
        </Owners>
        <Contacts>
            <User Qualifier="LogonName" Id="V00004255.SA" />
        </Contacts>
    </Application>
    <DeploymentType AuthoringScopeId="ScopeId_99ED2923-6EDE-4D65-AC0E-21876AE0D204"
        LogicalName="DeploymentType_b7b4c4f1-f014-491e-8495-5581ce232f31" Version="2">
        <Title ResourceId="Res_1566229574">Tenable, Inc. - Nessus Agent (x64) - 10.8.2.20009 (Silent
            x64)</Title>
        <Description ResourceId="Res_1220391511" />
        <DeploymentTechnology>GLOBAL/MSIDeploymentTechnology</DeploymentTechnology>
        <Technology>MSI</Technology>
        <Hosting>Native</Hosting>
        <Installer Technology="MSI">
            <ExecutionContext>System</ExecutionContext>
            <Contents>
                <Content ContentId="Content_5a073a8b-08ad-4120-a86d-de0b81a47998" Version="1">
                    <File Name="NessusAgent-10.8.2-x64.msi" Size="68153856" />
                    <Location>\\mecmcontent\repo\Applications\Tenable, Inc\Nessus Agent
                        (x64)\10.8.2.20009\Install\</Location>
                    <PeerCache>true</PeerCache>
                    <OnFastNetwork>Download</OnFastNetwork>
                    <OnSlowNetwork>DoNothing</OnSlowNetwork>
                </Content>
            </Contents>
            <DetectAction>
                <Provider>Script</Provider>
                <Args>
                    <Arg Name="ExecutionContext" Type="String">System</Arg>
                    <Arg Name="ScriptType" Type="Int32">0</Arg>
                    <Arg Name="ScriptBody" Type="String">&lt;#
                        -----------------------------------------------------------------------------------------------------------------------------
                        Registry Detection Logic
                        --------------------------------------------------------------------------------------------------------------------------------
                        Author: Dustin Estes
                        Created: 2017-03-13
                        Copyright: VividRock LLC | All Rights Reserved
                        Website: https://www.vividrock.com
                        Version: 1.6

                        Purpose: Used to detect an applications installation based on registry
                        values found

                        Function:
                        1. Searches the specified registry locations in the hash table to populate a
                        list of keys
                        2. Checks the property values of each key returned to see if both the
                        Publisher and DisplayName are like the Values specified
                        3. It then checks to see if the DisplayVersion matches the desired value
                        using the specified field
                        -----------------------------------------------------------------------------------------------------------------------------
                        #&gt;

                        # Specify the Detection Variables
                        # Wildcards Supported:
                        https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about-wildcards?view=powershell-7.2
                        $AppPublisher = "Tenable, Inc."
                        $AppDisplayName = "Nessus Agent (x64)"
                        $AppDisplayVersion = "10.8.2.20009"

                        # Supported Operators (strings ignore this and use -eq only since they
                        cannot be compared by math operators):
                        # Equal to: -eq | Greater than or equal to: -ge
                        $VersionOperator = "-ge"

                        # Registry Locations: 32-bit, 64-bit, and Current User Installation
                        $RegistryLocations = @(
                        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
                        "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
                        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
                        )

                        # Delay Detection if Necessary
                        #Start-Sleep -Seconds 10


                        &lt;#
                        -----------------------------------------------------------------------------------------------------------------------------
                        Do Not Edit Below This Line
                        -----------------------------------------------------------------------------------------------------------------------------
                        #&gt;
                        # Set Default Value Before Processing
                        $OverallDetection = $false

                        # Determine the Data Type of the Version Value Provided
                        if ($AppDisplayVersion -match "^[\d\.]+$") {
                        $VersionDataType = "Integer"
                        }
                        else {
                        $VersionDataType = "String"
                        }

                        # Perform the Detection
                        foreach ($RegistryLocation in $RegistryLocations) {

                        # Ensure Registry Key Exists Before Continuing
                        if ((Test-Path -Path $RegistryLocation) -eq $true) {
                        $Keys = Get-Childitem $RegistryLocation

                        foreach ($Key in $Keys) {
                        # Find and Match Publisher &amp; DisplayName
                        if (($Key.GetValue("Publisher") -like $AppPublisher) -and
                        ($Key.GetValue("DisplayName") -like $AppDisplayName)) {

                        # Process Based on the Version Data Type
                        if ($VersionDataType -eq "String") {
                        # Strings Can Only Use Equals So No If/Then for Version Operator is Used
                        if ($Key.GetValue("DisplayVersion") -eq $AppDisplayVersion) {
                        $OverallDetection = $true
                        }
                        else {
                        $OverallDetection = $false
                        }
                        }
                        elseif ($VersionDataType -eq "Integer") {
                        # Find and Match DisplayVersion Using User-Supplied Operator Logic
                        # Equal To
                        if ($VersionOperator -eq "-eq") {
                        if ([System.Version]$Key.GetValue("DisplayVersion") -eq
                        [System.Version]$AppDisplayVersion) {
                        $OverallDetection = $true
                        }
                        else {
                        $OverallDetection = $false
                        }
                        }
                        # Greater Than / Equal To
                        if ($VersionOperator -eq "-ge") {
                        if ([System.Version]$Key.GetValue("DisplayVersion") -ge
                        [System.Version]$AppDisplayVersion) {
                        $OverallDetection = $true
                        }
                        else {
                        $OverallDetection = $false
                        }
                        }
                        }
                        }
                        }
                        }
                        }

                        &lt;#
                        -----------------------------------------------------------------------------------------------------------------------------
                        Add Sub-detection Logic Modules Below This Line (If Needed)
                        -----------------------------------------------------------------------------------------------------------------------------
                        #&gt;


                        &lt;#
                        -----------------------------------------------------------------------------------------------------------------------------
                        Detection Results
                        --------------------------------------------------------------------------------------------------------------------------------
                        Final detection results based on the return and logic of the install main
                        module and the sub-detection logic modules
                        -----------------------------------------------------------------------------------------------------------------------------
                        #&gt;
                        # Wlrite Output of the OverallDetection Variable
                        if ($OverallDetection -eq $true) {
                        Write-Host "Application is installed"
                        }
                        elseif ($OverallDetection -eq $false) {
                        # Don't Write Any Output
                        }</Arg>
                    <Arg Name="RunAs32Bit" Type="Boolean">false</Arg>
                </Args>
            </DetectAction>
            <InstallAction>
                <Provider>MSI</Provider>
                <Args>
                    <Arg Name="InstallCommandLine" Type="String">MsiExec.exe /i
                        "NessusAgent-10.8.2-x64.msi" /qn /l*v
                        "%MECM_Directory_Logs%\Applications\Install\Tenable,Inc._NessusAgent(x64)_10.8.2.20009_Install.log"
                        NESSUS_GROUPS="Test Group" NESSUS_SERVER="fedcloud.tenable.com:443"
                        NESSUS_KEY=60c4b50e67576d2ae159d056ab548c4f67ca1024ca37e16b984bc5f9254b8c83</Arg>
                    <Arg Name="WorkingDirectory" Type="String" />
                    <Arg Name="ExecutionContext" Type="String">System</Arg>
                    <Arg Name="RequiresLogOn" Type="String" />
                    <Arg Name="RequiresElevatedRights" Type="Boolean">false</Arg>
                    <Arg Name="RequiresUserInteraction" Type="Boolean">false</Arg>
                    <Arg Name="RequiresReboot" Type="Boolean">false</Arg>
                    <Arg Name="UserInteractionMode" Type="String">Hidden</Arg>
                    <Arg Name="PostInstallBehavior" Type="String">BasedOnExitCode</Arg>
                    <Arg Name="ExecuteTime" Type="Int32">5</Arg>
                    <Arg Name="MaxExecuteTime" Type="Int32">30</Arg>
                    <Arg Name="RunAs32Bit" Type="Boolean">false</Arg>
                    <Arg Name="SuccessExitCodes" Type="Int32[]">
                        <Item>0</Item>
                        <Item>1707</Item>
                    </Arg>
                    <Arg Name="RebootExitCodes" Type="Int32[]">
                        <Item>3010</Item>
                    </Arg>
                    <Arg Name="HardRebootExitCodes" Type="Int32[]">
                        <Item>1641</Item>
                    </Arg>
                    <Arg Name="FastRetryExitCodes" Type="Int32[]">
                        <Item>1618</Item>
                    </Arg>
                </Args>
                <Contents>
                    <Content ContentId="Content_5a073a8b-08ad-4120-a86d-de0b81a47998" Version="1" />
                </Contents>
            </InstallAction>
            <UninstallAction>
                <Provider>MSI</Provider>
                <Args>
                    <Arg Name="InstallCommandLine" Type="String">
                        MsiExec.exe /x
                        {8BDE7E7C-9AC3-4255-BC0A-A1109B440107} /qn /l*v
                        "%MECM_Directory_Logs%\Applications\Uninstall\Tenable,Inc._NessusAgent(x64)_10.8.2.20009_Uninstall.log"</Arg>
                    <Arg Name="WorkingDirectory" Type="String" />
                    <Arg Name="ExecutionContext" Type="String">System</Arg>
                    <Arg Name="RequiresLogOn" Type="String" />
                    <Arg Name="RequiresElevatedRights" Type="Boolean">false</Arg>
                    <Arg Name="RequiresUserInteraction" Type="Boolean">false</Arg>
                    <Arg Name="RequiresReboot" Type="Boolean">false</Arg>
                    <Arg Name="UserInteractionMode" Type="String">Hidden</Arg>
                    <Arg Name="PostInstallBehavior" Type="String">BasedOnExitCode</Arg>
                    <Arg Name="ExecuteTime" Type="Int32">5</Arg>
                    <Arg Name="MaxExecuteTime" Type="Int32">30</Arg>
                    <Arg Name="RunAs32Bit" Type="Boolean">false</Arg>
                    <Arg Name="SuccessExitCodes" Type="Int32[]">
                        <Item>0</Item>
                        <Item>1707</Item>
                    </Arg>
                    <Arg Name="RebootExitCodes" Type="Int32[]">
                        <Item>3010</Item>
                    </Arg>
                    <Arg Name="HardRebootExitCodes" Type="Int32[]">
                        <Item>1641</Item>
                    </Arg>
                    <Arg Name="FastRetryExitCodes" Type="Int32[]">
                        <Item>1618</Item>
                    </Arg>
                </Args>
            </UninstallAction>
            <CustomData>
                <DetectionMethod>Script</DetectionMethod>
                <DetectionScript Language="PowerShell">&lt;#
                    -----------------------------------------------------------------------------------------------------------------------------
                    Registry Detection Logic
                    --------------------------------------------------------------------------------------------------------------------------------
                    Author: Dustin Estes
                    Created: 2017-03-13
                    Copyright: VividRock LLC | All Rights Reserved
                    Website: https://www.vividrock.com
                    Version: 1.6

                    Purpose: Used to detect an applications installation based on registry values
                    found

                    Function:
                    1. Searches the specified registry locations in the hash table to populate a
                    list of keys
                    2. Checks the property values of each key returned to see if both the Publisher
                    and DisplayName are like the Values specified
                    3. It then checks to see if the DisplayVersion matches the desired value using
                    the specified field
                    -----------------------------------------------------------------------------------------------------------------------------
                    #&gt;

                    # Specify the Detection Variables
                    # Wildcards Supported:
                    https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about-wildcards?view=powershell-7.2
                    $AppPublisher = "Tenable, Inc."
                    $AppDisplayName = "Nessus Agent (x64)"
                    $AppDisplayVersion = "10.8.2.20009"

                    # Supported Operators (strings ignore this and use -eq only since they cannot be
                    compared by math operators):
                    # Equal to: -eq | Greater than or equal to: -ge
                    $VersionOperator = "-ge"

                    # Registry Locations: 32-bit, 64-bit, and Current User Installation
                    $RegistryLocations = @(
                    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
                    "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
                    "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
                    )

                    # Delay Detection if Necessary
                    #Start-Sleep -Seconds 10


                    &lt;#
                    -----------------------------------------------------------------------------------------------------------------------------
                    Do Not Edit Below This Line
                    -----------------------------------------------------------------------------------------------------------------------------
                    #&gt;
                    # Set Default Value Before Processing
                    $OverallDetection = $false

                    # Determine the Data Type of the Version Value Provided
                    if ($AppDisplayVersion -match "^[\d\.]+$") {
                    $VersionDataType = "Integer"
                    }
                    else {
                    $VersionDataType = "String"
                    }

                    # Perform the Detection
                    foreach ($RegistryLocation in $RegistryLocations) {

                    # Ensure Registry Key Exists Before Continuing
                    if ((Test-Path -Path $RegistryLocation) -eq $true) {
                    $Keys = Get-Childitem $RegistryLocation

                    foreach ($Key in $Keys) {
                    # Find and Match Publisher &amp; DisplayName
                    if (($Key.GetValue("Publisher") -like $AppPublisher) -and
                    ($Key.GetValue("DisplayName") -like $AppDisplayName)) {

                    # Process Based on the Version Data Type
                    if ($VersionDataType -eq "String") {
                    # Strings Can Only Use Equals So No If/Then for Version Operator is Used
                    if ($Key.GetValue("DisplayVersion") -eq $AppDisplayVersion) {
                    $OverallDetection = $true
                    }
                    else {
                    $OverallDetection = $false
                    }
                    }
                    elseif ($VersionDataType -eq "Integer") {
                    # Find and Match DisplayVersion Using User-Supplied Operator Logic
                    # Equal To
                    if ($VersionOperator -eq "-eq") {
                    if ([System.Version]$Key.GetValue("DisplayVersion") -eq
                    [System.Version]$AppDisplayVersion) {
                    $OverallDetection = $true
                    }
                    else {
                    $OverallDetection = $false
                    }
                    }
                    # Greater Than / Equal To
                    if ($VersionOperator -eq "-ge") {
                    if ([System.Version]$Key.GetValue("DisplayVersion") -ge
                    [System.Version]$AppDisplayVersion) {
                    $OverallDetection = $true
                    }
                    else {
                    $OverallDetection = $false
                    }
                    }
                    }
                    }
                    }
                    }
                    }

                    &lt;#
                    -----------------------------------------------------------------------------------------------------------------------------
                    Add Sub-detection Logic Modules Below This Line (If Needed)
                    -----------------------------------------------------------------------------------------------------------------------------
                    #&gt;


                    &lt;#
                    -----------------------------------------------------------------------------------------------------------------------------
                    Detection Results
                    --------------------------------------------------------------------------------------------------------------------------------
                    Final detection results based on the return and logic of the install main module
                    and the sub-detection logic modules
                    -----------------------------------------------------------------------------------------------------------------------------
                    #&gt;
                    # Wlrite Output of the OverallDetection Variable
                    if ($OverallDetection -eq $true) {
                    Write-Host "Application is installed"
                    }
                    elseif ($OverallDetection -eq $false) {
                    # Don't Write Any Output
                    }</DetectionScript>
                <InstallCommandLine>MsiExec.exe /i "NessusAgent-10.8.2-x64.msi" /qn /l*v
                    "%MECM_Directory_Logs%\Applications\Install\Tenable,Inc._NessusAgent(x64)_10.8.2.20009_Install.log"
                    NESSUS_GROUPS="Test Group" NESSUS_SERVER="fedcloud.tenable.com:443"
                    NESSUS_KEY=60c4b50e67576d2ae159d056ab548c4f67ca1024ca37e16b984bc5f9254b8c83</InstallCommandLine>
                <InstallContent ContentId="Content_5a073a8b-08ad-4120-a86d-de0b81a47998" Version="1" />
                <UninstallSetting>NoneRequired</UninstallSetting>
                <InstallFolder />
                <UninstallCommandLine>
                    MsiExec.exe /x {8BDE7E7C-9AC3-4255-BC0A-A1109B440107} /qn /l*v
                    "%MECM_Directory_Logs%\Applications\Uninstall\Tenable,Inc._NessusAgent(x64)_10.8.2.20009_Uninstall.log"</UninstallCommandLine>
                <UninstallFolder />
                <RepairCommandLine />
                <RepairFolder />
                <ExecuteTime>5</ExecuteTime>
                <MaxExecuteTime>30</MaxExecuteTime>
                <ExitCodes>
                    <ExitCode Code="0" Class="Success" />
                    <ExitCode Code="1707" Class="Success" />
                    <ExitCode Code="3010" Class="SoftReboot" />
                    <ExitCode Code="1641" Class="HardReboot" />
                    <ExitCode Code="1618" Class="FastRetry" />
                </ExitCodes>
                <UserInteractionMode>Hidden</UserInteractionMode>
                <AllowUninstall>true</AllowUninstall>
            </CustomData>
        </Installer>
    </DeploymentType>
</AppMgmtDigest>
```

