class NetboxSite {
    [int]$SiteId
    [string]$SiteName
    [string]$Slug
    [array]$Tags

    # Status
    [int]$StatusValue
    [string]$Status

    # Region
    [int]$RegionId
    [string]$RegionName

    # Tenant
    [int]$TenantId
    [string]$TenantName

    # Details
    [string]$Facility
    [int]$ASN
    [string]$TimeZone
    [string]$Description
    [string]$PhysicalAddress
    [string]$ShippingAddress
    [string]$Latitude
    [string]$Longitude
    [string]$ContactName
    [string]$ContactPhone
    [string]$ContactEmail
    [string]$Comments

    # Counts
    [int]$PrefixCount
    [int]$VlanCount
    [int]$RackCount
    [int]$DeviceCount
    [int]$CircuitCount

    # Custom Fields
    [hashtable]$CustomFields

    #Timestamps
    [datetime]$Created
    [datetime]$LastUpdated

    #region Initiators
    ###################################################################################################
    # Blank Initiator
    NetboxSite() {
    }

    #endregion Initiators
}