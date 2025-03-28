[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Provides a boolean value for use in script templates')]
$isElevated = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

function Invoke-Elevated {
    param (
        [System.IO.FileInfo]$Path
    )

    $arguments = @('-NoLogo', '-NoProfile', '-NonInteractive', '-File', "`"$Path`"")
    # $process = Start-Process -FilePath 'powershell' -ArgumentList $arguments -Verb 'RunAs' -WindowStyle ([System.Diagnostics.ProcessWindowStyle]::Hidden) -PassThru -Wait
    # $global:LASTEXITCODE = $process.ExitCode
    if (Get-Command -Name 'sudo' -CommandType Application -ErrorAction SilentlyContinue) {
        sudo --preserve-env powershell @arguments
    } else {
        Start-Process -FilePath 'powershell' -ArgumentList $arguments -Verb RunAs -WindowStyle Hidden -PassThru -Wait
        exit $process.ExitCode
    }
}
