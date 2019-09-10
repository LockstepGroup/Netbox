function Remove-NetboxPrefix {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $True, Position = 0)]
        [int]$NetboxId
    )

    BEGIN {
        $VerbosePrefix = "Remove-NetboxPrefix:"
        $QueryPage = [NetboxPrefix]::BaseQueryPage
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
