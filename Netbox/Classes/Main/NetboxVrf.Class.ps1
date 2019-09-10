class NetboxVrf {
    [int]$VrfId
    [string]$VrfName
    [string]$RouteDistinguisher
    [bool]$EnforceUniqueSpace
    [string]$Description
    [array]$Tags

    # Tenant
    [int]$TenantId
    [string]$TenantName


    # Custom Fields
    [hashtable]$CustomFields

    #Timestamps
    [datetime]$Created
    [datetime]$LastUpdated

    static [string]$BaseQueryPage = 'ipam/vrfs/'

    ###################################################################################################
    #region Methods

    ######################################################
    #region GetFullQueryPage

    [string] GetFullQueryPage() {
        $FullQueryPage = [NetboxVrf]::BaseQueryPage + $this.VlanId + '/'
        return $FullQueryPage
    }

    #region GetFullQueryPage
    ######################################################

    ######################################################
    #region MakeJson
    [string] ToJson() {
        $Json = @{
            name = $this.VrfName
            rd   = $this.RouteDistinguisher
            id   = $this.VrfId
        }

        if ($this.Description) {
            $Json.description = $this.Description
        }

        if ($this.Tags) {
            $Json.tags = $this.Tags
        }

        if ($this.TenantId) {
            $Json.tenant = $this.TenantId
        }

        $Json = $Json | ConvertTo-Json -Compress

        return $Json
    }
    #endregion MakeJson
    ######################################################

    #endregion Methods
    ###################################################################################################

    ###################################################################################################
    #region Initiators

    ######################################################
    #region EmptyConstructor

    NetboxVrf() {
    }

    #endregion EmptyConstructor
    ######################################################

    #endregion Initiators
    ###################################################################################################
}