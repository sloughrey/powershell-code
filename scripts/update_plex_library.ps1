#requires -module Plex

Get-PlexLibraries | Out-String | Write-Host -ForegroundColor Cyan

$libsToUpdate = Read-Host "Enter Plex library IDs to update"

# **** Add this validation function ****
# Validate that the libs to update are valid ids
# if(isValidPlexLibraryId($libsToUpdate)){
Update-PlexLibrary $libsToUpdate
#}