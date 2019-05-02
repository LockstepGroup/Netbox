function Get-NetboxSite {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $True, Position = 0)]
        [int]$SiteId,

        [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $True)]
        [int]$TenantId
    )

    BEGIN {
        $VerbosePrefix = "Get-NetboxSite:"
        $ReturnObject = @()
    }

    PROCESS {
        $QueryPage = 'dcim/sites/'
        if ($SiteId) {
            $QueryPage += $SiteId + '/'
        }

        try {
            $Response = $global:NetboxServerConnection.invokeApiQuery($QueryPage)
            if ($Response.Results) {
                $LoopResults = $Response.Results
            } else {
                $LoopResults = @($Response)
            }
        } catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }

        foreach ($r in $LoopResults) {
            $New = [NetboxTenant]::new()
            $ReturnObject += $New

            $New.TenantId = $r.id
            $New.Name = $r.name
            $New.Slug = $r.slg
            $New.Description = $r.description
            $New.Comments = $r.comments
            $New.Tags = $r.tags

            # Group
            $New.GroupId = $r.group.id
            $New.GroupName = $r.group.name

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