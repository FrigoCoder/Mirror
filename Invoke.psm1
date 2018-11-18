Function Invoke-Checked {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String] $command,

        [Parameter(Mandatory)]
        [String] $arguments,

        [Parameter()]
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
