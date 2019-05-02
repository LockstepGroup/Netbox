class NetboxTenant {
    [int]$TenantId
    [string]$Name
    [string]$Slug
    [string]$Description
    [string]$Comments
    [array]$Tags

    # TenantGroup
    [int]$TenantGroupId
    [string]$TenantGroupName

    # Custom Fields
    [hashtable]$CustomFields

    #Timestamps
    [datetime]$Created
    [datetime]$LastUpdated

    #region Initiators
    ###################################################################################################
    # Blank Initiator
    NetboxTenant() {
    }

    #endregion Initiators
}