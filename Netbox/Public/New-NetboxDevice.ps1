function New-NetboxDevice {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $false)]
        [int]$DeviceId,

        [Parameter(Mandatory = $false)]
        [string]$DeviceName,

        [Parameter(Mandatory = $false)]
        [string]$Slug,

        [Parameter(Mandatory = $false)]
        [int]$ManufacturerId,

        [Parameter(Mandatory = $false)]
        [string]$ManufacturerName,

        [Parameter(Mandatory = $false)]
        [int]$DeviceTypeId,

        [Parameter(Mandatory = $false)]
        [string]$Model,

        [Parameter(Mandatory = $false)]
        [string]$SerialNumber,

        [Parameter(Mandatory = $false)]
        [string]$AssetTag,

        [Parameter(Mandatory = $false)]
        [int]$SiteId,

        [Parameter(Mandatory = $false)]
        [string]$SiteName,

        [Parameter(Mandatory = $false)]
        [int]$RackId,

        [Parameter(Mandatory = $false)]
        [string]$RackName,

        [Parameter(Mandatory = $false)]
        [string]$RackFace,

        [Parameter(Mandatory = $false)]
        [string]$RackPosition,

        [Parameter(Mandatory = $false)]
        [string]$Status,

        [Parameter(Mandatory = $false)]
        [string]$Platform,

        [Parameter(Mandatory = $false)]
        [int]$TenantGroupId,

        [Parameter(Mandatory = $false)]
        [string]$TenantGroupName,

        [Parameter(Mandatory = $false)]
        [string]$LocalConfigContextData,

        [Parameter(Mandatory = $false)]
        [array]$Tags,

        [Parameter(Mandatory = $false)]
        [string]$Comments
    )

    BEGIN {
        $VerbosePrefix = "New-NetboxDevice:"
        $ReturnObject = @()
    }

    PROCESS {
        ###############################################################
        #region CreateReturnObject

        $New = [NetboxDevice]::new()
        $ReturnObject += $New

        [int]$DeviceId =
        [string]$DeviceName =
        [string]$Slug =

        # Hardware
        [int]$ManufacturerId
        [string]$ManufacturerName
        [int]$DeviceTypeId
        [string]$Model
        [string]$SerialNumber
        [string]$AssetTag

        # Location
        [int]$SiteId
        [string]$SiteName
        [int]$RackId
        [string]$RackName
        [string]$RackFace
        [string]$RackPosition

        # Management
        [string]$Status
        [string]$Platform

        # TenantGroup
        [int]$TenantGroupId
        [string]$TenantGroupName

        # Local Config Context Data
        [string]$LocalConfigContextData

        # Tags
        [array]$Tags

        # Comments
        [string]$Comments

        #endregion CreateReturnObject
        ###############################################################
    }

    END {
        $ReturnObject
    }
}
