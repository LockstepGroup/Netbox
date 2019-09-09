function Set-NetboxVlan {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'NetboxVlan', ValueFromPipeline = $True, Position = 0)]
        [NetboxVlan]$NetboxVlan
    )

    BEGIN {
        $VerbosePrefix = "Set-NetboxVlan:"
        $QueryPage = [NetboxVlan]::BaseQueryPage
        $ReturnObject = @()
    }

    PROCESS {
        ###############################################################
        #region invokeQuery

        Write-Verbose "$VerbosePrefix QueryPage: $QueryPage"
        Write-Verbose "$VerbosePrefix Json: $($NetboxVlan.ToJson())"

        $Response = $global:NetboxServerConnection.invokePostApiQuery($QueryPage, $NetboxVlan.ToJson())

        #endregion invokeQuery
        ###############################################################

        ###############################################################
        #region CreateReturnObject

        $ReturnObject += Get-NetboxVlan -VlanId $Response.Id

        #endregion CreateReturnObject
        ###############################################################
    }

    END {
        $ReturnObject
    }
}
