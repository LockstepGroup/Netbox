function Set-NetboxPrefix {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'NetboxObject', ValueFromPipeline = $True, Position = 0)]
        [NetboxPrefix]$NetboxPrefix
    )

    BEGIN {
        $VerbosePrefix = "Set-NetboxPrefix:"
        $QueryPage = [NetboxPrefix]::BaseQueryPage
        $ReturnObject = @()
    }

    PROCESS {
        ###############################################################
        #region invokeQuery

        Write-Verbose "$VerbosePrefix QueryPage: $QueryPage"
        Write-Verbose "$VerbosePrefix Json: $($NetboxPrefix.ToJson())"

        $Response = $global:NetboxServerConnection.invokePostApiQuery($QueryPage, $NetboxPrefix.ToJson())

        #endregion invokeQuery
        ###############################################################

        ###############################################################
        #region CreateReturnObject

        $ReturnObject += Get-NetboxPrefix -NetboxId $Response.Id

        #endregion CreateReturnObject
        ###############################################################
    }

    END {
        $ReturnObject
    }
}
