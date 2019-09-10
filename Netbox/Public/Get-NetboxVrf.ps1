function Get-NetboxVrf {
    [CmdletBinding(DefaultParametersetname = "NetboxId")]

    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'NetboxId')]
        [int]$VrfId,

        [Parameter(Mandatory = $true, ValueFromPipeline = $True, ParameterSetName = 'NetboxTenant')]
        [NetboxTenant]$NetboxTenant,

        [Parameter(Mandatory = $false, ParameterSetName = 'NetboxTenant')]
        [string]$VrfName
    )

    BEGIN {
        $VerbosePrefix = "Get-NetboxVrf:"
        Write-Verbose "$VerbosePrefix ParameterSetName (BEGIN): $($PSCmdlet.ParameterSetName)"
        $ReturnObject = @()
    }

    PROCESS {
        Write-Verbose "$VerbosePrefix ParameterSetName (PROCESS): $($PSCmdlet.ParameterSetName)"
        $QueryPage = [NetboxVrf]::BaseQueryPage
        $QueryHashTable = @{}

        switch ($PSCmdlet.ParameterSetName) {
            'NetboxId' {
                $QueryPage += "$VrfId/"
                continue
            }
            'NetboxTenant' {
                $QueryHashTable.tenant = $NetboxTenant.slug

                if ($VrfName) {
                    $QueryHashTable.name = $VrfName
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
            $New = New-NetboxVrf -Name $r.name
            $ReturnObject += $New

            $New.VrfId = $r.id
            $New.RouteDistinguisher = $r.rd
            $New.EnforceUniqueSpace = $r.enforce_unique
            $New.Description = $r.description
            $New.Tags = $r.tags

            # Tenant
            $New.TenantId = $r.tenant.id
            $New.TenantName = $r.tenant.name


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