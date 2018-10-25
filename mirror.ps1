Function Main {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateScript( {Test-Path $_ })]
        [String] $source,

        [Parameter(Mandatory = $true)]
        [ValidateScript( {Test-Path $_ })]
        [String] $target
    )
    Begin {
        "Begin"
        "Source drive: {0}" -f (Get-Drive $source)
        "Target drive: {0}" -f (Get-Drive $target)
    }
    Process {
        "Process"
    }
    End {
        "End"
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

Main @args
