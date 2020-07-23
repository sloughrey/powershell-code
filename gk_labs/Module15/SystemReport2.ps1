#requires -module CorpTools

[CmdletBinding()]
Param(
    [string]$ComputerName,
    [string]$OutFilePath
)

$na = Get-NetAdaptInfo -computername $ComputerName |
      ConvertTo-HTML -PreContent '<h2>Network Adapters</h2>' -Fragment |
      Out-String

$si = Get-SystemInfo -computername $ComputerName |
      ConvertTo-HTML -PreContent '<h2>SystemInfo</h2>' -Fragment |
      Out-String

$rs = Get-StartedServices -computername $ComputerName |
      ConvertTo-HTML -PreContent '<h2>Running Services</h2>' -Fragment |
      Out-String

ConvertTo-HTML -PreContent "$computername Information" -PostContent $na,$si,$rs |
Out-File $OutFilePath
