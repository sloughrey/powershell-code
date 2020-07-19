#### Module Constants
$PlexMediaScannerFilename = "Plex Media Scanner.exe"


<#
.Synopsis
   Scans a single Plex library for new contents
.DESCRIPTION
   Refreshes a Plex library and makes new content available in Plex Media Server
.PARAMETER PathToPMSFolder
    The path to the Plex Media Server folder
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
    
#>
function Update-PlexLibrary
{
    [CmdletBinding()]

    Param(
        [Parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [string] $PathToPMSFolder = "C:\Program Files (x86)\Plex\Plex Media Server\"
    )

    Begin
    {
    }

    Process
    {
            # Determine which library to scan for updates
            $pathToPlexScanner = $PathToPMSFolder + $PlexMediaScannerFilename
            $libraries = & $pathToPlexScanner  --list
            
            [int[]] $validLibIds = @()
            
            foreach( $lib in $libraries){
                # lib looks like: "5: Library name" where 5 is the library id
                $pieces = $lib.split(':')
                $validLibIds += $pieces[0]
            }

            Write-Output $libraries

            do {
                [int] $libIdToScan = Read-Host "Select a library id to update"

            } while ($validLibIds.Contains($libIdToScan) -eq $false)

            # Scan the selected library
            $result = & $pathToPlexScanner --scan --section $libIdToScan
    }

    End
    {
    }
}