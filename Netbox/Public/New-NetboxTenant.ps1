function New-NetboxTenant {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [string]$Slug,

        [Parameter(Mandatory = $false)]
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
        $Global:test = $Body

        if ($GroupId) { $Body.GroupId = $GroupId }
        if ($Description) { $Body.Description = $Description }
        if ($Tags) { $Body.Tags = $Tags }
        if ($Comments) { $Body.Comments = $Comments }

        $Response = $global:NetboxServerConnection.invokePostApiQuery($QueryPage, $Body)

        $ReturnObject = [NetboxTenant]::new()

        $ReturnObject.TenantId = $Response.id
        $ReturnObject.Name = $Response.name
        $ReturnObject.Slug = $Response.slug
        $ReturnObject.Description = $Response.description
        $ReturnObject.Comments = $Response.comments
        $ReturnObject.Tags = $Response.tags

        # Group
        $ReturnObject.GroupId = $Response.group.id
        $ReturnObject.GroupName = $Response.group.name

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