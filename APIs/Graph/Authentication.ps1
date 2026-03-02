#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------
[CmdletBinding()]
param (
    
    [Parameter(Mandatory=$false)]
    [string]$TenantId,                # Azure AD Tenant ID
    [Parameter(Mandatory=$false)]
    [string]$ClientId,                # Azure AD App Registration Client ID
    [Parameter(Mandatory=$false)]
    [string]$ClientSecret,            # Azure AD App Registration Client Secret
    [Parameter(Mandatory=$false)]
    [string[]]$Scopes = @("https://graph.microsoft.com/.default")  # Required permissions
)

#--------------------------------------------------------------------------------------------
# Variables
#--------------------------------------------------------------------------------------------

# Prerequisites
$Prerequisite_Modules = @(
    "Microsoft.Graph.Authentication"
)

#--------------------------------------------------------------------------------------------
# Functions
#--------------------------------------------------------------------------------------------

function Connect-MsGraph {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]$TenantId,
        [Parameter(Mandatory=$false)]
        [string]$ClientId,
        [Parameter(Mandatory=$false)]
        [string]$ClientSecret,
        [Parameter(Mandatory=$false)]
        [string[]]$Scopes
    )

    try {
        # Install required module if not present
        if (-not (Get-Module -ListAvailable -Name "Microsoft.Graph.Authentication")) {
            Install-Module -Name "Microsoft.Graph.Authentication" -Force -Scope CurrentUser
        }

        # Connect using interactive authentication if no credentials provided
        if (-not $TenantId -or -not $ClientId -or -not $ClientSecret) {
            Write-Host "Connecting to Microsoft Graph using interactive authentication..."
            Connect-MgGraph -Scopes $Scopes
        }
        # Connect using service principal authentication
        else {
            Write-Host "Connecting to Microsoft Graph using service principal authentication..."
            $SecureSecret = ConvertTo-SecureString -String $ClientSecret -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential($ClientId, $SecureSecret)
            Connect-MgGraph -TenantId $TenantId -ClientId $ClientId -ClientSecretCredential $Credential
        }

        # Verify connection
        $Context = Get-MgContext
        if ($Context) {
            Write-Host "Successfully connected to Microsoft Graph API"
            Write-Host "Tenant ID: $($Context.TenantId)"
            Write-Host "Account: $($Context.Account)"
            Write-Host "Scopes: $($Context.Scopes -join ', ')"
            return $true
        }
        else {
            throw "Failed to establish connection to Microsoft Graph API"
        }
    }
    catch {
        Write-Error "Error connecting to Microsoft Graph API: $_"
        return $false
    }
}

#--------------------------------------------------------------------------------------------
# Main Script
#--------------------------------------------------------------------------------------------

# Connect to Microsoft Graph
$Connected = Connect-MsGraph -TenantId $TenantId -ClientId $ClientId -ClientSecret $ClientSecret -Scopes $Scopes

if ($Connected) {
    Write-Host "Ready to use Microsoft Graph API"
}
else {
    Write-Error "Failed to connect to Microsoft Graph API"
    exit 1
} 