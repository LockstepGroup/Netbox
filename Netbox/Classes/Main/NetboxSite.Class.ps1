class NetboxSite {
    [int]$SiteId
    [string]$Name
    [string]$Slug

    # Status
    [int]$StatusId
    [string]$Status

    # Region
    [int]$RegionId
    [string]$Region

    # Tenant
    [int]$TenantId
    [string]$Tenant


    #region Initiators
    ###################################################################################################
    # Blank Initiator
    NetboxSite() {
    }

    #endregion Initiators
}