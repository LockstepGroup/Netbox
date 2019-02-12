class HelperProcessError {
    static [hashtable] newExceptionDefinition ([string]$exceptionType, $exceptionCategory, [string]$message) {
        $new = @{}
        $new.Exception = New-Object -TypeName $exceptionType -ArgumentList $message
        $new.Category = $exceptionCategory
        return $new
    }

    static [System.Management.Automation.ErrorRecord] throwCustomError ([int]$errorId, [psobject]$object) {
        $ErrorLookup = [HelperProcessError]::ExceptionDefinitions.$errorId
        return [System.Management.Automation.ErrorRecord]::new(
            $ErrorLookup.Exception,
            $errorId,
            $ErrorLookup.Category,
            $object
        )
    }

    # List of Exceptions
    # The Types and Categories here are generic because I have no idea what subset exist in both core and non-core.
    static [hashtable] $ExceptionDefinitions = @{
        1000 = [HelperProcessError]::newExceptionDefinition('System.ArgumentException', [System.Management.Automation.ErrorCategory]::CloseError, 'Authentication is required, please provide a token from /user/api-tokens/')
    }

    # Constructor
    HelperProcessError () {
    }
}