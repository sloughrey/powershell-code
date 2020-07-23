Import-Module PSWorkflow

Workflow Provision1 {
    parallel {

        New-Item -Path HKLM:\SOFTWARE\Custom -Force
        New-ItemProperty -Path HKLM:\SOFTWARE\Custom `
                            -Name Test `
                            -Value 0 -Force
        
        Get-Service 
    }
}

Provision1 -PSComputerName Alpha,Bravo,Echo
# Echo will not work if Remoting is not enabled on it
# That is expected