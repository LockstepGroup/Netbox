class NetboxDeviceType {
    [int]$DeviceTypeId
    [string]$Model
    [string]$Slug

    # Manufacturer
    [int]$ManufacturerId
    [string]$ManufacturerName

    # Details
    [string]$PartNumber
    [int]$UHeight
    [bool]$IsFullDepth
    [string]$SubDeviceRole
    [string]$Comments
    [array]$Tags

    # Custom Fields
    [hashtable]$CustomFields

    #Timestamps
    [datetime]$Created
    [datetime]$LastUpdated

    static [string]$BaseQueryPage = 'dcim/device-types/'

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
    #region Initiators

    ######################################################
    #region EmptyConstructor

    NetboxDeviceType() {
    }

    #endregion EmptyConstructor
    ######################################################

    #endregion Initiators
    ###################################################################################################
}