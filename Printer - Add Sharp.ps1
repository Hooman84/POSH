$url = "https://freebieit.com/ODY/Sharp_MX3701.zip"
$printerZip = "c:\FreebieIT\Sharp.zip"
mkdir c:\freebieit
cd c:\FreebieIT
Invoke-WebRequest -Uri $url -OutFile $printerZip
expand-archive -Path $printerZip -DestinationPath C:\freebieit\Sharp
cd Sharp

pnputil.exe /add-Driver su2hmenu.inf
Add-PrinterDriver -Name "SHARP MX-3071 PS"
Add-PrinterPort -Name "SharpMX3701-CGY-52" -PrinterHostAddress "192.168.0.52"
Add-Printer -Name "Sharp MX-3701 CGY" -DriverName "SHARP MX-3071 PS" -PortName "SharpMX3701-CGY-52"

Get-Printer -Name *Sharp*