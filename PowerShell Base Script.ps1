PowerShell
#Challenge 1: 
#List the commands used for services in the Management module 
Get-Service | Get-Member
Get-Help *-Service

#Count of services on the windows server
Get-Service | Measure-Object

#Command(s) to restart the print spooler service on the local computer
Restart-Service -Name Spooler


#Challenge 2:
#Listing of only those services that are running
Get-Service | Where-Object {$_.Status -eq "Running"} 

#Filter report to contain Name, Status, Startup Type, File Location
Get-Service | Where-Object {$_.Status -eq "Running"} | Select-Object -Property Name,Status,StartType,BinaryPathName

#get-wmiobject win32_service | Select-Object -Property Name,Status,StartMode,PathName | Format-Table (optional, PowerShell 5 version)


#Challenge 3:
#Files stored to be retrievable at least 30 days in past (removes anything older than 30 days)
$ServPath = "C:\RunningServices"
$CurrentDate= Get-Date
Get-ChildItem $ServPath | Where-Object { $_.LastWriteTime -lt $CurrentDate.AddDays(-30) } | Remove-Item

$DetPath = "C:\ServiceDetails"
$CurrentDate= Get-Date
Get-ChildItem $DetPath | Where-Object { $_.LastWriteTime -lt $CurrentDate.AddDays(-30) } | Remove-Item

#Exported running services to an HTML file
$Servfilename = "RunningServices " + (Get-Date -Format "MM/dd/yyyy")
Get-Service | Where-Object {$_.Status -eq "Running"} | ConvertTo-Html | Out-File -FilePath C:\RunningServices\$Servfilename.html
 
#Exported details to a JSON file
$Detfilename = "ServiceDetails " + (Get-Date -Format "MM/dd/yyyy")
Get-Service | Where-Object {$_.Status -eq "Running"} | Select-Object -Property Name,Status,StartType,BinaryPathName | ConvertTo-Json | Out-File -FilePath C:\ServiceDetails\$Detfilename.json



#Challenge 4:
#Find files in the output from your services for today successfully
$CurrentDate = (Get-Date).ToString("MM/dd/yyyy")

$ServPath = "C:\RunningServices"
$TodaysServFile = Get-ChildItem -Path $ServPath -Recurse | Where-Object {$_.LastWriteTime.ToString("MM/dd/yyyy") -eq $CurrentDate}
$null -eq $TodaysServFile ? (Write-Warning -Message "Today's file has not been created") : ($TodaysServFile)

$DetPath = "C:\ServiceDetails"
$TodaysDetFile = Get-ChildItem -Path $DetPath -Recurse | Where-Object {$_.LastWriteTime.ToString("MM/dd/yyyy") -eq $CurrentDate}
$null -eq $TodaysDetFile ? (Write-Warning -Message "Today's file has not been created") : ($TodaysDetFile)


#What command will look for files in spooler folder
#and if older than 6 hours, restart printer spooler
$MaxFileAge = (Get-Date).AddHours(-6)
Get-ChildItem -Path C:\Windows\System32\Spool\Printers -Recurse | Where-Object {$_.LastWriteTime -le $MaxFileAge} | Restart-Service -Name Spooler


#Challenge 5:
#Script file to export services to files
#Show that a parameter is included to allow for the root folder of export
#Refer to script file "PowerShell HTML and JSon Service Scripts"

#A script file to check for old spool files and restart the print spooler service

#Show the parameter age of files as variable value

#HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Spooler