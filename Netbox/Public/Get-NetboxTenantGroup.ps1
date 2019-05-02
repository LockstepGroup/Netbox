function Get-NetboxTenantGroup {
    [CmdletBinding(DefaultParametersetName = "TenantGroupId")]

    Param (
        [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $True, ParameterSetName = 'TenantGroupId', Position = 0)]
        [int]$TenantGroupId,

        [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $True, ParameterSetName = 'TenantGroupName', Position = 0)]
        [string]$TenantGroupName
    )

    BEGIN {
        $VerbosePrefix = "Get-NetboxTenantGroup:"
        $ReturnObject = @()
    }

    PROCESS {
        $QueryPage = 'tenancy/tenant-groups/'
        if ($TenantGroupId) {
            $QueryPage += "$TenantGroupId/"
        }

        if ($TenantGroupName) {
            $QueryPage += '?name=' + $TenantGroupName
        }

        try {
            $Response = $global:NetboxServerConnection.invokeApiQuery($QueryPage)
            if ($TenantGroupName -and ($Response.count -eq 0)) {
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
            $New = [NetboxTenantGroup]::new()
            $ReturnObject += $New

            $New.TenantGroupId = $r.id
            $New.TenantGroupName = $r.name
            $New.Slug = $r.slug
        }
    }

    END {
        $ReturnObject
    }
}