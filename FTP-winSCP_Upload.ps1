$ftpAddress = ""
$ftpUser    = ""
$ftpPass    = ""
$localFilePattern = "**"
$remoteLocation    = "/"
$remoteFileName    = ""
$today      = get-date -Format M/dd/yyyy
$emailBody  = "`t`tStatus of  File Upload/Download`r`n"
$localLocation = "D:\Shared"
$result     = $true
$subjectSucess = "SUCCES- File Uploaded Successfuly to "
$subjectFail   = "!FAILED!- File Did NOT Uploaded to "
$smtpServer = "mail.protection.outlook.com"


try{
    #WinScp DLL and Exe are saved in the root folder of dcript in DLL folder
    Add-Type -Path (Join-Path $PSScriptRoot "\DLL\WinSCPnet.dll")
    #Specify session options
    $sessionOptions = New-Object WinSCP.SessionOptions -Property @{
        Protocol = [WinSCP.Protocol]::Ftp
        HostName = $ftpAddress
        UserName = $ftpUser
        Password = $ftpPass
        }
    #create a new Session Object
    $session = New-Object WinSCP.Session
    #Try to open session
    try{
        $session.Open($sessionOptions) #opening the session
        $emailBody += "[*] Session opened to FTP server at {0}`r`n" -f (get-date)
        $tranferOptions = New-Object WinSCP.TransferOptions #create a Transfer options, it will be Ascii
        $tranferOptions.TransferMode = [WinSCP.TransferMode]::Ascii #it will be used for PUT when uploading files

        $localFiles = Get-ChildItem -File $localLocation #get local file listing
        #get the Files match with pattern and return name and normalized date and fullname
        
        $recentFiles = $localFiles `
            | Where-Object{$_.name -like $localFilePattern -and $_.LastWriteTime -ge $today} `
            | Select-Object Name,@{Name = 'Date'; Expression = {get-date $_.LastWriteTime -format M/dd/yyyy}},fullname
        
        #If th Recent Files return empy, it means no file with today timestamps is uploaded to FTP and throw and Error
        If ($recentFiles -eq $null) {
            throw "No New Files for {0} added. please contact provider" -f $today
        }
        
        foreach ($file in $recentFiles){
            $emailBody += "[*] File Added to Queue to Upload: {0}`r`n" -f $file.name
            $remotefile = "{0}/{1}" -f ($remoteLocation,$remoteFileName) #Using the Filename specified by CDS
            $session.PutFiles($file.FullName, $remotefile, $false, $tranferOptions).Check()
        }
        
        $emailBody += "[+] All Files Uploaded from {0} location successfully `r`n"  -f $localLocation   
        
        <#foreach ($fileInfo in $remoteFiles.Files){
            write-host $fileInfo.Name, $fileInfo.LastWriteTime
        }
        #>

    }
    finally{
        $session.Dispose()
        $emailBody += "[+] FTP session ended successfully`r`n[*] Sending email notification and terminating script at {0}`r`n" -f (get-date)
    }
}
catch {
    $result = $false
    $emailBody += "[-] Upload Failed for {0}`r`n`t******Error**********`r`n{1}" -f ($today, $_.Exception.Message)

}

$emailBody | Out-File -FilePath "winScp_Upload_Log.txt"

$subject = ""
if ($result -eq $True){
    $subject = $subjectSucess
}
else{
    $subject = $subjectFail
}

$anonUsername = "anonymous"
$anonPassword = ConvertTo-SecureString -String "anonymous" -AsPlainText -Force
$anonCredentials = New-Object System.Management.Automation.PSCredential($anonUsername,$anonPassword)
Send-MailMessage -To "" -From "" -Subject $subject -Body $emailBody -SmtpServer $smtpServer -Port 25 -Credential $anonCredentials