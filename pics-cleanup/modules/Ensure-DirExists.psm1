function Ensure-DirExists {
    param (
        [string] $Dir
    )
    New-Item -ItemType Directory -Force -Path $Dir | Out-Null    
}

Export-ModuleMember -Function Ensure-DirExists