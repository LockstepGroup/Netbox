function New-NetboxManufacturer {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [string]$Slug,

        [Parameter(Mandatory = $false)]
        [int]$Id
    )

    BEGIN {
        $VerbosePrefix = "New-NetboxManufacturer:"
    }

    PROCESS {
        if (-not $Slug) {
            $Slug = $Name.ToLower() -replace ' ', '-'
        }

        $New = [NetboxManufacturer]::new()
        $New.ManufacturerName = $Name
        $New.Slug = $Slug
        $New.ManufacturerId = $Id
    }

    END {
        $New
    }
}
