# Intune Toolkit - APIs - Graph

<br>

## Table of Contents

- [Intune Toolkit - APIs - Graph](#intune-toolkit---apis---graph)
  - [Table of Contents](#table-of-contents)
- [Authentication](#authentication)
- [Applications](#applications)
  - [Queries](#queries)
  - [\[ActionCategory\]](#actioncategory)
    - [\[Function\]](#function)
      - [Web URI](#web-uri)
      - [PowerShell](#powershell)
- [Appendices](#appendices)
  - [Apdx A: \[Name\]](#apdx-a-name)
- [Apdx B: Template](#apdx-b-template)
  - [Queries](#queries-1)
  - [\[ActionCategory\]](#actioncategory-1)
    - [\[Function\]](#function-1)
      - [Web URI](#web-uri-1)
      - [PowerShell](#powershell-1)

<br>

# Authentication

TODO: Add section on how to perform authentication using various scripting languages (PowerShell, Go, etc.)

https://learn.microsoft.com/en-us/powershell/module/microsoft.graph.authentication/?view=graph-powershell-1.0

```powershell
# Parameters

# Function

# Execution
```

# Applications

## Queries

| Description | URI | Examples |
|-|-|-|
| Get a list of all applications          | https://graph.microsoft.com/v1.0/deviceAppManagement/mobileApps | N/A |
| Get a list of all applications of a specific type | https://graph.microsoft.com/v1.0/deviceAppManagement/mobileApps?$filter=isof('[appType]') | appType = microsoft.graph.win32LobApp |
| Get a details and expanded properties of a specific application | https://graph.microsoft.com/v1.0/deviceAppManagement/mobileApps?$filter=isof('[appType]') | appType = microsoft.graph.win32LobApp |

<br>

## [ActionCategory]

[Description]

### [Function]

[Description]

-  Namespace: [microsoft.graph.deviceAppManagement.mobileApps](https://graph.microsoft.com/v1.0/deviceAppManagement/mobileApps) 
-  Response: [win32LobApp](https://learn.microsoft.com/en-us/graph/api/resources/intune-apps-win32lobapp?view=graph-rest-1.0)

| Property | Type | Required | Description |
|-|-|-|-|

#### Web URI

```https://graph.microsoft.com/v1.0/[Resource][QueryOptions]```

#### PowerShell

Snippet

```powershell

```

Output

```powershell

```

<br>

# Appendices

A collection of sections that provide detailed explanation or understanding to the above topic but are not necessary within the main body of the topic.

## Apdx A: [Name]

[Text]

<br>

# Apdx B: Template

## Queries

| Description | URI |
|-|-|
| [Text] | [URIQuery] |

<br>

## [ActionCategory]

[Description]

### [Function]

[Description]

-  Namespace: [microsoft.graph.deviceAppManagement.mobileApps](https://graph.microsoft.com/v1.0/deviceAppManagement/mobileApps) 
-  Response: [win32LobApp](https://learn.microsoft.com/en-us/graph/api/resources/intune-apps-win32lobapp?view=graph-rest-1.0)

| Property | Type | Required | Description |
|-|-|-|-|

#### Web URI

```https://graph.microsoft.com/v1.0/[Resource][QueryOptions]```

#### PowerShell

Snippet

```powershell

```

Output

```powershell

```