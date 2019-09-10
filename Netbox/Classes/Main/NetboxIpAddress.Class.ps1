class NetboxIpAddress {
    [int]$NetboxId
    [string]$IpAddress
    [string]$IpFamily

    # Vrf
    [int]$VrfId
    [string]$VrfName

    # Tenant
    [int]$TenantId
    [string]$TenantName

    # Status
    [string]$Status

    # Role
    [int]$RoleId
    [string]$RoleName

    # Interface
    [int]$InterfaceId
    [string]$InterfaceName
    [int]$DeviceId
    [string]$DeviceName

    # Description
    [string]$Description

    # NatInside
    [int]$NatInsideId
    [string]$NatInsideAddress

    # NatOutside
    [int]$NatOutsideId
    [string]$NatOutsideAddress

    # Tags
    [array]$Tags

    # Custom Fields
    [hashtable]$CustomFields

    #Timestamps
    [datetime]$Created
    [datetime]$LastUpdated

    static [string]$BaseQueryPage = 'ipam/ip-addresses/'

    ###################################################################################################
    #region Methods

    ######################################################
    #region GetFullQueryPage

    [string] GetFullQueryPage() {
        $FullQueryPage = [NetboxIpAddress]::BaseQueryPage + $this.NetboxId + '/'
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
            DHCP       = 5
        }

        $Json = @{
            id          = $this.NetboxId
            address     = $this.IpAddress
            status      = $StatusMap."$($this.Status)"
            description = $this.Description
            tags        = $this.Tags
        }

        # Vrf
        if ($this.VrfId) {
            $Json.vrf = $this.VrfId
        }

        # Tenant
        if ($this.TenantId) {
            $Json.tenant = $this.TenantId
        }

        # Role
        if ($this.RoleId) {
            $Json.role = $this.RoleId
        }

        # Interface/Device
        if ($this.InterfaceId -and $this.DeviceId) {
            $Json.interface = @{
                id     = $this.InterfaceId
                device = $this.DeviceId
            }
        }

        # NatInside
        if ($this.NatInsideId) {
            $Json.nat_inside = $this.NatInsideId
        }

        # NatOutside
        if ($this.NatOutsideId) {
            $Json.nat_outside = $this.NatOutsideId
        }

        # CustomFields
        if ($this.CustomFields) {
            $Json.custom_fields = $this.CustomFields
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

    NetboxIpAddress() {
    }

    #endregion EmptyConstructor
    ######################################################

    #endregion Initiators
    ###################################################################################################
}