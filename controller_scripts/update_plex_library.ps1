#requires -module Plex

Get-PlexLibraries | Out-String | Write-Host -ForegroundColor Cyan

Write-Host -ForegroundColor Green "Enter Plex library IDs to update one at a time and blank when finished"

[array] $libsToUpdate = @()
do {
    $libId = Read-Host

    if ($libsToUpdate.contains($libId) -eq $false -and $libId -ne "") {
        $libsToUpdate += $libId
    }
} while ($libId -ne "")

Update-PlexLibrary -LibraryIds $libsToUpdate -Verbose