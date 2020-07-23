<#
    .SYNOPSIS
    Retrieves disk information.
    .PARAMETER ComputerName
    The name or IP address of one or more computers.
    .PARAMETER LogErrors
    Log failed computer names to a text file.
    .PARAMETER ErrorLog
    The file name to log computer names to - defaults to c:\Scripts\errors.txt.
    .PARAMETER PercentFree
    The free percent threshold - defaults to 10.
#>
function Get-DiskInfo {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Mandatory = $True,
            HelpMessage = 'Computer name or IP address')]
        [Alias('hostname')]
        [ValidateCount(1, 5)]
        [string[]]$computername,

        [Parameter(Mandatory = $True,
            HelpMessage = 'Numeric hard drive type')]
        [int]$drivetype,

        [Parameter(HelpMessage = 'Percent free space threshold')]
        [int]$percentfree = 99,

        [Parameter(HelpMessage = 'Default is C:\powershell_code\error_logs\errors.txt')]
        [string]$errorlog = 'c:\powershell_code\error_logs\errors.txt',

        [Parameter(HelpMessage = 'Enable failed computer logging')]
        [switch]$logerrors
    )
    PROCESS {
        foreach ($computer in $computername) {
            Try {
                $disks = Get-WmiObject -EA Stop –Class Win32_LogicalDisk –Filter "DriveType=$drivetype" –Computer $computer |
                Where-Object { $_.FreeSpace / $_.Size * 100 –lt $percentfree }
                foreach ($disk in $disks) {
                    $props = @{'ComputerName' = $computer;
                        'Drive'               = $disk.deviceid;
                        'FreeSpace'           = ($disk.freespace / 1GB -as [int]);
                        'Size'                = ($disk.size / 1GB -as [int]);
                        'FreePercent'         = ($disk.freespace / $disk.size * 100 -as [int])
                    }
                    $obj = New-Object -TypeName PSObject -Property $props
                    $obj.PSObject.TypeNames.Insert(0, 'MyTools.DiskInfo')
                    Write-Output $obj
                }
            }
            Catch {
                if ($logerrors) {
                    $computer | Out-File $errorlog -append
                }
                Write-Warning "$computer failed"
            }
        }
    }
}

# Module functions to make available
Export-ModuleMember -Function Get-DiskInfo