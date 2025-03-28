$PSDefaultParameterValues['*:Encoding'] = 'utf8'
$OutputEncoding = [System.Text.UTF8Encoding]::new()

function Test-IsInteractive {
    $commandLineArgs = [System.Environment]::GetCommandLineArgs()

    foreach ($arg in $commandLineArgs) {
        # False if the command line arguments contain any non-interactive parameters
        if ($arg -imatch '-noni(?:n(?:t(?:e(?:r(?:a(?:c(?:t(?:i(?:v(?:e)?)?)?)?)?)?)?)?)?)?') {
            return $false
        }

        # True if VS Code shell integration is sourced: . "...\Microsoft VS Code\...\shellIntegration.ps1"
        # This is done in the integrated terminal
        if ($arg -match '\.\s*\u0022.*vs\s*code.*shellIntegration\.ps1\u0022') {
            return $true
        }
    }

    return [System.Environment]::UserInteractive
}

if (Test-IsInteractive) {
    $addCommandToHistory = {
        param (
            [string]$Command
        )

        switch ($Command) {
            (
                {
                    ($_ -contains '--help') -or
                    ($_ -contains '-h') -or
                    ($_ -contains '-?') -or
                    ($_ -match 'help$') -or
                    ($_ -match '^[gG]et-[hH]elp[ ]+.+')
                }
            ) {
                return $false
            }
            default { return $true }
        }
    }
    Import-Module -Name PSReadLine -ErrorAction SilentlyContinue
    @{
        EditMode            = 'Windows'
        HistoryNoDuplicates = $true
        AddToHistoryHandler = $addCommandToHistory
    } | ForEach-Object { Set-PSReadLineOption @_ -ErrorAction SilentlyContinue }

    Import-Module -Name 'posh-git' -ErrorAction SilentlyContinue

    $currentErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'SilentlyContinue'
    . (Join-Path -Path (Split-Path -LiteralPath $PROFILE) -ChildPath 'starship-init.ps1')
    . (Join-Path -Path (Split-Path -LiteralPath $PROFILE) -ChildPath 'zoxide-init.ps1')
    $ErrorActionPreference = $currentErrorActionPreference
}
