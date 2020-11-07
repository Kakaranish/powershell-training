[CmdletBinding()]
param (
    [ValidateScript( { return $_ -ge 0 }, ErrorMessage = "Must be >= 0")]
    [int] $ToGenerateNum,

    [ValidateScript( { return Test-Path -Path $_ }, ErrorMessage = "Such directory does not exist")]
    [string] $Directory = "."
)

function Confirm {
    param (
        [string] $title
    )
    
    if ($title) {
        Write-Host $title
    }

    $choice = Read-Host "Do you want to continue (y/n)"    
    if ($choice -ne "y") {
        exit
    }
}

function generateContent {
    $linesNum = Get-Random -Minimum 20 -Maximum 50
    $content = ""
    for ($i = 0; $i -lt $linesNum; $i++) {
        $content += "SOME CONTENT | SOME CONTENT | SOME CONTENT"
        if ($i -ne $($linesNum - 1)) {
            $content += "`n"
        }
    }
    return $content
}

Confirm -title "You will create $ToGenerateNum file(s) in `"$(Resolve-Path $Directory)`" directory"

for ($i = 0; $i -lt $ToGenerateNum; $i++) {
    $filename = "$(New-Guid).txt"
    $filePath = Join-Path $Directory $filename
    New-Item -Path $filePath -ItemType File -Value "$(Generate-Content)" -Force
}