function Get-NetboxVlan {
    [CmdletBinding(DefaultParametersetname = "VlanId")]

    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'VlanId')]
        [int]$VlanId,

        [Parameter(Mandatory = $true, ValueFromPipeline = $True, ParameterSetName = 'NetboxTenant')]
        [NetboxTenant]$NetboxTenant,

        [Parameter(Mandatory = $true, ValueFromPipeline = $True, ParameterSetName = 'NetboxSite')]
        [NetboxSite]$NetboxSite,

        [Parameter(Mandatory = $false, ParameterSetName = 'NetboxSite')]
        [Parameter(Mandatory = $false, ParameterSetName = 'NetboxTenant')]
        [int]$VlanTag
    )

    BEGIN {
        $VerbosePrefix = "Get-NetboxVlan:"
        Write-Verbose "$VerbosePrefix ParameterSetName (BEGIN): $($PSCmdlet.ParameterSetName)"
        $ReturnObject = @()
        $QueryHashTable = @{}
    }

    PROCESS {
        Write-Verbose "$VerbosePrefix ParameterSetName (PROCESS): $($PSCmdlet.ParameterSetName)"
        $QueryPage = 'ipam/vlans/'

        if ($VlanId) {
            Write-Verbose "$VerbosePrefix Setting VlanId: $VlanId"
            $QueryPage += "$VlanId/"
        }

        if ($NetboxTenant) {
            Write-Verbose "$VerbosePrefix Setting TenantSlug: $($NetboxTenant.slug)"
            $QueryHashTable.tenant = $NetboxTenant.slug
            #$QueryPage += '?tenant=' + $NetboxTenant.slug
        }

        if ($NetboxSite) {
            Write-Verbose "$VerbosePrefix Setting TenantSlug: $($NetboxSite.slug)"
            $QueryHashTable.site = $NetboxSite.slug
            #$QueryPage += '?site=' + $NetboxSite.slug
        }

        if ($VlanTag) {
            Write-Verbose "$VerbosePrefix Setting VlanTag: $($VlanTag)"
            $QueryHashTable.vid = $VlanTag
            #$QueryPage += '?vid=' + $VlanTag
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
            $New = [NetboxVlan]::new()
            $ReturnObject += $New

            $New.VlanId = $r.id
            $New.VlanTag = $r.vid
            $New.VlanName = $r.name
            $New.Slug = $r.slug
            $New.Status = $r.status.label
            $New.Description = $r.description
            $New.Tags = $r.tags

            # Site
            $New.SiteId = $r.site.id
            $New.SiteName = $r.site.name

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