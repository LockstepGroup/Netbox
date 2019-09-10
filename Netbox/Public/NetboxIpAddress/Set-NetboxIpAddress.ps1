function Set-NetboxIpAddress {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'NetboxObject', ValueFromPipeline = $True, Position = 0)]
        [NetboxIpAddress]$NetboxIpAddress
    )

    BEGIN {
        $VerbosePrefix = "Set-NetboxIpAddress:"
        $QueryPage = [NetboxIpAddress]::BaseQueryPage
        $ReturnObject = @()
    }

    PROCESS {
        ###############################################################
        #region invokeQuery

        Write-Verbose "$VerbosePrefix QueryPage: $QueryPage"
        Write-Verbose "$VerbosePrefix Json: $($NetboxIpAddress.ToJson())"

        $Response = $global:NetboxServerConnection.invokePostApiQuery($QueryPage, $NetboxIpAddress.ToJson())

        #endregion invokeQuery
        ###############################################################

        ###############################################################
        #region CreateReturnObject

        $ReturnObject += Get-NetboxIpAddress -NetboxId $Response.Id

        #endregion CreateReturnObject
        ###############################################################
    }

    END {
        $ReturnObject
    }
}
