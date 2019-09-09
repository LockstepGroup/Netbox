class NetboxVlan {
    [int]$VlanId
    [int]$VlanTag
    [string]$VlanName
    [string]$Slug
    [string]$Status
    [string]$Description
    [array]$Tags

    # Site
    [int]$SiteId
    [string]$SiteName

    # Tenant
    [int]$TenantId
    [string]$TenantName


    # Custom Fields
    [hashtable]$CustomFields

    #Timestamps
    [datetime]$Created
    [datetime]$LastUpdated

    #region Initiators
    ###################################################################################################
    # Blank Initiator
    NetboxVlan() {
    }

    #endregion Initiators
}