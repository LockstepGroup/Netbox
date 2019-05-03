function New-NetboxSite {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [string]$Slug,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Active', 'Planned', 'Retired')]
        [string]$Status,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $True)]
        [int]$RegionId,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $True)]
        [int]$TenantId,

        [Parameter(Mandatory = $false)]
        [string]$Facility,

        [Parameter(Mandatory = $false)]
        [int]$Asn,

        [Parameter(Mandatory = $false)]
        [string]$TimeZone,

        [Parameter(Mandatory = $false)]
        [string]$Description,

        [Parameter(Mandatory = $false)]
        [string]$PhysicalAddress,

        [Parameter(Mandatory = $false)]
        [string]$ShippingAddress,

        [Parameter(Mandatory = $false)]
        [string]$Latitude,

        [Parameter(Mandatory = $false)]
        [string]$Longitude,

        [Parameter(Mandatory = $false)]
        [string]$ContactName,

        [Parameter(Mandatory = $false)]
        [string]$ContactPhone,

        [Parameter(Mandatory = $false)]
        [string]$ContactEmail,

        [Parameter(Mandatory = $false)]
        [string]$Comments,

        [Parameter(Mandatory = $false)]
        [string[]]$Tags
    )

    BEGIN {
        $VerbosePrefix = "New-NetboxSite:"
        $ReturnObject = @()

        $StatusMap = @{
            Active  = 1
            Planned = 2
            Retired = 4
        }
    }

    PROCESS {
        $QueryPage = 'dcim/sites/'

        ###############################################################
        #region Body

        # If slug not specified, set it equal to the name in lowercase
        if (-not $Slug) {
            $Slug = $Name.ToLower() -replace ' ', '-'
        }

        # Name/Slug
        $Body = @{
            name = $Name
            slug = $Slug
        }

        # Status
        if ($Status) {
            $Body.status = $StatusMap.$Status
        }

        # Region
        if ($RegionId) { $Body.region = $RegionId }

        # TenantId
        if ($TenantId) { $Body.tenant = $TenantId }

        # Facilty
        if ($Facility) { $Body.facility = $Facility }

        # Asn
        if ($Asn) { $Body.asn = $Asn }

        # TimeZone
        if ($TimeZone) { $Body.time_zone = $TimeZone }

        # Description
        if ($Description) { $Body.description = $Description }

        # PhysicalAddress
        if ($PhysicalAddress) { $Body.physical_address = $PhysicalAddress }

        # ShippingAddress
        if ($ShippingAddress) { $Body.shipping_address = $ShippingAddress }

        # Latitude
        if ($Latitude) { $Body.latitude = $Latitude }

        # Longitude
        if ($Longitude) { $Body.longitude = $Longitude }

        # ContactName
        if ($ContactName) { $Body.contact_name = $ContactName }

        # ContactPhone
        if ($ContactPhone) { $Body.contact_phone = $ContactPhone }

        # ContactEmail
        if ($ContactEmail) { $Body.contact_email = $ContactEmail }

        # Comments
        if ($Comments) { $Body.comments = $Comments }

        # Tags
        if ($Tags) {
            $Body.tags = $Tags | ConvertTo-Json -Compress
        }

        #endregion Body
        ###############################################################

        ###############################################################
        #region invokeQuery

        $Response = $global:NetboxServerConnection.invokePostApiQuery($QueryPage, $Body)

        #endregion invokeQuery
        ###############################################################

        ###############################################################
        #region CreateReturnObject

        $New = [NetboxSite]::new()
        $ReturnObject += $New

        # Main Props
        $New.SiteId = $Response.id
        $New.SiteName = $Response.name
        $New.Slug = $Response.slug
        $New.Tags = $Response.tags

        # Status
        $New.StatusValue = $Response.status.value
        $New.Status = $Response.status.label

        # Region
        $New.RegionId = $Response.region.id
        $New.RegionName = $Response.region.name

        # Tenant
        $New.TenantId = $Response.tenant.id
        $New.TenantName = $Response.tenant.name

        # Details
        $New.Facility = $Response.facility
        $New.ASN = $Response.asn
        $New.TimeZone = $Response.time_zone
        $New.Description = $Response.description
        $New.PhysicalAddress = $Response.physical_address
        $New.ShippingAddress = $Response.shipping_address
        $New.Latitude = $Response.latitude
        $New.Longitude = $Response.longitude
        $New.ContactName = $Response.contact_name
        $New.ContactPhone = $Response.contact_phone
        $New.ContactEmail = $Response.contact_email
        $New.Comments = $Response.comments

        # Counts
        $New.PrefixCount = $Response.count_prefixes
        $New.VlanCount = $Response.count_vlans
        $New.RackCount = $Response.count_racks
        $New.DeviceCount = $Response.count_devices
        $New.CircuitCount = $Response.count_circuits

        # Custom Fields
        $New.CustomFields = $Response.custom_fields

        #endregion CreateReturnObject
        ###############################################################
    }

    END {
        $ReturnObject
    }
}