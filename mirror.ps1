Function Main {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String] $source,

        [Parameter(Mandatory = $true)]
        [String] $target,

        [Parameter(Mandatory = $false)]
        [String] $shadowDrive = "B"
    )
    Begin {
        $sourceDrive = Get-Drive $source
        $targetDrive = Get-Drive $target
        $shadow = New-Shadow $sourceDrive
        New-Mount $shadowDrive ($shadow.DeviceObject + "\")
    }
    Process {
        dir ($shadowDrive + ":\")
    }
    End {
        Remove-Mount $shadowDrive
        Remove-Shadow $shadow
    }
}

Function Get-Drive {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String] $path
    )
    Process {
        return (Get-Item $path).PSDrive.Name
    }
}

Function New-Shadow {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String] $drive
    )
    Process {
        $Win32_ShadowCopy = Get-WmiObject -List Win32_ShadowCopy
        $created = $Win32_ShadowCopy.Create($drive + ":\", "ClientAccessible")
        $shadow = Get-WmiObject Win32_ShadowCopy | Where-Object ID -eq $created.ShadowId
        Write-Verbose $shadow
        Write-Verbose $shadow.DeviceObject
        return $shadow
    }
}

Function Remove-Shadow {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        $shadow
    )
    Process {
        $shadow.Delete()
    }
}

Function New-Mount {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String] $drive,

        [Parameter(Mandatory = $true)]
        [String] $path
    )
    Process {
        New-PsDrive -Name $drive -PSProvider "FileSystem" -Root $path
    }
}

Function Remove-Mount {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String] $drive
    )
    Process {
        Get-PSDrive $drive | Remove-PSDrive
    }
}

Main @args
