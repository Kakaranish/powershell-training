[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string] $Path
)

Import-Module ".\modules\Ensure-DirExists.psm1" -DisableNameChecking -Force
Import-Module ".\modules\Move-AdjustedItem.psm1" -DisableNameChecking -Force

function Merge-Regexes {
    param (
        [string[]] $Regexes
    )
    
    return ( $Regexes | ForEach-Object { "($_)" } ) -join "|"
}

$photo_exts = "*.jpg", "*.jpeg", "*.png"
$photo_regexes = Merge-Regexes @(
    "IMG_\d{8}_\d{6}", 
    "$\d{11}\."
)

$video_exts = "*.avi", "*.mp4", ".webm"
$video_regexes = Merge-Regexes @(
    "VID_\d{8}_\d{6}\.", 
    "\d{11}\."
)

$screenshot_regexes = Merge-Regexes @(
    "$Screenshot_\d{4}(-\d{2}){4}",
    "$Screenshot_\d{4}-\d{6}"
)

$output_dir = Join-Path (Get-Item $Path).Parent "Output"

$photos_dir = Join-Path $output_dir "Photos"
$videos_dir = Join-Path $output_dir "Videos"
$screenshots_dir = Join-Path $output_dir "Screenshots"
$random_pics_and_videos_dir = Join-Path $output_dir "Random Media"
$other_files_dir = Join-Path $output_dir "Other Files"

$directories = @($photos_dir, $videos_dir, $screenshots_dir, $random_pics_and_videos_dir, $other_files_dir)
foreach ($dir in $directories) {
    Ensure-DirExists -Dir $dir
}

$unique_filenames = New-Object System.Collections.Generic.HashSet[string]

Write-Host "Processing photos..."
Get-ChildItem $Path\* -Include $photo_exts -Recurse | 
Where-Object { $_.Name -match $photo_regexes } |
Move-AdjustedItem -UniqueFilenamesSet $unique_filenames -Dest $photos_dir


Write-Host "Processing videos..."
Get-ChildItem -File $Path\* -Include $video_exts -Recurse | 
Where-Object { $_.Name -match $video_regexes } | 
Move-AdjustedItem -UniqueFilenamesSet $unique_filenames -Dest $videos_dir 


Write-Host "Processing screenshots..."
Get-ChildItem -File $Path\* -Include $photo_exts -Recurse | 
Where-Object { $_.Name -match $screenshot_regexes } | 
Move-AdjustedItem -UniqueFilenamesSet $unique_filenames -Dest $screenshots_dir


Write-Host "Processing random pictures/vidoes..."
Get-ChildItem -File $Path\* -Include ($photo_exts + $video_exts) -Recurse |
Move-AdjustedItem -UniqueFilenamesSet $unique_filenames -Dest $random_pics_and_videos_dir


Write-Host "Processing random files..."
Get-ChildItem -File $Path\*  -Recurse  |
Move-AdjustedItem -UniqueFilenamesSet $unique_filenames -Dest $other_files_dir