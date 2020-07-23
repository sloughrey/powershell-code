param (
    [string]$computername
)
Get-WmiObject –Class Win32_OperatingSystem –ComputerName $computername | 
  Select-Object Version,ServicePackMajorVersion,BuildNumber,OSArchitecture 
