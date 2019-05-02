function Get-NetboxTenant {
    [CmdletBinding(DefaultParametersetName = "TenantId")]

    Param (
        [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $True, ParameterSetName = 'TenantId', Position = 0)]
        [int]$TenantId,

        [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $True, ParameterSetName = 'TenantName', Position = 0)]
        [string]$TenantName,

        [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $True, ParameterSetName = 'TenantGroupId')]
        [int]$TenantGroupId
    )

    BEGIN {
        $VerbosePrefix = "Get-NetboxTenant:"
        $ReturnObject = @()
    }

    PROCESS {
        $QueryPage = 'tenancy/tenants/'
        if ($TenantId) {
            $QueryPage += "$TenantId/"
        }

        if ($TenantName) {
            $QueryPage += '?name=' + $TenantName
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
            $New.Name = $r.name
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
        $ReturnObject
    }
}