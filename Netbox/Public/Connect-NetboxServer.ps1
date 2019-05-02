function Connect-NetboxServer {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidatePattern("\d+\.\d+\.\d+\.\d+|(\w\.)+\w")]
        [string]$Server,

        [Parameter(Mandatory = $True, Position = 1)]
        [string]$ApiToken,

        [Parameter(Mandatory = $False, Position = 2)]
        [int]$Port,

        [Parameter(Mandatory = $False)]
        [alias('http')]
        [switch]$HttpOnly,

        [Parameter(Mandatory = $False)]
        [alias('q')]
        [switch]$Quiet
    )

    BEGIN {
        $VerbosePrefix = "Connect-NetboxServer:"

        if ($HttpOnly) {
            $Protocol = "http"
            if (!$Port) { $Port = 80 }
        } else {
            $Protocol = "https"
            if (!$Port) { $Port = 443 }
        }
    }

    PROCESS {
        try {
            Write-Verbose "$VerbosePrefix Attempting to connect with provided ApiToken"
            Write-Verbose "$VerbosePrefix Server: $Server"
            Write-Verbose "$VerbosePrefix Protocol: $Protocol"
            Write-Verbose "$VerbosePrefix Port: $Port"
            $global:NetboxServerConnection = [NetboxServer]::new($Server, $ApiToken, $Protocol, $Port)
        } catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }

        try {
            $TestConnect = $global:NetboxServerConnection.testConnection()
        } catch {
        }

        if ($TestConnect) {
            if (!($Quiet)) {
                return $global:NetboxServerConnection
            }
        } else {
            Throw "$VerbosePrefix testConnection() failed."
        }
    }
}