<#
1   Create a CliXML reference file for the services on your computer. Then, change
    the status of some non-essential service like BITS (stop it if it’s already started;
    start it if it’s stopped on your computer). Finally, use Diff to compare the reference CliXML file to the current state of your computer’s services. You’ll need to
    specify more than the Name property for the comparison—does the -property
    parameter of Diff accept multiple values? How would you specify those multiple values?
2   Create two similar, but different, text files. Try comparing them using Diff. To
    do so, run something like this: Diff -reference (Get-Content File1.txt)
    -difference (Get-Content File2.txt). If the files have only one line of text
    that’s different, the command should work. If you add a bunch of lines to one
    file, the command may stop working. Try experimenting with the Diff command’s -syncWindow parameter to see if you can get the command working
    again.
3   What happens if you run Get-Service | Export-CSV services.csv | Out-File
    from the console? Why does that happen?
4   Apart from getting one or more services and piping them to Stop-Service,
    what other means does Stop-Service provide for you to specify the service or
    services you want to stop? Is it possible to stop a service without using GetService at all?Lab 47
5   What if you wanted to create a pipe-delimited file instead of a comma-separated
    file? You would still use the Export-CSV command, but what parameters would
    you specify?
6   Is there a way to eliminate the # comment line from the top of an exported CSV
    file? That line normally contains type information, but what if you wanted to
    omit that from a particular file?
7   Export-CliXML and Export-CSV both modify the system, because they can create and overwrite files. What parameter would prevent them from overwriting
    an existing file? What parameter would ask you if you were sure before proceeding to write the output file?
8   Windows maintains several regional settings, which include a default list separator. On U.S. systems, that separator is a comma. How can you tell Export-CSV to
    use the system’s default separator, rather than a comma?
#>

# 1
Get-Service | Export-Clixml -Path ./lab_output/cur_service_list.xml
$subsonicProcess = Get-Service Subsonic -ErrorAction SilentlyContinue
if ($subsonicProcess.Status -eq 'Running') {
    Write-Host 'Stopping subsonic'
    $subsonicProcess | Stop-Service
}
else {
    Write-host 'Starting subsonic'
    Start-Service Subsonic
}
Compare-Object -ReferenceObject (Import-Clixml ./lab_output/cur_service_list.xml) -DifferenceObject (Get-Service) -Property Name, status

# 2 SyncWindow seems to group file differences together in the output
"Test file 1" | Out-File -FilePath ./lab_output/test_txt_1.txt
"Test file 2" | Out-File -FilePath ./lab_output/test_txt_2.txt
diff -ReferenceObject (Get-Content ./lab_output/test_txt_1.txt)  -DifferenceObject (Get-Content ./lab_output/test_txt_2.txt) -SyncWindow 3

# 3
Get-Service | Export-CSV ./lab_output/services.csv | Out-File
<#
A services.csv files is first created from the first piped command using Get-Service as the data to be stored.
Then the out-file command fails to run, expecting a path value to be given.
All the piped commands up until the failing command seem to run.
#>

# 4
Get-Help stop-service -Online
<#
It's possible to stop a service using its name or displayname.
There are also options to exclude certain services.
Use of wildcards is permitted to match multiple services at onces.
#>

# 5
Get-Help Export-CSV -Online
<#
To create a pipe-delimited file instead of a comma separated file you would use the delimiter parameter
#>
Get-Service | Export-Csv -Path .\lab_output\pipe_delimited_services_csv.csv -Delimiter '|'

# 6
Get-Help Export-CSV -Online
Get-Service | Export-Csv -Path .\lab_output\services_no_type_info_csv.csv -NoTypeInformation
<#
The NoTypeInformation parameter will omit the #TYPE header information
#>

# 7 
Get-Help Export-Clixml -Online
Get-Service | Export-Csv -Path .\lab_output\services.csv -NoClobber -Confirm
<# 
The "Confirm" parameter will for a confirmation before running the cmdlet
The "NoClobber" parameter will prevent the command from overwriting an existing file if it exists already
#>

# 8 The 'UseCulture' parameter will use the windows regional default delimiter
Get-Help Export-Csv -Online
Get-Service | Export-Csv -UseCulture -Path .\lab_output\services_with_default_delim_by_region.csv
