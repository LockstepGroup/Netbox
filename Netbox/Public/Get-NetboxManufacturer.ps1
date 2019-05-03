function Get-NetboxManufacturer {
    [CmdletBinding(DefaultParametersetName = "ManufacturerId")]

    Param (
        [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $True, ParameterSetName = 'ManufacturerId', Position = 0)]
        [int]$ManufacturerId,

        [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $True, ParameterSetName = 'ManufacturerName', Position = 0)]
        [string]$ManufacturerName
    )

    BEGIN {
        $VerbosePrefix = "Get-NetboxManufacturer:"
        $ReturnObject = @()
    }

    PROCESS {
        $QueryPage = 'dcim/manufacturers/'

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
            $New = New-NetboxManufacturer -Name $response.name -Slug $response.slug -Id $response.id
            $ReturnObject += $New

            #$New.ManufacturerId = $response.id
        }
    }

    END {
        $ReturnObject
    }
}