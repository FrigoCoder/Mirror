Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$PSDefaultParameterValues['*:ErrorAction'] = 'Stop'

Import-Module .\Shadow
Import-Module .\Mount
Import-Module .\Service
Import-Module .\Invoke

Function Mirror {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String] $sourceDrive,

        [Parameter(Mandatory)]
        [String] $targetDrive,

        [Parameter()]
        [String] $shadowDrive = 'B:'
    )
    Reset-Services COMsysAPP, SENS, EventSystem, SwPrv, VSS
    $shadow = New-Shadow $sourceDrive
    try {
        New-Mount $shadowDrive $shadow.DeviceObject
        try {
            Remove-Files $shadowDrive $targetDrive
            Copy-Files $shadowDrive $targetDrive
        }
        finally {
            Remove-Mount $shadowDrive $shadow.DeviceObject
        }
    }
    finally {
        Remove-Shadow $shadow
    }
}

Function Remove-Files {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String] $source,

        [Parameter(Mandatory)]
        [String] $target
    )
    Process {
        $copy = '/b /nocopy /mir'
        $fileSelection = '/xc /xn /xo /xl /xj /xjd /xjf'
        $retry = '/r:5'
        $logging = '/x /ndl /np'
        Invoke-Checked robocopy "$source $target $copy $fileSelection $retry $logging" 0, 2
    }
}

Function Copy-Files {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String] $source,

        [Parameter(Mandatory)]
        [String] $target
    )
    Process {
        $copy = '/b /copy:DATSOU /dcopy:DAT /secfix /timfix /mir'
        $fileSelection = '/xj /xjd /xjf'
        $retry = '/r:5'
        $logging = '/x /ndl /np'
        Invoke-Checked robocopy "$source $target $copy $fileSelection $retry $logging" 0, 1, 4, 5
    }
}

Mirror @args
