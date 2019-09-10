function New-NetboxPrefix {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Prefix,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Container', 'Active', 'Reserved', 'Deprecated')]
        [string]$Status,

        [Parameter(Mandatory = $false)]
        [int]$VrfId,

        [Parameter(Mandatory = $false)]
        [int]$RoleId,

        [Parameter(Mandatory = $false)]
        [int]$TenantId,

        [Parameter(Mandatory = $false)]
        [int]$SiteId,

        [Parameter(Mandatory = $false)]
        [int]$VlanId,

        [Parameter(Mandatory = $false)]
        [string]$Description,

        [Parameter(Mandatory = $false)]
        [string[]]$Tags
    )

    BEGIN {
        $VerbosePrefix = "New-NetboxPrefix:"
    }

    PROCESS {
        $ReturnObject = [NetboxPrefix]::new()

        if ([HelperRegex]::IsIpv4Prefix($Prefix, $true)) {
            $ReturnObject.IpFamily = 'IPv4'
        } elseif ([HelperRegex]::IsIpv6Prefix($Prefix, $true)) {
            $ReturnObject.IpFamily = 'IPv6'
        } else {
            Throw "$VerbosePrefix Not a valid IPv4 or IPv6 Prefix"
        }

        $ReturnObject.Prefix = $Prefix
        $ReturnObject.Status = $Status
        $ReturnObject.VrfId = $VrfId
        $ReturnObject.TenantId = $TenantId
        $ReturnObject.SiteId = $SiteId
        $ReturnObject.VlanId = $VlanId
        $ReturnObject.Description = $Description
        $ReturnObject.Tags = $Tags
    }

    END {
        $ReturnObject
    }
}