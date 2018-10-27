Function Main {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String] $sourceDrive,

        [Parameter(Mandatory = $true)]
        [String] $targetDrive,

        [Parameter(Mandatory = $false)]
        [String] $shadowDrive = "B:"
    )
    Begin {
        $shadow = New-Shadow $sourceDrive
        New-Mount $shadowDrive $shadow.DeviceObject
    }
    Process {
        pushd $shadowDrive
        dir
        popd
    }
    End {
        Remove-Mount $shadowDrive $shadow.DeviceObject
        Remove-Shadow $shadow
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
        $created = $Win32_ShadowCopy.Create($drive + "\", "ClientAccessible")
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
        DefineDosDevice 0 $drive $path
    }
}

Function Remove-Mount {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String] $drive,

        [Parameter(Mandatory = $true)]
        [String] $path
    )
    Process {
        DefineDosDevice 6 $drive $path
    }
}

Function DefineDosDevice {
    Param (
        [Parameter(Mandatory = $true)]
        [uint32] $flags,

        [Parameter(Mandatory = $true)]
        [String] $drive,

        [Parameter(Mandatory = $true)]
        [String] $path
    )
    Process {
        $DefineDosDevice = '[DllImport("kernel32.dll", CharSet=CharSet.Auto, SetLastError=true)] public static extern bool DefineDosDevice(int dwFlags, string lpDeviceName, string lpTargetPath);'
        $Kernel32 = Add-Type -MemberDefinition $DefineDosDevice -Name "Kernel32" -Namespace "Win32" -PassThru
        $Kernel32::DefineDosDevice($flags, $drive, $path)
    }
}

Main @args
