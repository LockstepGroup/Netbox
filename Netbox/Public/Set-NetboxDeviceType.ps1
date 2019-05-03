function Set-NetboxDeviceType {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'NetboxDeviceType', ValueFromPipeline = $True, Position = 0)]
        [NetboxDeviceType]$NetboxDeviceType
    )

    BEGIN {
        $VerbosePrefix = "Set-NetboxDeviceType:"
        $QueryPage = [NetboxDeviceType]::BaseQueryPage
        $ReturnObject = @()
    }

    PROCESS {
        ###############################################################
        #region invokeQuery

        $Response = $global:NetboxServerConnection.invokePostApiQuery($QueryPage, $NetboxDeviceType.ToJson())

        #endregion invokeQuery
        ###############################################################

        ###############################################################
        #region CreateReturnObject

        $ReturnObject += Get-NetboxDeviceType -DeviceTypeId $Response.Id

        #endregion CreateReturnObject
        ###############################################################
    }

    END {
        $ReturnObject
    }
}
