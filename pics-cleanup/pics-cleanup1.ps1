[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string] $Path
)

$photo_exts = "*.jpg", "*.jpeg", "*.png"
$video_exts = "*.avi", "*.mp4"

Write-Host "Moving photos..."
New-Item -ItemType Directory -Force -Path "$Path\Camera\Photos" | Out-Null
Get-ChildItem -Path $Path\* -Include $photo_exts | 
Where-Object {
    $_.Name -match "\d{8}_\d{6}.*\..+"
} | Move-Item -Destination "$Path\Camera\Photos" -Force

Write-Host "Moving videos..."
New-Item -ItemType Directory -Force -Path "$Path\Camera\Videos" | Out-Null
Get-ChildItem -Path $Path\* -Include $video_exts | 
Where-Object {
    $_.Name -match "\d{8}_\d{6}.*\..+"
} | Move-Item -Destination "$Path\Camera\Videos" -Force