
<#
 You need to save this file to C:\Program Files\WindowsPowerShell\Modules\MyTools\MyTools.psm1
#>

function Get-OSInfo {
    param (
        [string]$computername
    )
    Get-WmiObject –Class Win32_OperatingSystem –ComputerName $computername | 
      Select-Object Version,ServicePackMajorVersion,BuildNumber,OSArchitecture 
}

function Get-DiskInfo {
    param (
        [string]$computername,
        [int]$drivetype,
        [int]$percentfree = 99
    )
    Get-WmiObject –Class Win32_LogicalDisk –Filter "DriveType=$drivetype" –Computer $computername |
      Where-Object { $_.FreeSpace / $_.Size * 100 –lt $percentfree } 
}

function Invoke-OSShutdown {
    Param (
        [string]$computername,
        [int]$arg = 4
    )
    Get-WmiObject –Class Win32_OperatingSystem –ComputerName $computername |
      Invoke-WmiMethod –Name Win32Shutdown –Arg $arg |
      Out-Null
}

