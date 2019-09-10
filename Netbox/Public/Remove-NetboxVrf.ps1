function Remove-NetboxVrf {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $True, Position = 0)]
        [int]$VrfId
    )

    BEGIN {
        $VerbosePrefix = "Remove-NetboxVrf:"
        $QueryPage = [NetboxVrf]::BaseQueryPage
    }

    PROCESS {
        $QueryPage = $QueryPage + $VrfId + '/'
        Write-Verbose "$VerbosePrefix QueryPage: $QueryPage"
        $Response = $global:NetboxServerConnection.invokeDeleteApiQuery($QueryPage)
    }

    END {
        $Response
    }
}
