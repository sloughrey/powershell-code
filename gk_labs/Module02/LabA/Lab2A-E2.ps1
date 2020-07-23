param (
    [string]$computername,
    [int]$drivetype,
    [int]$percentfree = 99
)
Get-WmiObject –Class Win32_LogicalDisk –Filter "DriveType=$drivetype" –Computer $computername |
  Where-Object { $_.FreeSpace / $_.Size * 100 –lt $percentfree } 
