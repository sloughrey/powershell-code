<#
    .Synopsis
    Scans Plex libraries for new content
    .DESCRIPTION
    Refreshes Plex libraries and makes new content available in Plex Media Server for the given Plex library IDs
    .PARAMETER LibraryIds
    The library ids to scan for new contents
    .EXAMPLE
    Update-PlexLibraries -LibraryId 2
#>
function Update-PlexLibraries {
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
        [hashtable] $libraries = Get-PlexLibraries
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
function Get-PlexLibraries {
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