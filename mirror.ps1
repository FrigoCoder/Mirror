Function Main {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateScript( {Test-Path $_ })]
        [String] $source,

        [Parameter(Mandatory = $true)]
        [ValidateScript( {Test-Path $_ })]
        [String] $target,

        [Parameter(Mandatory = $false)]
        [ValidateScript( {!(Test-Path $_)})]
        [String] $shadowDrive = "B:"
    )
    Begin {
        $sourceDrive = Get-Drive $source
        $targetDrive = Get-Drive $target
        $shadow = New-Shadow $sourceDrive
    }
    Process {
        "Process"
    }
    End {
        Remove-Shadow $shadow
        $shadows = Get-WmiObject Win32_ShadowCopy
        "There are now {0} shadow copies on this sytem" -f $shadows.count
    }
}

Function Get-Drive {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateScript( {Test-Path $_ })]
        [String] $path
    )
    Process {
        return (Get-Item $path).PSDrive.Name + ":"
    }
}

Function New-Shadow {
    [CmdLetBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateScript( {Test-Path $_})]
        [String] $drive
    )
    Process {
        $Win32_ShadowCopy = Get-WmiObject -List Win32_ShadowCopy
        $created = $Win32_ShadowCopy.Create($drive + "\", "ClientAccessible")
        $shadow = Get-WmiObject Win32_ShadowCopy | Where-Object ID -eq $created.ShadowId
        Write-Verbose $shadow
        return $shadow
    }
}

Function Remove-Shadow {
    [CmdLetBinding()]
    Param (
        $shadow
    )
    Process {
        $shadow.Delete()
    }
}

Main @args
