#requires -module MyTools

[CmdletBinding()]
Param(
    [string[]]$ComputerName,
    [string]$path
)

$css = @"
<style>
body {
 font-family:Tahoma;
 font-size:12px;
}
th {
 font-weight:bold;
}
</style>
"@

ForEach ($computer in $computername) {
 
 $filepath = Join-Path -Path $path -ChildPath "$computer.html"

 $sys = Get-OSInfo -computername $computer |
        ConvertTo-HTML -PreContent '<h2>System Info</h2>' -Fragment |
        Out-String

 $dsk = Get-DiskInfo -computername $computer |
        ConvertTo-HTML -PreContent '<h2>Disk Info</h2>' -Fragment |
        Out-String

 $prc = Get-Process -computername $computer |
        ConvertTo-HTML -PreContent '<h2>Processes</h2>' -Fragment |
        Out-String

 $svc = Get-Service -computername $computer |
        ConvertTo-HTML -PreContent '<h2>Services</h2>' -Fragment |
        Out-String
 
 $params = @{'Head'="<title>Report for $computer</title>$css";
            'PreContent'="<h1>Information for $computer</h1>";
            'PostContent'=$sys,$dsk,$prc,$svc}
 ConvertTo-Html @params | Out-File -FilePath $filepath
            
}