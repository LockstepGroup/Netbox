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

    static [string]$BaseQueryPage = 'ipam/vlans/'

    ###################################################################################################
    #region Methods

    ######################################################
    #region GetFullQueryPage

    [string] GetFullQueryPage() {
        $FullQueryPage = [NetboxVlan]::BaseQueryPage + $this.VlanId + '/'
        return $FullQueryPage
    }

    #region GetFullQueryPage
    ######################################################

    ######################################################
    #region MakeJson
    [string] ToJson() {
        $StatusMap = @{
            Active     = 1
            Reserved   = 2
            Deprecated = 3
        }

        $Json = @{
            vid    = $this.VlanTag
            name   = $this.VlanName
            status = $StatusMap."$($this.Status)"
            slug   = $this.slug
        }

        if ($this.Description) {
            $Json.description = $this.Description
        }

        if ($this.Tags) {
            $Json.tags = $this.Tags
        }

        <# if ($this.SiteName) {
            $Json.site = @{
                name = $this.SiteName
            }
        }

        if ($this.TenantName) {
            $Json.tenant = @{
                name = $this.TenantName
            }
        } #>

        if ($this.SiteId) {
            $Json.site = $this.SiteId
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

    NetboxVlan() {
    }

    #endregion EmptyConstructor
    ######################################################

    #endregion Initiators
    ###################################################################################################
}