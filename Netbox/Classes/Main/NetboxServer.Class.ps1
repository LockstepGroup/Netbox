class NetboxServer {
    [string]$Hostname

    [ValidateRange(1, 65535)]
    [int]$Port = 443

    [ValidateSet('http', 'https')]
    [string]$Protocol = "https"

    [string]$ApiToken

    # Track usage
    [int]$ReturnCount = 500
    [int]$CurrentStartPosition = 0
    hidden [bool]$Connected
    [array]$UrlHistory
    [array]$RawQueryResultHistory
    $LastError
    $LastResult

    #region SkipSSL
    static [string]$TrustAllCertsPolicy = @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
    public bool CheckValidationResult(
        ServicePoint srvPoint, X509Certificate certificate,
        WebRequest request, int certificateProblem) {
        return true;
    }
}
"@

    static [bool] SkipCertificateCheck() {
        if ($global:PSVersionTable.PSEdition -eq 'Core') {
            return $true
        } else {
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            try {
                Add-Type [NetboxServer]::TrustAllCertsPolicy
            } catch {
            }
            [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
            return $false
        }
    }
    #endregion SkipSSL

    #region getApiUrl
    [String] getApiUrl([string]$queryPage) {
        if ($this.Hostname) {
            $url = $this.Protocol + "://" + $this.Hostname + ':' + $this.Port + "/api/"
            if ($queryPage -ne 'testConnection') {
                $url += $queryPage
            }
            return $url
        } else {
            return $null
        }
    }
    #endregion getApiUrl

    #region invokeApiQuery
    [PSCustomObject] invokeApiQuery([string]$queryPage) {
        # If the query is not a GetPassHash query we need to append the PassHash and UserName to the query string
        $uri = $this.getApiUrl($queryPage)

        #region trackHistory
        $this.UrlHistory += $uri
        #endregion trackHistory

        # try query
        try {
            $QueryParams = @{}
            $QueryParams.Uri = $uri
            $QueryParams.UseBasicParsing = $true
            $QueryParams.Headers = @{}
            $QueryParams.Headers.Authorization = "Token $($this.ApiToken)"
            $QueryParams.Headers.Accept = 'application/json; indent=4'

            if ([NetboxServer]::SkipCertificateCheck()) {
                $QueryParams.SkipCertificateCheck = $true
            }
            <#
            #region SSLIssues
            # allow week ssl and untrusted certs
            switch ($global:PSVersionTable.PSEdition) {
                'Core' {
                    $QueryParams.SkipCertificateCheck = $true
                    continue
                }
                default {
                    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                    try {
                        add-type @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
    public bool CheckValidationResult(
        ServicePoint srvPoint, X509Certificate certificate,
        WebRequest request, int certificateProblem) {
        return true;
    }
}
"@
                    } catch {

                    }
                    [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
                    continue
                }
            }
            #endregion SSLIssues #>

            $rawResult = Invoke-WebRequest @QueryParams -Verbose:$false # doing this mostly to prevent plaintext password from being displayed by accident.
        } catch {
            Throw $_
        }

        $this.RawQueryResultHistory += $rawResult
        $jsonResult = $rawResult | ConvertFrom-Json
        $this.LastResult = $jsonResult

        return $jsonResult
    }
    #endregion invokeApiQuery

    #region invokePostApiQuery
    [PSCustomObject] invokePostApiQuery([string]$queryPage, [hashtable]$Body) {
        # If the query is not a GetPassHash query we need to append the PassHash and UserName to the query string
        $uri = $this.getApiUrl($queryPage)

        #region trackHistory
        $this.UrlHistory += $uri
        #endregion trackHistory

        # try query
        try {
            $QueryParams = @{}
            $QueryParams.Uri = $uri
            $QueryParams.UseBasicParsing = $true
            $QueryParams.Method = 'POST'
            $QueryParams.Headers = @{}
            $QueryParams.Headers.Authorization = "Token $($this.ApiToken)"
            $QueryParams.Headers.Accept = 'application/json; indent=4'
            $QueryParams.Body = $Body

            if ([NetboxServer]::SkipCertificateCheck()) {
                $QueryParams.SkipCertificateCheck = $true
            }

            $rawResult = Invoke-WebRequest @QueryParams -Verbose:$false # doing this mostly to prevent plaintext password from being displayed by accident.
        } catch {
            Throw $_
        }

        $this.RawQueryResultHistory += $rawResult
        $jsonResult = $rawResult | ConvertFrom-Json
        $this.LastResult = $jsonResult

        return $jsonResult
    }
    #endregion invokePostApiQuery

    #region Initiators
    ###################################################################################################
    # Blank Initiator, just used for debug/troubleshooting
    NetboxServer() {
    }

    # Initiator with PassHash
    NetboxServer([string]$Hostname, [string]$ApiToken, [string]$Protocol = "https", [int]$Port) {
        $this.Hostname = $Hostname
        $this.ApiToken = $ApiToken
        $this.Protocol = $Protocol
        $this.Port = $Port
    }
    #endregion Initiators

    #region testConnection
    [bool] testConnection() {
        $result = $this.invokeApiQuery('testConnection')
        $this.Connected = $true
        return $true
    }
    #endregion testConnection
}