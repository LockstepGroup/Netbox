function Get-NetboxPrefix {
    [CmdletBinding(DefaultParametersetname = "NetboxId")]

    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'NetboxId')]
        [string]$NetboxId,

        [Parameter(Mandatory = $true, ValueFromPipeline = $True, ParameterSetName = 'NetboxTenant')]
        [NetboxTenant]$NetboxTenant,

        [Parameter(Mandatory = $false)]
        [string]$Prefix
    )

    BEGIN {
        $VerbosePrefix = "Get-NetboxPrefix:"
        Write-Verbose "$VerbosePrefix ParameterSetName (BEGIN): $($PSCmdlet.ParameterSetName)"
        $ReturnObject = @()
    }

    PROCESS {
        Write-Verbose "$VerbosePrefix ParameterSetName (PROCESS): $($PSCmdlet.ParameterSetName)"
        $QueryPage = [NetboxPrefix]::BaseQueryPage
        $QueryHashTable = @{}

        switch ($PSCmdlet.ParameterSetName) {
            'NetboxId' {
                $QueryPage += "$NetboxId/"
                continue
            }
            'NetboxTenant' {
                $QueryHashTable.tenant = $NetboxTenant.slug

                if ($Prefix) {
                    $QueryHashTable.prefix = $Prefix
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
            $New = New-NetboxPrefix -Prefix $r.prefix
            $ReturnObject += $New

            $New.NetboxId = $r.id
            $New.IpFamily = $r.family
            $New.IsPool = $r.is_pool
            $New.Description = $r.description
            $New.Tags = $r.tags

            # Tenant
            $New.SiteId = $r.site.id
            $New.SiteName = $r.site.name

            # Vrf
            $New.VrfId = $r.vrf.id
            $New.VrfName = $r.vrf.name

            # Tenant
            $New.TenantId = $r.tenant.id
            $New.TenantName = $r.tenant.name

            # Vlan
            $New.VlanId = $r.vlan.id
            $New.VlanTag = $r.vlan.vid
            $New.VlanName = $r.vlan.name

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