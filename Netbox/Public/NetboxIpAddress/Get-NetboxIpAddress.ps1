function Get-NetboxIpAddress {
    [CmdletBinding(DefaultParametersetname = "NetboxId")]

    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'NetboxId')]
        [string]$NetboxId,

        [Parameter(Mandatory = $true, ValueFromPipeline = $True, ParameterSetName = 'NetboxVrf')]
        [NetboxVrf]$NetboxVrf,

        [Parameter(Mandatory = $false)]
        [string]$IpAddress
    )

    BEGIN {
        $VerbosePrefix = "Get-NetboxIpAddress:"
        Write-Verbose "$VerbosePrefix ParameterSetName (BEGIN): $($PSCmdlet.ParameterSetName)"
        $ReturnObject = @()
    }

    PROCESS {
        Write-Verbose "$VerbosePrefix ParameterSetName (PROCESS): $($PSCmdlet.ParameterSetName)"
        $QueryPage = [NetboxIpAddress]::BaseQueryPage
        $QueryHashTable = @{}

        switch ($PSCmdlet.ParameterSetName) {
            'NetboxId' {
                if ($NetboxId) {
                    $QueryPage += "$NetboxId/"
                    continue
                }
            }
            'NetboxVrf' {
                $QueryHashTable.vrf = $NetboxVrf.RouteDistinguisher

                if ($IpAddress) {
                    $QueryHashTable.address = $IpAddress
                }
                continue
            }
        }

        try {
            Write-Verbose "$VerbosePrefix QueryPage: $QueryPage"
            $Response = $global:NetboxServerConnection.invokeApiQuery($QueryPage, $QueryHashTable)
            if ($TenantName -and ($Response.count -eq 0)) {
                Write-Warning "$VerbosePrefix No results found, keep in mind that all netbox names are case-sensitive."
            } else {
                if ($Response.Results) {
                    $LoopResults = $Response.Results
                } else {
                    $LoopResults = @($Response)
                }
            }
        } catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }

        foreach ($r in $LoopResults) {
            $New = New-NetboxIpAddress -IpAddress $r.address
            $ReturnObject += $New

            $New.NetboxId = $r.id
            $New.IpFamily = $r.family
            $New.Description = $r.description
            $New.Tags = $r.tags

            # Interface
            $New.InterfaceId = $r.interface.id
            $New.InterfaceName = $r.interface.name

            # Device
            $New.DeviceId = $r.interface.device.id
            $New.DeviceName = $r.interface.device.name

            # NatInside
            $New.NatInsideId = $r.nat_inside.id
            $New.NatInsideAddress = $r.nat_inside.address

            # NatOutside
            $New.NatOutsideId = $r.nat_outside.id
            $New.NatOutsideAddress = $r.nat_outside.address

            # Vrf
            $New.VrfId = $r.vrf.id
            $New.VrfName = $r.vrf.name

            # Tenant
            $New.TenantId = $r.tenant.id
            $New.TenantName = $r.tenant.name

            # Status
            $New.Status = $r.status.label

            # Role
            $New.RoleId = $r.role.id
            $New.RoleName = $r.role.name

            # Custom Fields
            $New.CustomFields = $r.custom_fields

            #Timestamps
            $New.Created = $r.created
            $New.LastUpdated = $r.last_updated
        }
    }

    END {
        Write-Verbose "$VerbosePrefix ParameterSetName (END): $($PSCmdlet.ParameterSetName)"
        $ReturnObject
    }
}