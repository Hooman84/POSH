mkdir C:\FreebieIT
cd C:\FreebieIT

#Add FreebieIT Local User
New-LocalUser -Name "FreebieIT" -Password  (ConvertTo-SecureString -String 'Off!' -AsPlainText -Force) -AccountNeverExpires 
Add-LocalGroupMember -Group "Administrators" -Member "FreebieIT"

##Change power settings to keep Laptop Alive while on Power
powercfg.exe /X standby-timeout-ac 0
powercfg.exe /X monitor-timeout-ac 40

##Install 7Zip
$url = "https://freebieit.com/ODY/7Zip.exe"
$7zipFile = "7Zip.exe"
Invoke-WebRequest -Uri $url -OutFile $7zipFile 
.\7Zip.exe /S

#Install Adobe Reader:
$url = "https://freebieit.com/ODY/Adobe.exe"
$adobeFile = "Adobe.exe"
Invoke-WebRequest -Uri $url -OutFile $adobeFile 
.\Adobe.exe /sPB /rs /msi

##Install Office 365 OfficeDeploy
$url = "https://freebieit.com/ODY/OfficeDeploy.zip"
$OfficeZip = "C:\FreebieIT\Office.zip"
Invoke-WebRequest -Uri $url -OutFile $OfficeZip
expand-archive -Path $officeZip -DestinationPath "C:\freebieit\Office"
cd C:\freebieit\Office
.\Office365Install.bat


##Clean FreebieIT folder
Remove-Item c:\FreebieIT\* -Recurse -Force -ErrorAction SilentlyContinue

