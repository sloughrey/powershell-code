﻿<#
    .Synopsis
        Scans a single Plex library for new contents
    .DESCRIPTION
        Refreshes a Plex library and makes new content available in Plex Media Server for the given Plex library ID
    .PARAMETER libraryIds
        The library id to scan for new contents
    .PARAMETER pathToPlexScanner
        The full path to the Plex media scanner executable
    .EXAMPLE
        Update-PlexLibrary -LibraryId 2
#>
function Update-PlexLibrary {
    [CmdletBinding()]

    Param(
        [Parameter(ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [int[]] $libraryIds,
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [string] $pathToPlexScanner = "C:\Program Files (x86)\Plex\Plex Media Server\Plex Media Scanner.exe"
    )

    Begin {
        # Get a list of libraries to perform validation
        Write-Verbose "Getting list of plex libraries for validation"
        [hashtable] $libraries = Get-PlexLibrary
    }

    Process {
        foreach ($libId in $libraryIds) {
            if ($libraries.ContainsKey($libId) -eq $true) {
                $libName = $libraries[$libId]
                Write-Verbose "Scanning library $libName"
                & $pathToPlexScanner --scan --section $libId
            }
            else {
                Write-Warning "Plex library not found for ID: $libId"
            }
        }
    }

    End {
        Write-Verbose "Done scanning all libraries"
    }
}

<#
.Synopsis
   Gets a hashtable with Plex library info
.DESCRIPTION
   Returns a hash table containing the library ID as the key and the Plex library name as the value
.EXAMPLE
   Get-PlexLibraries
.OUTPUTS
    Hashtable
#>
function Get-PlexLibrary {
    [CmdletBinding()]

    Param(
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [string] $pathToPlexScanner = "C:\Program Files (x86)\Plex\Plex Media Server\Plex Media Scanner.exe"
    )

    Begin {}

    Process {
        try {
            $libraries = & $pathToPlexScanner  --list
        }
        catch {
            Write-Error "Plex libraries could not be grabbed using Plex Media Scanner.  Path to exe is: $pathToPlexScanner"
        }

        [hashtable] $libs = @{}
        foreach ( $lib in $libraries) {
            # lib looks like: "5: Library name" where 5 is the library id
            $pieces = $lib.split(':')
            [string] $libName = $pieces[1].trim()
            [int] $libId = $pieces[0]
            $libs[$libId] = $libName
        }

        Write-Output $libs
    }

    End {}
}