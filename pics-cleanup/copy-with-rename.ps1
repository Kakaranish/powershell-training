[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)] [string] $Path,
    [Parameter(Mandatory = $true)] [string] $Destination
)

Import-Module ".\modules\Ensure-DirExists.psm1" -DisableNameChecking
Import-Module ".\modules\Move-AdjustedItem.psm1" -DisableNameChecking

if (-Not (Test-Path -Path $Path)) {
    Write-Error -Message "'$Path' does not exist" -ErrorAction Stop
}
Ensure-DirExists $Destination

$unique_filenames = New-Object System.Collections.Generic.HashSet[string]

Get-ChildItem -File -Recurse -Path $Path | 
Move-AdjustedItem -uniqueFilenamesSet $unique_filenames -dest $Destination