function Get-OSInfo {
    param (
        [string[]]$computername,
        [string]$errorlog = 'c:\Scripts\errors.txt',
        [switch]$logerrors
    )
    foreach ($computer in $computername) {
        Try {
            Get-WmiObject -EA Stop –Class Win32_OperatingSystem –ComputerName $computer | 
              Select-Object Version,ServicePackMajorVersion,BuildNumber,OSArchitecture 
        } Catch {
            if ($logerrors) {
                $computer | Out-File $errorlog -append
            }
            Write-Warning "$computer failed"
        }
    }
}

function Get-DiskInfo {
    param (
        [string[]]$computername,
        [int]$drivetype,
        [int]$percentfree = 99,
        [string]$errorlog = 'c:\Scripts\errors.txt',
        [switch]$logerrors
    )
    foreach ($computer in $computername) {
        Try {
            Get-WmiObject -EA Stop –Class Win32_LogicalDisk –Filter "DriveType=$drivetype" –Computer $computer |
              Where-Object { $_.FreeSpace / $_.Size * 100 –lt $percentfree } 
        } Catch {
            if ($logerrors) {
                $computer | Out-File $errorlog -append
            }
            Write-Warning "$computer failed"
        }
    }
}

function Invoke-OSShutdown {
    Param (
        [string[]]$computername,
        [int]$arg = 4,
        [string]$errorlog = 'c:\Scripts\errors.txt',
        [switch]$logerrors
    )
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

