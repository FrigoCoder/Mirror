Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$PSDefaultParameterValues['*:ErrorAction'] = 'Stop'

Function Mirror {
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
        Reset-Services COMsysAPP, SENS, EventSystem, SwPrv, VSS
        $shadow = New-Shadow $sourceDrive
        New-Mount $shadowDrive $shadow.DeviceObject
    }
    Process {
        Remove-Files $shadowDrive $targetDrive
        Copy-Files $shadowDrive $targetDrive
    }
    End {
        Remove-Mount $shadowDrive $shadow.DeviceObject
        Remove-Shadow $shadow
    }
}

Function Reset-Services {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String[]] $services
    )
    Process {
        foreach ( $service in $services ) {
            Set-Service -Name $service -StartupType Automatic
            Stop-Service -Name $service
        }
        foreach ($service in [array]::Reverse($services)) {
            Start-Service -Name $service
        }
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
    [CmdletBinding()]
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

Function Remove-Files {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String] $source,

        [Parameter(Mandatory = $true)]
        [String] $target
    )
    Process {
        $copy = "/nocopy /mir"
        $fileSelection = "/xc /xn /xo /xl /xj"
        $retry = "/r:5"
        $logging = "/x /ndl /np /unicode"
        Invoke-Checked robocopy "$source $target $copy $fileSelection $retry $logging" 0, 2
    }
}

Function Copy-Files {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String] $source,

        [Parameter(Mandatory = $true)]
        [String] $target
    )
    Process {
        $copy = "/b /dcopy:t /copyall /secfix /timfix /mir"
        $fileSelection = "/xj"
        $retry = "/r:5"
        $logging = "/x /ndl /np /unicode"
        Invoke-Checked robocopy "$source $target $copy $fileSelection $retry $logging" 0, 1, 4, 5
    }
}

Function Invoke-Checked {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String] $command,

        [Parameter(Mandatory = $true)]
        [String] $arguments,

        [Parameter(Mandatory = $false)]
        [int[]] $expectedCodes = 0
    )
    Process {
        $process = Start-Process -FilePath $command -ArgumentList $arguments -NoNewWindow -PassThru -Wait
        $exitCode = $process.ExitCode
        if ( -not $expectedCodes.Contains($exitCode) ) {
            throw "Failed with exit code ${exitCode}: $command $arguments"
        }
    }
}

Mirror @args
