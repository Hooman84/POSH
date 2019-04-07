$url = "https://freebieit.com/ODY/Disable-Office-AutoSave.reg"
$regFile = "c:\FreebieIT\office.reg"
mkdir c:\freebieit
cd c:\FreebieIT
Invoke-WebRequest -Uri $url -OutFile $regFile

$regFileContents = Get-Content -Path $RegFile -ReadCount 0
$TempRegFile = "c:\FreebieIT\officeTemp.reg"

$explorers = Get-WmiObject -Class Win32_Process -Filter "Name='Explorer.exe'"
$explorers | ForEach-Object {
    $owner = $_.GetOwner()
    if ($owner.ReturnValue -eq 0) {
        $user = "{0}\{1}" -f $owner.Domain, $owner.User
        $oUser = New-Object -TypeName System.Security.Principal.NTAccount($user)
        $sid = $oUser.Translate([System.Security.Principal.SecurityIdentifier]).Value

        $regFileContents = $regFileContents -replace 'HKEY_CURRENT_USER', "HKEY_USERS\$sid"
        write $regFileContents
        $regFileContents | Out-File -FilePath $TempRegFile 
        $p = Start-Process -FilePath C:\Windows\regedit.exe -ArgumentList @('/s', $TempRegFile) -PassThru
        do { Start-Sleep -Seconds 1 } while (-not $p.HasExited)
    
        Remove-Item -Path $TempRegFile -Force
    }
}