function New-NetboxDeviceType {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'NetboxManufacturer', ValueFromPipeline = $True, Position = 0)]
        [NetboxManufacturer]$NetboxManufacturer,

        [Parameter(Mandatory = $true, ParameterSetName = 'NoNetboxManufacturer', Position = 0)]
        [int]$ManufacturerId,

        [Parameter(Mandatory = $true, ParameterSetName = 'NetboxManufacturer', Position = 1)]
        [Parameter(Mandatory = $true, ParameterSetName = 'NoNetboxManufacturer', Position = 1)]
        [string]$Model,

        [Parameter(Mandatory = $false, ParameterSetName = 'NetboxManufacturer')]
        [Parameter(Mandatory = $false, ParameterSetName = 'NoNetboxManufacturer')]
        [string]$Slug,

        [Parameter(Mandatory = $false, ParameterSetName = 'NetboxManufacturer')]
        [Parameter(Mandatory = $false, ParameterSetName = 'NoNetboxManufacturer')]
        [string]$PartNumber,

        [Parameter(Mandatory = $false, ParameterSetName = 'NetboxManufacturer')]
        [Parameter(Mandatory = $false, ParameterSetName = 'NoNetboxManufacturer')]
        [int]$UHeight,

        [Parameter(Mandatory = $false, ParameterSetName = 'NetboxManufacturer')]
        [Parameter(Mandatory = $false, ParameterSetName = 'NoNetboxManufacturer')]
        [switch]$IsFullDepth,

        [Parameter(Mandatory = $false, ParameterSetName = 'NetboxManufacturer')]
        [Parameter(Mandatory = $false, ParameterSetName = 'NoNetboxManufacturer')]
        [ValidateSet('Parent', 'Child')]
        [string]$SubDeviceRole,

        [Parameter(Mandatory = $false, ParameterSetName = 'NetboxManufacturer')]
        [Parameter(Mandatory = $false, ParameterSetName = 'NoNetboxManufacturer')]
        [string]$Comments,

        [Parameter(Mandatory = $false, ParameterSetName = 'NetboxManufacturer')]
        [Parameter(Mandatory = $false, ParameterSetName = 'NoNetboxManufacturer')]
        [string[]]$Tags,

        [Parameter(Mandatory = $false, ParameterSetName = 'NetboxManufacturer')]
        [Parameter(Mandatory = $false, ParameterSetName = 'NoNetboxManufacturer')]
        [int]$Id
    )

    BEGIN {
        $VerbosePrefix = "New-NetboxDeviceType:"
    }

    PROCESS {
        if (-not $Slug) {
            $Slug = $Model.ToLower() -replace ' ', '-'
        }

        $New = [NetboxDeviceType]::new()

        # Primary Properties
        $New.DeviceTypeId = $Id
        $New.Model = $Model
        $New.Slug = $Slug

        # Manufacturer
        if ($NetboxManufacturer) {
            $New.ManufacturerId = $NetboxManufacturer.ManufacturerId
        } else {
            $New.ManufacturerId = $ManufacturerId
        }

        # Details
        $New.PartNumber = $PartNumber
        $New.UHeight = $UHeight
        $New.IsFullDepth = $IsFullDepth
        $New.SubDeviceRole = $SubDeviceRole
        $New.Comments = $Comments
        $New.Tags = $Tags

    }

    END {
        $New
    }
}
