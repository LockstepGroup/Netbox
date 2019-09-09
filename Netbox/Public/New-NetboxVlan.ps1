function New-NetboxVlan {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [int]$VlanTag,

        [Parameter(Mandatory = $true, Position = 1)]
        [string]$VlanName,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Active', 'Reserved', 'Deprecated')]
        [string]$Status = 'Active',

        [Parameter(Mandatory = $false)]
        [string]$Slug,

        [Parameter(Mandatory = $false)]
        [string]$TenantName,

        [Parameter(Mandatory = $false)]
        [int]$TenantId,

        [Parameter(Mandatory = $false)]
        [string]$SiteName,

        [Parameter(Mandatory = $false)]
        [int]$SiteId,

        [Parameter(Mandatory = $false)]
        [string]$Description,

        [Parameter(Mandatory = $false)]
        [string[]]$Tags
    )

    BEGIN {
        $VerbosePrefix = "New-NetboxVlan:"
    }

    PROCESS {
        # set slug to name if not specified
        if (-not $Slug) {
            $Slug = $VlanName
        }

        # format slug correctly
        $Slug = Resolve-SlugName -Slug $Slug

        <# $Body = @{
            name   = $Name
            slug   = $Slug
            vid    = $VlanTag
            status = $StatusMap.$Status
        }

        if ($Site) {
            $Body.site = @{ id = $SiteId }
        }
        if ($TenantId) {
            $Body.tenant = @{ id = $TenantId }
        }
        if ($Description) { $Body.description = $Description }
        if ($Tags) {
            $Body.tags = $Tags | ConvertTo-Json -Compress
        }

        $Response = $global:NetboxServerConnection.invokePostApiQuery($QueryPage, ($Body | ConvertTo-Json -Compress)) #>

        $ReturnObject = [NetboxVlan]::new()

        $ReturnObject.VlanTag = $VlanTag
        $ReturnObject.VlanName = $VlanName
        $ReturnObject.Status = $Status
        $ReturnObject.Slug = $Slug
        $ReturnObject.Description = $Description
        $ReturnObject.Tags = $Tags

        # Site
        $ReturnObject.SiteName = $SiteName
        $ReturnObject.SiteId = $SiteId

        # Tenant
        $ReturnObject.TenantName = $TenantName
        $ReturnObject.TenantId = $TenantId
    }

    END {
        $ReturnObject
    }
}