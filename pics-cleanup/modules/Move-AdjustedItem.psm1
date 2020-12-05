function Move-AdjustedItem {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)] [System.IO.FileInfo] $items,
        [System.Collections.Generic.HashSet[string]] $UniqueFilenamesSet,
        [string] $Dest
    ) 

    Process {
        foreach ($item in $items) {
            $key = "$Dest\$($item.Name)"
            $filename = if (-not($UniqueFilenamesSet.Contains($key))) {
                $UniqueFilenamesSet.Add($key) | Out-Null
                $item.Name | Out-Null
            }
            else {
                if ([System.String]::IsNullOrWhiteSpace($item.BaseName)) {
                    $item.Extension + "-" + $(New-Guid) 
                }
                else {
                    $item.BaseName + "-" + $(New-Guid) + $item.Extension
                }
            }
        
            $destination_file_path = "$Dest\$filename"
            
            $adjusted_full_path = $item.FullName.Replace("[", "``[").Replace("]", "``]")
            Move-Item -Path $adjusted_full_path -Destination $destination_file_path -Force | Out-Null
        }
    }
}

Export-ModuleMember Move-AdjustedItem