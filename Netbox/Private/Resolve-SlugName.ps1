function Resolve-SlugName {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Slug
    )

    BEGIN {
        $VerbosePrefix = "Resolve-SlugName:"
    }

    PROCESS {
    }

    END {
        $Slug.ToLower() -replace ' ', '-'
    }
}
