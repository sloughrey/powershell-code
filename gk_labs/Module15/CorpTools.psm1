# save as C:\Program Files\WindowsPowerShell\Modules\CorpTools\CorpTools.psm1 to test
# also copy CorpTools.format.ps1xml to that location
# also copy CorpTools.psd1 to that location
# SystemReport2.ps1 is the controller script




function Get-NetAdaptInfo {
    [CmdletBinding()]
    Param(
        [string]$ComputerName
    )
    $adapts = Get-WmiObject -Class Win32_NetworkAdapter -Filter "PhysicalAdapter='True'" -ComputerName $computername
    foreach ($adapt in $adapts) {
        $props = @{'ComputerName'=$computername;
                   'Speed'=($adapt.speed / 1GB -as [int]);
                   'AdapterType'=$adapt.adaptertype;
                   'NetConnectionID'=$adapt.netconnectionid;
                   'MACAddress'=$adapt.macaddress}
        $obj = New-Object -TypeName PSObject -Property $props
        $obj.psobject.typenames.insert(0,'CorpTools.NetAdaptInfo')
        Write-Output $obj
    }
}

function Get-SystemInfo {
    [CmdletBinding()]
    Param(
        [string]$ComputerName
    )
    $cs = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $computername
    $bios = Get-WmiObject -Class Win32_BIOS -ComputerName $computername
    $bb = Get-WmiObject -Class Win32_BaseBoard -ComputerName $computername
    $props = @{'ComputerName'=$computername;
               'DNSHostName'=$cs.dnshostname;
               'AutomaticManagedPageFile'=$cs.automaticmanagedpagefile;
               'Manufacturer'=$cs.manufacturer;
               'Model'=$cs.model;
               'Domain'=$cs.domain;
               'BIOSSerial'=$bios.serialnumber;
               'BaseBoardProduct'=$bb.product;
               'BaseBoardMfgr'=$bb.manufacturer}
    $obj = New-Object -TypeName PSObject -Property $props
    $obj.psobject.typenames.insert(0,'CorpTools.SystemInfo')
    Write-Output $obj
}

function Get-StartedServices {
    [CmdletBinding()]
    Param(
        [string]$ComputerName
    )
    $services = Get-WMIObject -Class Win32_Service -Filter "State='Running'" -computername $ComputerName
    foreach ($service in $services) {
        $props = @{'ComputerName'=$ComputerName;
                   'ServiceName'=$service.name;
                   'Executable'=$service.pathname}
        $obj = New-Object -TypeName PSObject -Property $props
        $obj.psobject.typenames.insert(0,'CorpTools.RunningService')
        Write-Output $obj
    }
}