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
}
Process {
    "Process"
}
End {
    "End"
}
