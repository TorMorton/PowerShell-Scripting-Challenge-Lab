param (
    $ServPath = "C:\RunningServices", 
    $DetPath = "C:\ServiceDetails"
)

#PowerShell HTML and JSon Service Scripts
#Challenge 5 Script Criteria
#First, check folders for any files older than 30 days, and define folders as parameters
$CurrentDate= Get-Date
Get-ChildItem $ServPath -Recurse | Where-Object { $_.LastWriteTime -lt $CurrentDate.AddDays(-30) } | Remove-Item

$CurrentDate= Get-Date
Get-ChildItem $DetPath -Recurse | Where-Object { $_.LastWriteTime -lt $CurrentDate.AddDays(-30) } | Remove-Item

#Next, convert and export service information to respective file formats
$Servfilename = "RunningServices " + (Get-Date -Format "mm-dd-yyyy")
Get-Service | Where-Object {$_.Status -eq "Running"} | ConvertTo-Html | Out-File -FilePath $ServPath\$Servfilename.html

$Detfilename = "ServiceDetails " + (Get-Date -Format "mm-dd-yyyy")
Get-Service | Where-Object {$_.Status -eq "Running"} | Select-Object -Property Name,Status,StartType,BinaryPathName | ConvertTo-Json | Out-File -FilePath $DetPath\$Detfilename.json