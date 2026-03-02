#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

[CmdletBinding()]
param (
  [Parameter(Mandatory=$true, HelpMessage="Message")]
  [string]$ParamName                  # '[ExampleInputValues]'
)

#--------------------------------------------------------------------------------------------
Start-Transcript -Path "$($env:ProgramFiles)\VividRock\Intune Toolkit\Logs\Applications\Migrate MECM Applications to Intune.log" -ErrorAction SilentlyContinue

#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

  Write-Host "------------------------------------------------------------------------------"
  Write-Host "  Intune Toolkit - [Collection] - [SpecificOperation]"
  Write-Host "------------------------------------------------------------------------------"
  Write-Host "    Author:     Dustin Estes"
  Write-Host "    Company:    VividRock"
  Write-Host "    Date:       [Date]"
  Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
  Write-Host "    Purpose:    [Description]"
  Write-Host "    Links:      [Links to Helpful Source Material]"
  Write-Host "------------------------------------------------------------------------------"
  Write-Host ""

<#
  To Do:
    - Item
    - Item
#>

#EndRegion Header
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Variables
#   Error Range: 1200 - 1299
#--------------------------------------------------------------------------------------------
#Region Variables

  Write-Host "  Variables"

  # Parameters
    $Param_ParamName        = $ParamName

  # Metadata
    $Meta_Script_Start_DateTime     = Get-Date
    $Meta_Script_Complete_DateTime  = $null
    $Meta_Script_Complete_TimeSpan  = $null
    $Meta_Script_Execution_User     = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $Meta_Script_Result             = $false,"Failure"

  # Preferences
    $ErrorActionPreference  = "Stop"

  # Prerequisites
    $Prerequisite_Modules = @(
      "Microsoft.Graph.Authentication",
      "Microsoft.Graph.Intune",
      "Microsoft.Graph.Intune.PowerShell",
      "Microsoft.Graph.Devices.CorporateManagement"
    )

  # Names

  # Paths
    $Path_RESTAPI_Graph  = "https://graph.microsoft.com/v1.0/"

  # Files

  # Hashtables

  # Arrays

  # Registry
    $Registry_01 = @{
      "Path"          = "HKLM:\SOFTWARE\"
      "Name"          = ""
      "Value"         = ""
      "PropertyType"  = ""
      "Force"         = $true
      "ErrorAction"   = "Stop"
    }

  # WMI

  # Datasets
  $Dataset_Name = $null

  # Temporary

  # Output to Log
    Write-Host "    - Parameters"
    foreach ($Item in $PSBoundParameters.GetEnumerator()) {
      Write-Host "        $($Item.Key.PadRight(($PSBoundParameters.Keys | Measure-Object -Property Length -Maximum).Maximum + 1)): $($Item.Value)"
    }
    Write-Host "    - Paths"
    foreach ($Item in (Get-Variable -Name "Path_*")) {
      Write-Host "        $(($Item.Name) -replace 'Path_',''): $($Item.Value)"
    }
    Write-Host "    - Array Items"
    foreach ($Item in $Array) {
      Write-Host "        $($Item)"
    }
    Write-Host "    - Registry"
    foreach ($Item in (Get-Variable -Name "Registry_0*")) {
      Write-Host "        Path: $($Item.Value.Path)"
      Write-Host "        Name: $($Item.Value.Name)"
      Write-Host "        Value: $($Item.Value.Value)"
      Write-Host "        PropertyType: $($Item.Value.PropertyType)"
    }

  Write-Host "    - Complete"
  Write-Host ""

#EndRegion Variables
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Functions
#   Error Range: 1300 - 1399
#--------------------------------------------------------------------------------------------
#Region Functions

  Write-Host "  Functions"

  # [FunctionName]
  Write-Host "    - [FunctionName]"
  function Verb-Noun ($ParamName) {

    begin {

    }

    process {
      try {

      }
      catch {
        Write-Host "        Error"
        Write-Host "        Command Name: $($PSItem.Exception.CommandName)"
        Write-Host "        Message: $($PSItem.Exception.Message)"
        Exit 1300
      }
    }

    end {

    }
  }

  # Write Error Codes
  Write-Host "    - Write-vr_ErrorCode"
  function Write-vr_ErrorCode ($Code,$Exit,$Object) {
    # Code: XXXX   4-digit code to identify where in script the operation failed
    # Exit: Boolean option to define if  exits or not
    # Object: The error object created when the script encounters an error ($Error[0], $PSItem, etc.)

    begin {

    }

    process {
      Write-Host "        Error: $($Object.Exception.ErrorId)"
      Write-Host "        Command Name: $($Object.CategoryInfo.Activity)"
      Write-Host "        Message: $($Object.Exception.Message)"
      Write-Host "        Line/Position: $($Object.Exception.Line)/$($Object.Exception.Offset)"
    }

    end {
      switch ($Exit) {
        $true {
          Write-Host "        Exit: $($Code)"
          Stop-Transcript
          Exit $Code
        }
        $false {
          Write-Host "        Continue Processing..."
        }
        Default {
          Write-Host "        Unknown Exit option in Write-vr_ErrorCode parameter"
        }
      }
    }
  }

  Write-Host "    - Complete"
  Write-Host ""

#EndRegion Functions
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Environment
#   Error Range: 1400 - 1499
#--------------------------------------------------------------------------------------------
#Region Environment

	Write-Host "  Environment"

  # Install Modules
  Write-Host "    - Install Modules"

  try {
    foreach ($Item in $Prerequisite_Modules) {
      Write-Host "        Module: $($Item)"
      if ((Get-Module -Name $Item) -in "", $null, $false) {
        Install-Module -Name $Item -Force -Scope CurrentUser
        Write-Host "            Status: Installed"
      }
      else {
        Write-Host "            Status: Exists"
      }
    }
    Write-Host "        Status: Success"
	}
	catch {
		Write-vr_ErrorCode -Code 1401 -Exit $true -Object $PSItem
	}

	Write-Host "    - Complete"
	Write-Host ""

#EndRegion Environment
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Validation
#   Error Range: 1500 - 1599
#--------------------------------------------------------------------------------------------
#Region Validation

	Write-Host "  Validation"

  # API Routes
		Write-Host "    - API Routes"

		try {
			foreach ($Item in (Get-Variable -Name "Path_RESTAPI*")) {
				Write-Host "        Route: $($Item.Value)"

				$Temp_API_Result = Invoke-RestMethod -Uri $Item.Value -Method Get -ContentType "Application/Json" -UseDefaultCredentials
				if ($Temp_API_Result) {
					Write-Host "            Status: Success"
				}
				else {
					Write-Host "            Status: Error"
					Throw
				}
			}
		}
		catch {
			Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
		}

	# Paths
		Write-Host "    - Paths"

		try {
			foreach ($Item in (Get-Variable -Name "Path_*")) {
				Write-Host "        Path: $($Item.Value)"
				if (Test-Path -Path $Item.Value) {
					Write-Host "            Status: Exists"
				}
				else {
					New-Item -Path $Item.Value -ItemType Directory -Force | Out-Null
					Write-Host "            Status: Created"
				}
			}
		}
		catch {
			Write-vr_ErrorCode -Code 1502 -Exit $true -Object $PSItem
		}

	Write-Host "    - Complete"
	Write-Host ""

#EndRegion Validation
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Data Gather
#   Error Range: 1600 - 1699
#--------------------------------------------------------------------------------------------
#Region Data Gather

	Write-Host "  Data Gather"

	# [DatasetName]
    Write-Host "    - [DatasetName]"

    try {
      $Dataset_Name = (Invoke-RestMethod -Uri "$($Path_RESTAPI)" -Method Get -ContentType "Application/Json" -UseDefaultCredentials).value
      Write-Host "        Status: Success"
    }
    catch {
      Write-vr_ErrorCode -Code 1601 -Exit $true -Object $PSItem
    }

	# [StepName]
    Write-Host "    - [StepName]"

    try {
			Write-Host "        Status: Success"
	}
	catch {
		Write-vr_ErrorCode -Code 16XX -Exit $true -Object $PSItem
	}

	# [StepName]
    Write-Host "    - [StepName]"

	foreach ($Item in (Get-Variable -Name "Path_*")) {
		try {
		Write-Host "        $($Item.Name)"
			Write-Host "          Status: Success"
		}
		catch {
			Write-vr_ErrorCode -Code 16XX -Exit $true -Object $PSItem
		}
	}
    Write-Host "        Status: Success"

	Write-Host "    - Complete"
	Write-Host ""

#EndRegion Data Gather
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Execution
#   Error Range: 1700 - 1799
#--------------------------------------------------------------------------------------------
#Region Execution

	Write-Host "  Execution"

	# [StepName]
		Write-Host "    - [StepName]"

		try {

			Write-Host "        Status: Success"
		}
		catch {
			Write-vr_ErrorCode -Code 17XX -Exit $true -Object $PSItem
		}

	# [StepName]
    Write-Host "    - [StepName]"

		foreach ($Item in (Get-Variable -Name "Path_*")) {
			try {
		    Write-Host "        $($Item.Name)"
				Write-Host "          Status: Success"
			}
			catch {
				Write-vr_ErrorCode -Code 17XX -Exit $true -Object $PSItem
			}
		}
    Write-Host "        Status: Success"

	# Determine Script Result
		$Meta_Script_Result = $true,"Success"

	Write-Host "    - Complete"
	Write-Host ""

#EndRegion Execution
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Output
#   Error Range: 1800 - 1899
#--------------------------------------------------------------------------------------------
#Region Output

	Write-Host "  Output"

	# [StepName]
		Write-Host "    - [StepName]"

		try {

			Write-Host "        Status: Success"
		}
		catch {
			Write-vr_ErrorCode -Code 18XX -Exit $true -Object $PSItem
		}

	Write-Host "    - Complete"
	Write-Host ""

#EndRegion Output
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Cleanup
#   Error Range: 1900 - 1999
#--------------------------------------------------------------------------------------------
#Region Cleanup

	Write-Host "  Cleanup"

	# Confirm Cleanup
		Write-Host "    - Confirm Cleanup"

		do {
			$Temp_Cleanup_UserInput = Read-Host -Prompt "        Do you want to automatically clean up the unecessary content from this script? [Y]es or [N]o"
		} until (
			$Temp_Cleanup_UserInput -in "Y","Yes","N","No"
		)

	# [StepName]
		Write-Host "    - [StepName]"

		try {
			if ($Temp_Cleanup_UserInput -in "Y", "Yes") {

				Write-Host "        Status: Success"
			}
			else {
				Write-Host "            Status: Skipped"
			}
		}
		catch {
			Write-vr_ErrorCode -Code 1901 -Exit $true -Object $PSItem
		}

	Write-Host "    - Complete"
	Write-Host ""

#EndRegion Cleanup
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Footer
#--------------------------------------------------------------------------------------------
#Region Footer

	# Gather Data
		$Meta_Script_Complete_DateTime  = Get-Date
		$Meta_Script_Complete_TimeSpan  = New-TimeSpan -Start $Meta_Script_Start_DateTime -End $Meta_Script_Complete_DateTime

	# Output
		Write-Host "------------------------------------------------------------------------------"
		Write-Host "  Script Result: $($Meta_Script_Result[0])"
		Write-Host "  Script Started: $($Meta_Script_Start_DateTime.ToUniversalTime().ToString(`"yyyy-MM-dd HH:mm:ss`")) (UTC)"
		Write-Host "  Script Completed: $($Meta_Script_Complete_DateTime.ToUniversalTime().ToString(`"yyyy-MM-dd HH:mm:ss`")) (UTC)"
		Write-Host "  Total Time: $($Meta_Script_Complete_TimeSpan.Days) days, $($Meta_Script_Complete_TimeSpan.Hours) hours, $($Meta_Script_Complete_TimeSpan.Minutes) minutes, $($Meta_Script_Complete_TimeSpan.Seconds) seconds, $($Meta_Script_Complete_TimeSpan.Milliseconds) milliseconds"
		Write-Host "------------------------------------------------------------------------------"
		Write-Host "  End of Script"
		Write-Host "------------------------------------------------------------------------------"

#EndRegion Footer
#--------------------------------------------------------------------------------------------

Stop-Transcript
Return $Meta_Script_Result[0]