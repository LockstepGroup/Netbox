class NetboxTenant {
    [int]$TenantId
    [string]$Name
    [string]$Slug
    [string]$Description
    [string]$Comments
    [array]$Tags

    # Group
    [int]$GroupId
    [string]$GroupName

    # Custom Fields
    [hashtable]$CustomFields

    #Timestamps
    [datetime]$Created
    [datetime]$LastUpdated

    #region Initiators
    ###################################################################################################
    # Blank Initiator, just used for debug/troubleshooting
    NetboxTenant() {
    }

    #endregion Initiators
}