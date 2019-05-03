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
            $New = [NetboxSite]::new()
            $ReturnObject += $New

            # Main Props
            $New.SiteId = $r.id
            $New.SiteName = $r.name
            $New.Slug = $r.slug
            $New.Tags = $r.tags

            # Status
            $New.StatusValue = $r.status.value
            $New.Status = $r.status.value

            # Region
            $New.RegionId = $r.region.id
            $New.RegionName = $r.region.name

            # Tenant
            $New.TenantId = $r.tenant.id
            $New.TenantName = $r.tenant.name

            # Details
            $New.Facility = $r.facility
            $New.ASN = $r.asn
            $New.TimeZone = $r.time_zone
            $New.Description = $r.description
            $New.PhysicalAddress = $r.physical_address
            $New.ShippingAddress = $r.shipping_address
            $New.Latitude = $r.latitude
            $New.Longitude = $r.longitude
            $New.ContactName = $r.contact_name
            $New.ContactPhone = $r.contact_phone
            $New.ContactEmail = $r.contact_email
            $New.Comments = $r.comments

            # Counts
            $New.PrefixCount = $r.count_prefixes
            $New.VlanCount = $r.count_vlans
            $New.RackCount = $r.count_racks
            $New.DeviceCount = $r.count_devices
            $New.CircuitCount = $r.count_circuits

            # Custom Fields
            $New.CustomFields = $r.custom_fields
        }
    }

    END {
        $ReturnObject
    }
}