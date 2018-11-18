Function Reset-Services {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String[]] $services
    )
    Process {
        foreach ( $service in $services ) {
            Set-Service -Name $service -StartupType Automatic
            Stop-Service -Name $service
        }
        [array]::Reverse($services)
        foreach ($service in $services) {
            Start-Service -Name $service
        }
    }
}
