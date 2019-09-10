class NetboxPrefix {
    [int]$NetboxId
    [string]$Prefix
    [string]$IpFamily
    [string]$Status

    [int]$VrfId
    [string]$VrfName

    [int]$RoleId
    [string]$RoleName

    [string]$Description
    [bool]$IsPool

    # Site
    [int]$SiteId
    [string]$SiteName
    [int]$VlanId
    [int]$VlanTag
    [string]$VlanName

    # Tenant
    [int]$TenantId
    [string]$TenantName

    # Tags
    [array]$Tags

    # Custom Fields
    [hashtable]$CustomFields

    #Timestamps
    [datetime]$Created
    [datetime]$LastUpdated

    static [string]$BaseQueryPage = 'ipam/prefixes/'

    ###################################################################################################
    #region Methods

    ######################################################
    #region GetFullQueryPage

    [string] GetFullQueryPage() {
        $FullQueryPage = [NetboxPrefix]::BaseQueryPage + $this.NetboxId + '/'
        return $FullQueryPage
    }

    #region GetFullQueryPage
    ######################################################

    ######################################################
    #region MakeJson
    [string] ToJson() {
        $StatusMap = @{
            Container  = 0
            Active     = 1
            Reserved   = 2
            Deprecated = 3
        }

        $IpFamilyMap = @{
            IPv4 = 4
            IPv6 = 6
        }

        $Json = @{
            prefix  = $this.Prefix
            status  = $StatusMap."$($this.Status)"
            is_pool = $this.IsPool
            id      = $this.NetboxId
        }

        if ($this.SiteId) {
            $Json.site = $this.SiteId
        }

        if ($this.VrfId) {
            $Json.vrf = $this.VrfId
        }

        if ($this.TenantId) {
            $Json.tenant = $this.TenantId
        }

        if ($this.VlanId) {
            $Json.vlan = $this.VlanId
        }

        if ($this.RoleId) {
            $Json.role = $this.RoleId
        }

        if ($this.Description) {
            $Json.description = $this.Description
        }

        if ($this.Tags) {
            $Json.tags = $this.Tags
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

    NetboxPrefix() {
    }

    #endregion EmptyConstructor
    ######################################################

    #endregion Initiators
    ###################################################################################################
}