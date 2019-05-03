function Remove-NetboxSite {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $True, Position = 0)]
        [int]$SiteId
    )

    BEGIN {
        $VerbosePrefix = "Remove-NetboxSite:"
    }

    PROCESS {
        $QueryPage = 'dcim/sites/' + $SiteId + '/'
        $Response = $global:NetboxServerConnection.invokeDeleteApiQuery($QueryPage)
    }

    END {
    }
}
