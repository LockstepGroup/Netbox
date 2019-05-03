function New-NetboxSite {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'nogeocoding', Position = 0)]
        [Parameter(Mandatory = $true, ParameterSetName = 'geocoding', Position = 0)]
        [string]$Name,

        [Parameter(Mandatory = $false, ParameterSetName = 'nogeocoding')]
        [Parameter(Mandatory = $false, ParameterSetName = 'geocoding')]
        [string]$Slug,

        [Parameter(Mandatory = $false, ParameterSetName = 'nogeocoding')]
        [Parameter(Mandatory = $false, ParameterSetName = 'geocoding')]
        [ValidateSet('Active', 'Planned', 'Retired')]
        [string]$Status,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $True, ParameterSetName = 'nogeocoding')]
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $True, ParameterSetName = 'geocoding')]
        [int]$RegionId,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $True, ParameterSetName = 'nogeocoding')]
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $True, ParameterSetName = 'geocoding')]
        [int]$TenantId,

        [Parameter(Mandatory = $false, ParameterSetName = 'nogeocoding')]
        [Parameter(Mandatory = $false, ParameterSetName = 'geocoding')]
        [string]$Facility,

        [Parameter(Mandatory = $false, ParameterSetName = 'nogeocoding')]
        [Parameter(Mandatory = $false, ParameterSetName = 'geocoding')]
        [int]$Asn,

        [Parameter(Mandatory = $false, ParameterSetName = 'nogeocoding')]
        [Parameter(Mandatory = $false, ParameterSetName = 'geocoding')]
        [string]$TimeZone,

        [Parameter(Mandatory = $false, ParameterSetName = 'nogeocoding')]
        [Parameter(Mandatory = $false, ParameterSetName = 'geocoding')]
        [string]$Description,

        [Parameter(Mandatory = $false, ParameterSetName = 'nogeocoding')]
        [Parameter(Mandatory = $true, ParameterSetName = 'geocoding')]
        [string]$PhysicalAddress,

        [Parameter(Mandatory = $false, ParameterSetName = 'nogeocoding')]
        [Parameter(Mandatory = $false, ParameterSetName = 'geocoding')]
        [string]$ShippingAddress,

        [Parameter(Mandatory = $false, ParameterSetName = 'nogeocoding')]
        [string]$Longitude,

        [Parameter(Mandatory = $false, ParameterSetName = 'nogeocoding')]
        [string]$Latitude,

        [Parameter(Mandatory = $false, ParameterSetName = 'nogeocoding')]
        [Parameter(Mandatory = $false, ParameterSetName = 'geocoding')]
        [string]$ContactName,

        [Parameter(Mandatory = $false, ParameterSetName = 'nogeocoding')]
        [Parameter(Mandatory = $false, ParameterSetName = 'geocoding')]
        [string]$ContactPhone,

        [Parameter(Mandatory = $false, ParameterSetName = 'nogeocoding')]
        [Parameter(Mandatory = $false, ParameterSetName = 'geocoding')]
        [string]$ContactEmail,

        [Parameter(Mandatory = $false, ParameterSetName = 'nogeocoding')]
        [Parameter(Mandatory = $false, ParameterSetName = 'geocoding')]
        [string]$Comments,

        [Parameter(Mandatory = $false, ParameterSetName = 'nogeocoding')]
        [Parameter(Mandatory = $false, ParameterSetName = 'geocoding')]
        [string[]]$Tags,

        [Parameter(Mandatory = $true, ParameterSetName = 'geocoding')]
        [switch]$ResolveCoordinates
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
        if ($RegionId) {
            $Body.region = $RegionId
        }

        # TenantId
        if ($TenantId) {
            $Body.tenant = $TenantId
        }

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

        # Longitude
        if ($Longitude) { $Body.longitude = $Longitude }

        # Latitude
        if ($Latitude) { $Body.latitude = $Latitude }

        # Resolve Coordinates
        if ($ResolveCoordinates) {
            $Lookup = Get-GeoCoding -Address $PhysicalAddress
            $Body.longitude = [math]::Round($Lookup.Longitude, 6)
            $Body.latitude = [math]::Round($Lookup.Latitude, 6)
        }

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
