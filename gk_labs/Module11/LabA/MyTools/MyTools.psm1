function Get-OSInfo {
    <#
    .SYNOPSIS
    Retrieves operating system information.
    .PARAMETER ComputerName
    The name or IP address of one or more computers.
    .PARAMETER LogErrors
    Log failed computer names to a text file.
    .PARAMETER ErrorLog
    The file name to log computer names to - defaults to c:\Scripts\errors.txt.
    #>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   Mandatory=$True,
                   HelpMessage='Computer name or IP address')]
        [Alias('hostname')]
        [ValidateCount(1,5)]
        [string[]]$computername,

        [Parameter(HelpMessage='Default is C:\Scripts\errors.txt')]
        [string]$errorlog = 'c:\Scripts\errors.txt',

        [Parameter(HelpMessage='Enable failed computer logging')]
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
                $obj.PSObject.TypeNames.Insert(0,'MyTools.OSInfo')
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
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   Mandatory=$True,
                   HelpMessage='Computer name or IP address')]
        [Alias('hostname')]
        [ValidateCount(1,5)]
        [string[]]$computername,

        [Parameter(Mandatory=$True,
                   HelpMessage='Numeric hard drive type')]
        [int]$drivetype,

        [Parameter(HelpMessage='Percent free space threshold')]
        [int]$percentfree = 99,

        [Parameter(HelpMessage='Default is C:\Scripts\Errors.txt')]
        [string]$errorlog = 'c:\Scripts\errors.txt',

        [Parameter(HelpMessage='Enable failed computer logging')]
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
                    $obj.PSObject.TypeNames.Insert(0,'MyTools.DiskInfo')
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
    <#
    .SYNOPSIS
    Offers a variety of ways to shut down one or more computers.
    .PARAMETER ComputerName
    The name or IP address of one or more computers.
    .PARAMETER LogErrors
    Log failed computer names to a text file.
    .PARAMETER ErrorLog
    The file name to log computer names to - defaults to c:\Scripts\errors.txt.
    .PARAMETER Action
    The action to take, as defined by Win32_OperatingSystem class Win32Shutdown() method.
    .PARAMETER Force
    Forces the action
    #>
    [CmdletBinding(SupportsShouldProcess=$True,
                   ConfirmImpact='High')]
    Param (
        [Parameter(ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   Mandatory=$True,
                   HelpMessage='Computer name or IP address')]
        [string[]]$computername,

        [Parameter(Mandatory=$True,
                   HelpMessage='Action to take')]
        [ValidateSet('LogOff','Shutdown','Restart','PowerOff')]
        [string]$action,

        [Parameter(HelpMessage='Force the action')]
        [switch]$force,

        [Parameter(HelpMessage='Default is C:\Scripts\Errors.txt')]
        [string]$errorlog = 'c:\Scripts\errors.txt',

        [Parameter(HelpMessage='Enable failed computer logging')]
        [switch]$logerrors
    )
    BEGIN {
        $real_action = 0
        switch ($action) {
            'LogOff'   { $real_action = 0 }
            'Shutdown' { $real_action = 1 }
            'Restart'  { $real_action = 2 }
            'PowerOff' { $real_action = 8 }
        }
        if ($force) {
            $real_action += 4
        }
    }
    PROCESS {
        foreach ($computer in $computername) {
            Try {
                Get-WmiObject -EA Stop –Class Win32_OperatingSystem –ComputerName $computer |
                  Invoke-WmiMethod -EA Stop –Name Win32Shutdown –Arg $real_action |
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
    <#
    .SYNOPSIS
    Retrieves extended computer system information.
    .PARAMETER ComputerName
    The name or IP address of one or more computers.
    #>
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
