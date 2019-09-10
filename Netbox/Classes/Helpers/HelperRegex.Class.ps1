class HelperRegex {
    static [string]$Ipv4 = '\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b'
    static [string]$Ipv4Prefix = '\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\/([0-9]|[1-2][0-9]|3[0-2]))\b'
    static [string]$Ipv4Range = '\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)-((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b'

    static [string]$Ipv6Address = '\b(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))\b'
    static [string]$Ipv6Prefix = '\b(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))(\/([0-9]|[1-9][0-9]|1[0-1][0-9]|12[0-8]))\b'

    # removed the restriction of not-starting with a digit
    static [string]$Fqdn = '(?=^.{1,254}$)(^(?:(?!-)[a-zA-Z0-9\-]{1,63}(?<!-)\.)+(?:[a-zA-Z]{2,})$)'

    # function for checking regular expressions
    static [string] checkRegex([string]$matchString, [string]$regexString, [string]$errorMessage) {
        $regex = [regex]$regexString
        if ($regex.Match($matchString).Success) {
            return $matchString
        } else {
            Throw $errorMessage
        }
    }

    static [bool] checkRegex([string]$matchString, [string]$regexString, [bool]$returnBool) {
        $regex = [regex]$regexString
        if ($regex.Match($matchString).Success) {
            return $true
        } else {
            return $false
        }
    }

    # Ipv4 Address
    static [string] isIpv4([string]$matchString, [string]$errorMessage) {
        $regexString = [HelperRegex]::Ipv4
        return [HelperRegex]::checkRegex($matchString, $regexString, $errorMessage)
    }

    static [bool] isIpv4([string]$matchString, [bool]$returnBool) {
        $regexString = [HelperRegex]::Ipv4
        return [HelperRegex]::checkRegex($matchString, $regexString, $true)
    }

    # Ipv4 Range
    static [string] isIpv4Range([string]$matchString, [string]$errorMessage) {
        $regexString = [HelperRegex]::Ipv4Range
        return [HelperRegex]::checkRegex($matchString, $regexString, $errorMessage)
    }

    static [bool] isIpv4Range([string]$matchString, [bool]$returnBool) {
        $regexString = [HelperRegex]::Ipv4Range
        return [HelperRegex]::checkRegex($matchString, $regexString, $true)
    }

    ##############################################################
    #region Prefixes

    ###############################
    #region isIpv4Prefix
    static [string] isIpv4Prefix([string]$matchString, [string]$errorMessage) {
        $regexString = [HelperRegex]::Ipv4Prefix
        return [HelperRegex]::checkRegex($matchString, $regexString, $errorMessage)
    }

    static [bool] isIpv4Prefix([string]$matchString, [bool]$returnBool) {
        $regexString = [HelperRegex]::Ipv4Prefix
        return [HelperRegex]::checkRegex($matchString, $regexString, $true)
    }
    #endregion isIpv4Prefix
    ###############################

    ###############################
    #region isIpv6Prefix
    static [string] isIpv6Prefix([string]$matchString, [string]$errorMessage) {
        $regexString = [HelperRegex]::Ipv6Prefix
        return [HelperRegex]::checkRegex($matchString, $regexString, $errorMessage)
    }

    static [bool] isIpv6Prefix([string]$matchString, [bool]$returnBool) {
        $regexString = [HelperRegex]::Ipv6Prefix
        return [HelperRegex]::checkRegex($matchString, $regexString, $true)
    }
    #endregion isIpv4Prefix
    ###############################

    #endregion Prefixes
    ##############################################################

    ###############################
    #region isIpv6Address
    static [string] isIpv6Address([string]$matchString, [string]$errorMessage) {
        $regexString = [HelperRegex]::Ipv6Address
        return [HelperRegex]::checkRegex($matchString, $regexString, $errorMessage)
    }

    static [bool] isIpv6Address([string]$matchString, [bool]$returnBool) {
        $regexString = [HelperRegex]::Ipv6Address
        return [HelperRegex]::checkRegex($matchString, $regexString, $true)
    }
    #endregion isIpv6Address
    ###############################

    # Fqdn
    static [string] isFqdn([string]$matchString, [string]$errorMessage) {
        $regexString = [HelperRegex]::Fqdn
        return [HelperRegex]::checkRegex($matchString, $regexString, $errorMessage)
    }

    static [bool] isFqdn([string]$matchString, [bool]$returnBool) {
        $regexString = [HelperRegex]::Fqdn
        return [HelperRegex]::checkRegex($matchString, $regexString, $true)
    }

    # Fqdn or Ipv4 Address
    static [string] isFqdnOrIpv4([string]$matchString, [string]$errorMessage) {
        $regexString = [HelperRegex]::Ipv4 + "|" + [HelperRegex]::Fqdn
        return [HelperRegex]::checkRegex($matchString, $regexString, $errorMessage)
    }

    static [bool] isFqdnOrIpv4([string]$matchString, [bool]$returnBool) {
        $regexString = [HelperRegex]::Ipv4 + "|" + [HelperRegex]::Fqdn
        return [HelperRegex]::checkRegex($matchString, $regexString, $true)
    }

    # Constructor
    HelperRegex () {
    }
}