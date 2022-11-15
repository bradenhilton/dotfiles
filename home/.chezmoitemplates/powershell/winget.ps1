function winget-{{ . }} {
    foreach ($arg in $args) {
        if (-not [string]::IsNullOrWhitespace($arg)) {
            & winget {{ . }} "${arg}"
        }
    }
}
