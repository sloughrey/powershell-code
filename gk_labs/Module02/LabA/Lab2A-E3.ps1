Param (
    [string]$computername,
    [int]$arg = 4
)
Get-WmiObject –Class Win32_OperatingSystem –ComputerName $computername |
  Invoke-WmiMethod –Name Win32Shutdown –Arg $arg |
  Out-Null
