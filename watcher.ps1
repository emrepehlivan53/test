##set watcher.Path to match the folder you want to monitor
##watcher.Filter to be set to wildcard, you can exclude file types from ### filesystemwatcher exclude files section
##watcher.IncludeSubdirectories to be true, you can exclude directories from ### filesystemwatcher exclude directory section
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = “K:\Dump\”
$watcher.Filter = “*.*”
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true
#what to do when a event is detected
$action = {
$fileName = Split-Path $Event.SourceEventArgs.FullPath -leaf
$path = $Event.SourceEventArgs.FullPath
### filesystemwatcher exclude files
### for excluding multiple file types use if (-not ($fileName -like ‘*.resources’) -and -not ($fileName -like ‘*.otherextension’))###

if (-not ($fileName -like ‘*.resources’) ) {

$changeType = $Event.SourceEventArgs.ChangeType
$logline = “$(Get-Date), $changeType, $path”

#write to log file
Add-content “K:\dumpfilewatcher.txt” -value $logline
### filesystemwatcher exclude directory
### for excluding multiple directories
if (-not ($logline -like ‘*cache*’) -and -not ($logline -like ‘*Log*’) ) {
### trigger mail via smtp
$AWS_ACCESS_KEY = “your-aws-access-key-here”
$AWS_SECRET_KEY = “your-aws-access-secret-here”
$SECURE_KEY = $(ConvertTo-SecureString -AsPlainText -String $AWS_SECRET_KEY -Force)
$creds = $(New-Object System.Management.Automation.PSCredential ($AWS_ACCESS_KEY, $SECURE_KEY))
$from = “localdumps@odeabank.com.tr”
$to = “yunusemre.pehlivan@odeabank.com.tr”
Send-MailMessage -From $from -To $to -Subject $logline -Body $logline -SmtpServer mailrelay.odeabank.com.tr -Credential $creds -UseSsl -Port 25
}
}
}
#what events to be watched
Register-ObjectEvent $watcher “Created” -Action $action
Register-ObjectEvent $watcher “Changed” -Action $action
Register-ObjectEvent $watcher “Deleted” -Action $action
Register-ObjectEvent $watcher “Renamed” -Action $action
while ($true) {sleep 5}