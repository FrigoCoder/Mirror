Function New-Mount {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String] $drive,

        [Parameter(Mandatory)]
        [String] $path
    )
    Process {
        Invoke-DefineDosDevice 0 $drive $path
    }
}

Function Remove-Mount {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String] $drive,

        [Parameter(Mandatory)]
        [String] $path
    )
    Process {
        Invoke-DefineDosDevice 6 $drive $path
    }
}

Function Invoke-DefineDosDevice {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [uint32] $flags,

        [Parameter(Mandatory)]
        [String] $drive,

        [Parameter(Mandatory)]
        [String] $path
    )
    Process {
        $DefineDosDevice = '[DllImport("kernel32.dll", CharSet=CharSet.Auto, SetLastError=true)] public static extern bool DefineDosDevice(int dwFlags, string lpDeviceName, string lpTargetPath);'
        $Kernel32 = Add-Type -MemberDefinition $DefineDosDevice -Name 'Kernel32' -Namespace 'Win32' -PassThru
        $success = $Kernel32::DefineDosDevice($flags, $drive, $path)
        if ( -not $success ) {
            throw [ComponentModel.Win32Exception][Runtime.InteropServices.Marshal]::GetLastWin32Error()
        }
    }
}
