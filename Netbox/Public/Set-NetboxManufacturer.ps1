function Set-NetboxManufacturer {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'NetboxManufacturer', ValueFromPipeline = $True, Position = 0)]
        [NetboxManufacturer]$NetboxManufacturer
    )

    BEGIN {
        $VerbosePrefix = "Set-NetboxManufacturer:"
        $QueryPage = [NetboxManufacturer]::BaseQueryPage
        $ReturnObject = @()
    }

    PROCESS {
        ###############################################################
        #region invokeQuery

        $Response = $global:NetboxServerConnection.invokePostApiQuery($QueryPage, $NetboxManufacturer.ToJson())

        #endregion invokeQuery
        ###############################################################

        ###############################################################
        #region CreateReturnObject

        $New = New-NetBoxManufacturer -Name $Response.Name -Slug $Response.Slug -Id $Response.Id
        $ReturnObject += $New

        #endregion CreateReturnObject
        ###############################################################
    }

    END {
        $ReturnObject
    }
}
