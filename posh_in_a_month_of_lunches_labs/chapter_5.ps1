# 1. run a Best Practices Analyzer (BPA) report for Directory Services and DNS Server

# Try find a module relating to best practices
Get-Module -ListAvailable

# Find commands for the BestPractices Module
Get-Command -Module BestPractices

# Figure out which function will call the analyzer and how to use it
Get-Help Get-BpaModel -full
Get-Help Invoke-BpaModel -full

# Figure out what model ids we need
Get-BpaModel -ModelId * | ft

# Run the analyzer for the Directory Services and DNS Server
Get-BpaModel -ModelId Microsoft/Windows/DirectoryServices, Microsoft/Windows/DNSServer | Invoke-BpaModel | ConvertTo-Html | Out-File -FilePath ".\lab_output\ds_dns_bpa_results.html"


# Bonus work section

# Figure out what commands are available relating to a GPO
Get-Command -Module GroupPolicy

# Make a new OU to play with
$ouName = "Test OU 2"
New-ADOrganizationalUnit -Name $ouName -Path "DC=sean,DC=local"

# Make a new GPO
$gpoName = "Test GPO 2"
New-GPO -Name $gpoName

# Link our GPO to an OU or update
New-GPLink -Name $gpoName -Target "OU=$ouName,DC=sean,DC=local" -LinkEnabled Yes
Set-GPLink -Name $gpoName -Target "OU=$ouName,DC=sean,DC=local" -LinkEnabled No
