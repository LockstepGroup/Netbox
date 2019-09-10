function New-NetboxVrf {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [string]$RouteDistinguisher,

        [Parameter(Mandatory = $false)]
        [switch]$EnforceUniqueSpace,

        [Parameter(Mandatory = $false)]
        [string]$TenantName,

        [Parameter(Mandatory = $false)]
        [int]$TenantId,

        [Parameter(Mandatory = $false)]
        [string]$Description,

        [Parameter(Mandatory = $false)]
        [string[]]$Tags
    )

    BEGIN {
        $VerbosePrefix = "New-NetboxVrf:"
    }

    PROCESS {
        # set slug to name if not specified
        if (-not $RouteDistinguisher) {
            $RouteDistinguisher = $Name
        }

        # format slug correctly
        $RouteDistinguisher = Resolve-SlugName -Slug $RouteDistinguisher

        $ReturnObject = [NetboxVrf]::new()

        $ReturnObject.VrfName = $Name
        $ReturnObject.RouteDistinguisher = $RouteDistinguisher
        $ReturnObject.EnforceUniqueSpace = $EnforceUniqueSpace
        $ReturnObject.Description = $Description
        $ReturnObject.Tags = $Tags

        # Tenant
        $ReturnObject.TenantName = $TenantName
        $ReturnObject.TenantId = $TenantId
    }

    END {
        $ReturnObject
    }
}