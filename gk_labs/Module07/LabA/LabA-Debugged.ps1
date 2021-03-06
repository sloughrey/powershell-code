Function Get-ServiceInfo {

    [cmdletbinding()]
    Param (
            [string]$Computername=$env:computername
          )

    # Wrapping the parameters using a forcible backtick ` character
    $services = Get-WmiObject -Class Win32_service `
                              -filter "state='Running'" `
                              -computername $computername

    Write-Host "Found $($services.count) on $computername" -ForegroundColor Green

    # Wrapping the command after the pipe symbol
    $services | 
        sort -Property startname,name | 
        Select -property startname,name,startmode,Systemname

} #close function