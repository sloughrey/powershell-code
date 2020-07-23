
# Assumes you created C:\Scripts\TestData.xml as directed

Get-ComputerNamesFromXML �FileName C:\Scripts\TestData.xml |
Get-OSInfo |
Set-XMLFileData �FileName C:\Scripts\TestData.xml
