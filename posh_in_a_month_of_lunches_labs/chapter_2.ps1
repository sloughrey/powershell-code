<#
    1 Create a text file that contains the names of the files and folders in C:\Windows
    (don’t worry about including subdirectories—that would take too long). Name
    the text file MyDir.txt.
    2 Display the contents of that text file.
    3 Rename the file from MyDir.txt to WindowsDir.txt.
    4 Create a new folder named LabOutput—you can either do this in your Documents folder, or in the root of your C: drive.
    5 Copy WindowsDir.txt into the LabOutput folder.
    6 Delete the original copy of WindowsDir.txt—not the copy that you just made in
    LabOutput.
    7 Display a list of running processes.
    8 Redirect a list of running processes into a file named Procs.txt.
    9 Move Procs.txt into the LabOutput folder if it isn’t in there already.
    10 Display the contents of Procs.txt so that only one page displays at a time
    (remember the trick with | more).
#>

Get-ChildItem -Path "C:\Windows\" | Out-File -FilePath ".\lab_output\MyDir.txt"
Get-Content ".\lab_output\MyDir.txt" | Write-Output
Rename-Item -Path ".\lab_output\MyDir.txt" "WindowsDir.txt"
New-Item -Path ".\lab_output" -ItemType Directory
Copy-Item ".\WindowsDir.txt" ".\lab_output"
Remove-Item ".\WindowsDir.txt"
Get-Process
Get-Process | Out-File ".\procs.txt"
Move-Item .\"procs.txt" ".\lab_output"
Get-Content .\"lab_output\procs.txt" | more
