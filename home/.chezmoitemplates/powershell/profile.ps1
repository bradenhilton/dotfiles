function Test-IsInteractive {
    $nonInteractiveParameters = @(
        '-c*', # -Command
        '-e*', # -EncodedCommand
        '-f*', # -File
        '-noni*' # -NonInteractive
    )

    $commandLineArgs = [System.Environment]::GetCommandLineArgs()

    # True if VS Code shell integration is sourced: . "...\Microsoft VS Code\...\shellIntegration.ps1"
    # This is done in the integrated terminal
    if ($commandLineArgs -match '\.\s*\u0022.*vs\s*code.*shellIntegration\.ps1\u0022') {
        return $true
    }

    # False if the command line arguments contain any non-interactive parameters
    foreach ($arg in ($commandLineArgs | Where-Object { $_ -match '^-' })) {
        foreach ($param in $nonInteractiveParameters) {
            if ($arg -like $param) {
                return $false
            }
        }
    }

    return [System.Environment]::UserInteractive
}

if (Test-IsInteractive) {
    $AddCommandToHistory = {
        param (
            [string]
            $Command
        )

        switch ($Command) {
            (
                {
                    ($_ -match '^cd[ ]+.+') -or
                    ($_ -match '^chdir[ ]+.+') -or
                    ($_ -match '^sl[ ]+.+') -or
                    ($_ -match '^[sS]et-[lL]ocation[ ]+.+')
                }
            ) {
                return $false
            }
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

    Import-Module -Name PSReadLine
    @{
        EditMode            = 'Windows'
        PredictionSource    = 'History'
        HistoryNoDuplicates = $true
        AddToHistoryHandler = $AddCommandToHistory
        Colors              = @{
            InlinePrediction = [System.ConsoleColor]::DarkGray
        }
    } | ForEach-Object { Set-PSReadLineOption @_ }

    . (Join-Path -Path (Split-Path -Path $PROFILE) -ChildPath 'starship.ps1')
}