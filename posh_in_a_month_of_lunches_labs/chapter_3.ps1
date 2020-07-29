<#
1 Can you find any cmdlets capable of converting other cmdlets’ output into HTML?
2 Are there any cmdlets that can redirect output into a file, or to a printer?
3 How many cmdlets are available for working with processes? (Hint: Remember that cmdlets all use a singular noun.)
4 What cmdlet might you use to write to an event log?
5 You’ve learned that aliases are nicknames for cmdlets; what cmdlets are available to create, modify, export, or import aliases?
6 Is there a way to keep a transcript of everything you type in the shell, and save that transcript to a text file?
7 It can take a long time to retrieve all of the entries from the Security event log. How can you get just the 100 most recent entries?
8 Is there a way to retrieve a list of the services that are installed on a remote computer?
9 Is there a way to see what processes are running on a remote computer?
10 Examine the help file for the Out-File cmdlet. The files created by this cmdlet default to a width of how many characters? Is there a parameter that would enable you to change that width?
11 By default, Out-File will overwrite any existing file that has the same filename as what you specify. Is there a parameter that would prevent the cmdlet from overwriting an existing file?
12 How could you see a list of all aliases defined in PowerShell?
13 Using both an alias and abbreviated parameter names, what is the shortest command line you could type to retrieve a list of running processes from a computer named Server1?
14 How many cmdlets are available that can deal with generic objects? (Hint: Remember to use a singular noun like “object” rather than a plural one like “objects”).
15 This chapter briefly mentioned arrays. What help topic could tell you more about them?
16 The Help command can also search the contents of a help file. Are there any topics that might explain any breaking changes between PowerShell v1 and PowerShell v2
#>

# 1 ConvertTo-Html
Get-Help *html*

# 2 Out-Printer / Out-File
Get-Help *printer*
Get-Help *file*

# 3 debug/get/start/stop/wait-proces
Get-Command -Noun 'process'

# 4 clear/get/limit/new/remove/show/write-eventlog
Get-Command -Noun 'eventlog'

# 5 export/get/import/new/set-alias
Get-Command -Noun "alias"

# 6 start/stop-transcript
Get-help *transcript*
Get-Command -Noun "transcript"

# 7
Get-Help Get-EventLog -full
Get-EventLog -LogName Security -Newest 100

# 8
help Get-Service
Get-Service -ComputerName remoteComputerName

# 9
Get-Process -ComputerName remoteComputerName

# 10 defaults to 80 chars / width param allows to change it
Get-Help Out-File -full

# 11 NoClobber switch param used to overwrite
Get-Help Out-File -full

# 12
Get-Help Get-Alias -full
Get-Alias

# 13
help gps -full
gps -Cn Server1

# 14 compare/foreach/group/measure/new/select/sort/tee/where-object
Get-Command -Noun Object

# 15
help about_arrays

# 16
help *breaking*

