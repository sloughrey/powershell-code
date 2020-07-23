function Get-OSInfo {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True)]
        [string[]]$computername,

        [string]$errorlog = 'c:\Scripts\errors.txt',

        [switch]$logerrors
    )
    PROCESS {
        foreach ($computer in $computername) {
            Try {
                $os = Get-WmiObject -EA Stop –Class Win32_OperatingSystem –ComputerName $computer 
                $cs = Get-WmiObject -EA Stop –Class Win32_ComputerSystem –ComputerName $computer 
                $bios = Get-WmiObject -EA Stop –Class Win32_BIOS –ComputerName $computer 
                $props = @{'ComputerName'=$computer;
                           'OSVersion'=$os.version;
                           'SPVersion'=$os.servicepackmajorversion;
                           'OSBuild'=$os.buildnumber;
                           'OSArchitecture'=$os.osarchitecture;
                           'Manufacturer'=$cs.manufacturer;
                           'Model'=$cs.model;
                           'BIOSSerial'=$bios.serialnumber}
                $obj = New-Object -TypeName PSOBject -Property $props
                Write-Output $obj
            } Catch {
                if ($logerrors) {
                    $computer | Out-File $errorlog -append
                }
                Write-Warning "$computer failed"
            }
        }
    }
}

function Get-DiskInfo {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True)]
        [string[]]$computername,

        [int]$drivetype = 3,

        [int]$percentfree = 99,

        [string]$errorlog = 'c:\Scripts\errors.txt',

        [switch]$logerrors
    )
    PROCESS {
        foreach ($computer in $computername) {
            Try {
                $disks = Get-WmiObject -EA Stop –Class Win32_LogicalDisk –Filter "DriveType=$drivetype" –Computer $computer |
                  Where-Object { $_.FreeSpace / $_.Size * 100 –lt $percentfree }
                foreach ($disk in $disks) {
                    $props = @{'ComputerName'=$computer;
                               'Drive'=$disk.deviceid;
                               'FreeSpace'=($disk.freespace / 1GB -as [int]);
                               'Size'=($disk.size / 1GB -as [int]);
                               'FreePercent'=($disk.freespace / $disk.size * 100 -as [int])}
                    $obj = New-Object -TypeName PSObject -Property $props
                    Write-Output $obj
                } 
            } Catch {
                if ($logerrors) {
                    $computer | Out-File $errorlog -append
                }
                Write-Warning "$computer failed"
            }
        }
    }
}

function Invoke-OSShutdown {
    [CmdletBinding()]
    Param (
        [Parameter(ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True)]
        [string[]]$computername,

        [int]$arg = 4,

        [string]$errorlog = 'c:\Scripts\errors.txt',

        [switch]$logerrors
    )
    PROCESS {
        foreach ($computer in $computername) {
            Try {
                Get-WmiObject -EA Stop –Class Win32_OperatingSystem –ComputerName $computer |
                  Invoke-WmiMethod -EA Stop –Name Win32Shutdown –Arg $arg |
                  Out-Null
            } Catch {
                if ($logerrors) {
                    $computer | Out-File $errorlog -append
                }
                Write-Warning "$computer failed"
            }
        }
    }
}

function Get-ComputerVolumeInfo {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$True)]
        [string[]]$ComputerName
    )
    PROCESS {
        foreach ($computer in $computername) {
            $os = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $computer
            $disks = Get-WmiObject -Class Win32_LogicalDisk -ComputerName $computer -Filter "DriveType=3"
            $services = Get-WmiObject -Class Win32_Service -ComputerName $computer
            $procs = Get-WmiObject -Class Win32_Process -ComputerName $computer
            $props = @{'ComputerName'=$computer;
                       'OSVersion'=$os.version;
                       'SPVersion'=$os.servicepackmajorversion;
                       'LocalDisks'=$disks;
                       'Services'=$services;
                       'Processes'=$procs}
            $obj = New-Object -TypeName PSObject -Property $props
            Write-Output $obj
        }
    }
}
