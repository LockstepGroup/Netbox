function New-NetboxIpAddress {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$IpAddress,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Active', 'Reserved', 'Deprecated', 'DHCP')]
        [string]$Status,

        [Parameter(Mandatory = $false)]
        [int]$VrfId,

        [Parameter(Mandatory = $false)]
        [int]$RoleId,

        [Parameter(Mandatory = $false)]
        [int]$TenantId,

        [Parameter(Mandatory = $false)]
        [int]$InterfaceId,

        [Parameter(Mandatory = $false)]
        [int]$DeviceId,

        [Parameter(Mandatory = $false)]
        [int]$NatInsideId,

        [Parameter(Mandatory = $false)]
        [int]$NatOutsideId,

        [Parameter(Mandatory = $false)]
        [string]$Description,

        [Parameter(Mandatory = $false)]
        [string[]]$Tags
    )

    BEGIN {
        $VerbosePrefix = "New-NetboxIpAddress:"
    }

    PROCESS {
        $ReturnObject = [NetboxIpAddress]::new()

        if ([HelperRegex]::IsIpv4Prefix($IpAddress, $true)) {
            $ReturnObject.IpFamily = 'IPv4'
        } elseif ([HelperRegex]::IsIpv4Prefix($IpAddress, $true)) {
            $ReturnObject.IpFamily = 'IPv6'
        } else {
            Throw "$VerbosePrefix Not a valid IPv4 or IPv6 Prefix"
        }

        $ReturnObject.IpAddress = $IpAddress

        $ReturnObject.VrfId = $VrfId
        $ReturnObject.TenantId = $TenantId
        $ReturnObject.Status = $Status
        $ReturnObject.RoleId = $RoleId
        $ReturnObject.InterfaceId = $InterfaceId
        $ReturnObject.DeviceId = $DeviceId
        $ReturnObject.Description = $Description
        $ReturnObject.NatInsideId = $NatInsideId
        $ReturnObject.NatOutsideId = $NatOutsideId
        $ReturnObject.Tags = $Tags
    }

    END {
        $ReturnObject
    }
}