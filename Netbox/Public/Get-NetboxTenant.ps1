function Get-NetboxTenant {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $True, ParameterSetName = 'TenantId')]
        [int]$TenantId,

        [Parameter(Mandatory = $true, ParameterSetName = 'TenantName')]
        [string]$TenantName,

        [Parameter(Mandatory = $true, ValueFromPipeline = $True, ParameterSetName = 'TenantGroup')]
        [NetboxTenantGroup]$NetboxTenantGroup
    )

    BEGIN {
        $VerbosePrefix = "Get-NetboxTenant:"
        Write-Verbose "$VerbosePrefix ParameterSetName (BEGIN): $($PSCmdlet.ParameterSetName)"
        $ReturnObject = @()
    }

    PROCESS {
        Write-Verbose "$VerbosePrefix ParameterSetName (PROCESS): $($PSCmdlet.ParameterSetName)"
        $QueryPage = 'tenancy/tenants/'
        if ($TenantId) {
            $QueryPage += "$TenantId/"
        }

        if ($TenantName) {
            $QueryPage += '?name=' + $TenantName
        }

        if ($NetboxTenantGroup) {
            $QueryPage += '?group=' + $NetboxTenantGroup.Slug
        }

        try {
            $Response = $global:NetboxServerConnection.invokeApiQuery($QueryPage)
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
            $New = [NetboxTenant]::new()
            $ReturnObject += $New

            $New.TenantId = $r.id
            $New.TenantName = $r.name
            $New.Slug = $r.slug
            $New.Description = $r.description
            $New.Comments = $r.comments
            $New.Tags = $r.tags

            # Group
            $New.TenantGroupId = $r.group.id
            $New.TenantGroupName = $r.group.name

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