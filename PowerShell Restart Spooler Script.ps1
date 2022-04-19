PowerShell Restart Spooler Script
param (
    $MaxFileAge = (Get-Date).AddHours(-6) 
)

Get-ChildItem -Path C:\Windows\System32\Spool\Printers -Recurse | Where-Object {$_.LastWriteTime -le $MaxFileAge} | Restart-Service -Name Spooler