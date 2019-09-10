function Remove-NetboxIpAddress {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $True, Position = 0)]
        [int]$NetboxId
    )

    BEGIN {
        $VerbosePrefix = "Remove-NetboxIpAddress:"
        $QueryPage = [NetboxIpAddress]::BaseQueryPage
    }

    PROCESS {
        $QueryPage = $QueryPage + $NetboxId + '/'
        Write-Verbose "$VerbosePrefix QueryPage: $QueryPage"
        $Response = $global:NetboxServerConnection.invokeDeleteApiQuery($QueryPage)
    }

    END {
        $Response
    }
}
