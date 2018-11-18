Function New-Shadow {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String] $drive
    )
    Process {
        $Win32_ShadowCopy = Get-WmiObject -List Win32_ShadowCopy
        $created = $Win32_ShadowCopy.Create($drive + '\', 'ClientAccessible')
        $shadow = Get-WmiObject Win32_ShadowCopy | Where-Object ID -eq $created.ShadowId
        Write-Verbose $shadow
        Write-Verbose $shadow.DeviceObject
        return $shadow
    }
}

Function Remove-Shadow {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        $shadow
    )
    Process {
        $shadow.Delete()
    }
}
