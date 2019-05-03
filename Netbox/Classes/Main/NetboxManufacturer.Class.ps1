class NetboxManufacturer {
    [int]$ManufacturerId
    [string]$ManufacturerName
    [string]$Slug

    static [string]$BaseQueryPage = 'dcim/manufacturers/'

    ###################################################################################################
    #region Methods

    ######################################################
    #region MakeJson
    [string] ToJson() {
        $Json = @{
            name = $this.ManufacturerName
            slug = $this.Slug
        }

        if ($this.ManufacturerId) {
            $Json.id = $this.ManufacturerId
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

    NetboxManufacturer() {
    }

    #endregion EmptyConstructor
    ######################################################

    #endregion Initiators
    ###################################################################################################
}