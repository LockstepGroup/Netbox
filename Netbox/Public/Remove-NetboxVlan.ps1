function Remove-NetboxVlan {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $True, Position = 0)]
        [int]$VlanId
    )

    BEGIN {
        $VerbosePrefix = "Remove-NetboxVlan:"
        $QueryPage = [NetboxVlan]::BaseQueryPage
    }

    PROCESS {
        $QueryPage = $QueryPage + $VlanId + '/'
        Write-Verbose "$VerbosePrefix QueryPage: $QueryPage"
        $Response = $global:NetboxServerConnection.invokeDeleteApiQuery($QueryPage)
    }

    END {
    }
}
