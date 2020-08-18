# 1. run a Best Practices Analyzer (BPA) report for Directory Services and DNS Server

# Try find a module relating to best practices
Get-Module -ListAvailable

# Find commands for the BestPractices Module
Get-Command -Module BestPractices

# Figure out which function will call the analyzer and how to use it
Get-Help Get-BpaModel -full
Get-Help Invoke-BpaModel -full

# Run the analyzer for the Directory Services and DNS Server
Get-BpaModel -ModelId Microsoft/Windows/DirectoryServices, Microsoft/Windows/DNSServer | Invoke-BpaModel