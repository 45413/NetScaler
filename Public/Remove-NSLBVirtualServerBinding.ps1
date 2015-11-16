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

function Remove-NSLBVirtualServerBinding {
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
    param(
        $Session = $script:nitroSession,

        [parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [string[]]$Name,

        [switch]$Force
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Delete Virtual Server Binding')) {
                try {
                    $binding = [com.citrix.netscaler.nitro.resource.config.lb.lbvserver_servicegroup_binding]::get($Session, $item)
                    $b = New-Object -TypeName com.citrix.netscaler.nitro.resource.config.lb.lbvserver_servicegroup_binding
                    $b.name = $binding.name
                    $b.servicegroupname = $binding.servicegroupname
                    $result = [com.citrix.netscaler.nitro.resource.config.lb.lbvserver_servicegroup_binding]::delete($Session, $b)
                    if ($result.errorcode -ne 0) { throw $result }
                } catch {
                    throw $_
                }
            }
        }
    }
}