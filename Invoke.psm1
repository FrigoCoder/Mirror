Function Invoke-Checked {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [Alias("FilePath")]
        [String] $command,

        [Parameter(Mandatory)]
        [Alias("ArgumentList")]
        [String] $arguments,

        [Parameter()]
        [Alias("ExpectedExitCodes")]
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
