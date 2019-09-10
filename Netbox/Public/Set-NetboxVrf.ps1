function Set-NetboxVrf {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'NetboxObject', ValueFromPipeline = $True, Position = 0)]
        [NetboxVrf]$NetboxVrf
    )

    BEGIN {
        $VerbosePrefix = "Set-NetboxVrf:"
        $QueryPage = [NetboxVrf]::BaseQueryPage
        $ReturnObject = @()
    }

    PROCESS {
        ###############################################################
        #region invokeQuery

        Write-Verbose "$VerbosePrefix QueryPage: $QueryPage"
        Write-Verbose "$VerbosePrefix Json: $($NetboxVrf.ToJson())"

        $Response = $global:NetboxServerConnection.invokePostApiQuery($QueryPage, $NetboxVrf.ToJson())

        #endregion invokeQuery
        ###############################################################

        ###############################################################
        #region CreateReturnObject

        $ReturnObject += Get-NetboxVrf -VrfId $Response.Id

        #endregion CreateReturnObject
        ###############################################################
    }

    END {
        $ReturnObject
    }
}
