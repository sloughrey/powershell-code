<#

1 Identify a cmdlet that will produce a random number.

2 Identify a cmdlet that will display the current date and time.

3 What type of object does the cmdlet from task #2 produce? (What is the type name of the object produced by the cmdlet?)

4 Using the cmdlet from task #2 and Select-Object, display only the current day of the week in a table like this: DayOfWeek --------- Monday

5 Identify a cmdlet that will display information about installed hotfixes.Lab 71

6 Using the cmdlet from task #5, display a list of installed hotfixes. Sort the list by the installation date, and display only the installation date, the user 
  who installed the hotfix, and the hotfix ID.

7 Repeat task #6, but this time sort the results by the hotfix description, and include the description, the hotfix ID, and the installation date. Put the results into an HTML file.

8 Display a list of the 50 newest entries from the Security event log (you can use a different log, such as System or Application, if your Security log is empty). Sort 
  the list so that the oldest entries appear first, and so that entries made at the same time are sorted by their index. Display the index, time, and source for 
  each entry. Put this information into a text file (not an HTML file, just a plain text file).
#>


# 1 
    # Find the cmdlet that generates a random number
    Get-Help -Name *random*

    # Get-Random will get us a random number
    Get-Random

# 2
    # Look for date commands
    Get-Command -noun *date*

    # Get-Date will get the current date and time
    Get-Date

# 3 
    # Find the name of the type that is returned from Get-Date, use Get-Member for
    # more detailed information of function properties, methods, output types.. etc
    Get-Date | Get-Member

    # Get-Date uses the DateTime object

# 4
    # Find the properties of the DateTime object
    Get-Date | Get-Member -MemberType Property

    # Print only the current day of the week
    Get-Date | Select-Object -Property DayOfWeek

# 5
    # Find a command to get hotfix info
    Get-Help -Name *hotfix*

    # Get-HotFix will display 
    Get-HotFix

# 6
    # Find out what properties are available
    Get-HotFix | Get-Member -MemberType Properties

    # Print out the sorted info
    Get-HotFix | Sort-Object -Property InstalledOn | Select-Object -Property InstalledOn, InstalledBy, HotFixID

# 7
    # Output hotfix data to an html file
    Get-HotFix | Sort-Object -Property Description | Select-Object -Property InstalledOn, Description, HotFixID | ConvertTo-Html | Out-File .\lab_output\hotfixes.html

# 8
    # Find the log function we need to display the application log
    Get-Command -Noun *log* -Verb Get

    # Find the event log names
    Get-EventLog -LogName *

    # Sort the application log by time and index and filter the properties to display to index, time written and source
    Get-EventLog -LogName Application -Newest 50 | 
        Sort-Object -Property @{Expression = "TimeWritten"; Descending = $true}, @{Expression = "Index"; Descending = $false} |
            Select-Object -Property Index, TimeWritten, Source | Out-File .\lab_output\app_log_50_newest_entries_sorted.txt
        

