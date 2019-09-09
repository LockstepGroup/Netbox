class NetboxDevice {
    # Main Properties
    [int]$DeviceId
    [string]$DeviceName
    [string]$Slug

    # Hardware
    [int]$ManufacturerId
    [string]$ManufacturerName
    [int]$DeviceTypeId
    [string]$Model
    [string]$SerialNumber
    [string]$AssetTag

    # Location
    [int]$SiteId
    [string]$SiteName
    [int]$RackId
    [string]$RackName
    [string]$RackFace
    [string]$RackPosition

    # Management
    [string]$Status
    [string]$Platform

    # TenantGroup
    [int]$TenantGroupId
    [string]$TenantGroupName

    # Local Config Context Data
    [string]$LocalConfigContextData

    # Tags
    [array]$Tags

    # Comments
    [string]$Comments

    static [string]$BaseQueryPage = 'dcim/devices/'

    ###################################################################################################
    #region Methods

    ######################################################
    #region MakeJson
    [string] ToJson() {
        $Json = @{
            model         = $this.Model
            slug          = $this.Slug
            manufacturer  = $this.ManufacturerId
            is_full_depth = $this.IsFullDepth
            u_height      = $this.UHeight
        }

        if ($this.SubDeviceRole) {
            subdevice_role = $this.SubDeviceRole
        }

        if ($this.PartNumber) {
            $Json.part_number = $this.PartNumber
        }

        if ($this.Comments) {
            $Json.comments = $this.Comments
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
    #region Constructors

    ######################################################
    #region EmptyConstructor

    NetboxDevice() {
    }

    #endregion EmptyConstructor
    ######################################################

    #endregion Initiators
    ###################################################################################################
}