function New-NetboxTenant {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [string]$Slug,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $True)]
        [int]$TenantGroupId,

        [Parameter(Mandatory = $false)]
        [string]$Description,

        [Parameter(Mandatory = $false)]
        [string[]]$Tags,

        [Parameter(Mandatory = $false)]
        [string]$Comments
    )

    BEGIN {
        $VerbosePrefix = "New-NetboxTenant:"
    }

    PROCESS {
        $QueryPage = 'tenancy/tenants/'

        if (-not $Slug) {
            $Slug = $Name
        }


        $Body = @{
            name = $Name
            slug = $Slug
        }

        if ($TenantGroupId) {
            $Body.group = @{ id = $TenantGroupId }
        }
        if ($Description) { $Body.description = $Description }
        if ($Tags) {
            $Body.tags = $Tags | ConvertTo-Json -Compress
        }
        if ($Comments) { $Body.comments = $Comments }

        $Response = $global:NetboxServerConnection.invokePostApiQuery($QueryPage, ($Body | ConvertTo-Json -Compress))

        $ReturnObject = [NetboxTenant]::new()

        $ReturnObject.TenantId = $Response.id
        $ReturnObject.TenantName = $Response.name
        $ReturnObject.Slug = $Response.slug
        $ReturnObject.Description = $Response.description
        $ReturnObject.Comments = $Response.comments
        $ReturnObject.Tags = $Response.tags

        # Group
        $ReturnObject.TenantGroupId = $Response.group.id
        $ReturnObject.TenantGroupName = $Response.group.name

        # Custom Fields
        $ReturnObject.CustomFields = $Response.custom_fields

        #Timestamps
        $ReturnObject.Created = $Response.created
        $ReturnObject.LastUpdated = $Response.last_updated
    }

    END {
        $ReturnObject
    }
}