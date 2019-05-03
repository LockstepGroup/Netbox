function Get-NetboxDeviceType {
    [CmdletBinding(DefaultParametersetName = "DeviceTypeId")]

    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $True, ParameterSetName = 'NetboxManufacturer', Position = 0)]
        [NetboxManufacturer]$NetboxManufacturer,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $True, ParameterSetName = 'DeviceTypeId', Position = 0)]
        [int]$DeviceTypeId
    )

    BEGIN {
        $VerbosePrefix = "Get-NetboxDeviceType:"
        Write-Verbose "$VerbosePrefix ParameterSetName (BEGIN): $($PSCmdlet.ParameterSetName)"
        $QueryPage = [NetboxDeviceType]::BaseQueryPage
        $ReturnObject = @()
    }

    PROCESS {
        Write-Verbose "$VerbosePrefix ParameterSetName (PROCESS): $($PSCmdlet.ParameterSetName)"
        if ($DeviceTypeId) {
            $QueryPage += "$DeviceTypeId/"
        }

        if ($NetboxManufacturer) {
            $QueryPage += '?manufacturer=' + $NetboxManufacturer.Slug
        }

        try {
            $Response = $global:NetboxServerConnection.invokeApiQuery($QueryPage)
            if ($TenantGroupName -and ($Response.count -eq 0)) {
                Write-Warning "$VerbosePrefix No results found, keep in mind that all netbox names are case-sensitive."
            } else {
                if ($Response.Results) {
                    $LoopResults = $Response.Results
                } else {
                    $LoopResults = @($Response)
                }
            }
        } catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }

        foreach ($response in $LoopResults) {
            $Params = @{}

            $Params.Id = $response.id
            $Params.ManufacturerId = $response.manufacturer.id
            $Params.Model = $response.model
            $Params.Slug = $response.slug
            $Params.PartNumber = $response.part_number
            $Params.UHeight = $response.u_height
            $Params.IsFullDepth = $response.is_full_depth
            $Params.Comments = $response.comments
            $Params.Tags = $response.tags

            if ($response.subdevice_role) {
                $Params.SubDeviceRole = $response.subdevice_role.label
            }

            $New = New-NetboxDeviceType @Params

            $New.ManufacturerName = $response.manufacturer.name
            $New.Created = $response.created
            $New.LastUpdated = $response.last_updated

            $ReturnObject += $New
        }
    }

    END {
        $ReturnObject
    }
}