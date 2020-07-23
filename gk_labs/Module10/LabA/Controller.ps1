#requires -module MyTools

while ($true) {
    Write-Host "      SERVICE MENU      "
    Write-Host "========================" 
    Write-Host " 1. System Information  "
    Write-Host " 2. Disk Information    "
    Write-Host " 3. Restart a computer  "
    Write-Host ""
    Write-Host "Ctrl+C to exit"
    Write-Host ""
    $choice = Read-Host "Selection"

    if ($choice -eq 1 -or $choice -eq 2 -or $choice -eq 3) {
        $computers = @()
        do {
            $x = Read-Host "Enter one computer name to target; Enter on a blank line to proceed"
            if ($x -ne '') { $computers += $x }
        } until ($x -eq '')
    }

    switch ($choice) {
        
        1 { Get-OSInfo -computername $computers }

        2 { Get-DiskInfo -computername $computers }

        3 { Invoke-OSShutdown -computername $computers -action Restart }

    }
}