<# Start by running this #>
$metadata = New-Object System.Management.Automation.CommandMetaData (Get-Command Export-CSV)
[System.Management.Automation.ProxyCommand]::Create($metadata) | Out-File C:\Scripts\ExportCSVProxy.ps1
