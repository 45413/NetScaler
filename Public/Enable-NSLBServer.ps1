<#
Copyright 2015 Brandon Olin

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
#>

function Enable-NSLBServer {
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
    param(
        $Session = $script:nitroSession,

        [parameter(Mandatory,ValueFromPipeline = $true, ValueFromPipelineByPropertyName)]
        [string[]]$Name = (Read-Host -Prompt 'LB server name'),

        [switch]$Force,

        [switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Enable Server')) {
                $result = [com.citrix.netscaler.nitro.resource.config.basic.server]::enable($Session, $item)
                if ($result.errorcode -ne 0) { throw $result }

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSLBServer -Name $item
                }
            }
        }
    }
}