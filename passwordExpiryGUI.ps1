<# This form was created using POSHGUI.com  a free online gui designer for PowerShell
.NAME
    passwordExpiry
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

#region begin GUI{ 

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '400,413'
$Form.text                       = "PasswordExipryCalculator"
$Form.TopMost                    = $false

$Domain                          = New-Object system.Windows.Forms.Label
$Domain.text                     = "Domain"
$Domain.AutoSize                 = $true
$Domain.width                    = 25
$Domain.height                   = 10
$Domain.location                 = New-Object System.Drawing.Point(29,11)
$Domain.Font                     = 'Microsoft Sans Serif,10'

$Domaintxt                       = New-Object system.Windows.Forms.TextBox
$Domaintxt.multiline             = $false
$Domaintxt.width                 = 230
$Domaintxt.height                = 20
$Domaintxt.location              = New-Object System.Drawing.Point(150,6)
$Domaintxt.Font                  = 'Microsoft Sans Serif,10'

$searchBase                      = New-Object system.Windows.Forms.Label
$searchBase.text                 = "SearchBase"
$searchBase.AutoSize             = $true
$searchBase.width                = 25
$searchBase.height               = 10
$searchBase.location             = New-Object System.Drawing.Point(27,34)
$searchBase.Font                 = 'Microsoft Sans Serif,10'

$searchBasetxt                   = New-Object system.Windows.Forms.TextBox
$searchBasetxt.multiline         = $false
$searchBasetxt.width             = 230
$searchBasetxt.height            = 20
$searchBasetxt.location          = New-Object System.Drawing.Point(150,34)
$searchBasetxt.Font              = 'Microsoft Sans Serif,10'

$serverIP                        = New-Object system.Windows.Forms.Label
$serverIP.text                   = "DC IP"
$serverIP.AutoSize               = $true
$serverIP.width                  = 25
$serverIP.height                 = 10
$serverIP.location               = New-Object System.Drawing.Point(31,62)
$serverIP.Font                   = 'Microsoft Sans Serif,10'

$DCiptxt                         = New-Object system.Windows.Forms.TextBox
$DCiptxt.multiline               = $false
$DCiptxt.width                   = 231
$DCiptxt.height                  = 20
$DCiptxt.location                = New-Object System.Drawing.Point(150,61)
$DCiptxt.Font                    = 'Microsoft Sans Serif,10'

$genrateList                     = New-Object system.Windows.Forms.Button
$genrateList.text                = "GenerateList"
$genrateList.width               = 99
$genrateList.height              = 30
$genrateList.location            = New-Object System.Drawing.Point(25,353)
$genrateList.Font                = 'Microsoft Sans Serif,10'

$Output                          = New-Object system.Windows.Forms.Label
$Output.text                     = "Output Location"
$Output.AutoSize                 = $true
$Output.width                    = 25
$Output.height                   = 10
$Output.location                 = New-Object System.Drawing.Point(30,89)
$Output.Font                     = 'Microsoft Sans Serif,10'

$outputLocation                  = New-Object system.Windows.Forms.TextBox
$outputLocation.multiline        = $false
$outputLocation.text             = "C:\"
$outputLocation.width            = 230
$outputLocation.height           = 20
$outputLocation.location         = New-Object System.Drawing.Point(150,87)
$outputLocation.Font             = 'Microsoft Sans Serif,10'

$Email                           = New-Object system.Windows.Forms.Label
$Email.text                      = "Email "
$Email.AutoSize                  = $true
$Email.width                     = 25
$Email.height                    = 10
$Email.location                  = New-Object System.Drawing.Point(35,118)
$Email.Font                      = 'Microsoft Sans Serif,10'

$emailBox                        = New-Object system.Windows.Forms.TextBox
$emailBox.multiline              = $false
$emailBox.text                   = "helpdesk@frontline.ca"
$emailBox.width                  = 230
$emailBox.height                 = 20
$emailBox.location               = New-Object System.Drawing.Point(150,114)
$emailBox.Font                   = 'Microsoft Sans Serif,10'

$hooman                          = New-Object system.Windows.Forms.Label
$hooman.text                     = "Designed by Hooman Zabihi"
$hooman.AutoSize                 = $true
$hooman.width                    = 25
$hooman.height                   = 10
$hooman.location                 = New-Object System.Drawing.Point(0,304)
$hooman.Font                     = 'Microsoft Sans Serif,9,style=Bold'
$hooman.ForeColor                = "#f10b0b"

$emailUsers                      = New-Object system.Windows.Forms.Button
$emailUsers.text                 = "NotifyUsers"
$emailUsers.width                = 103
$emailUsers.height               = 30
$emailUsers.location             = New-Object System.Drawing.Point(248,353)
$emailUsers.Font                 = 'Microsoft Sans Serif,10'

$username                        = New-Object system.Windows.Forms.Label
$username.text                   = "Username"
$username.AutoSize               = $true
$username.width                  = 25
$username.height                 = 10
$username.location               = New-Object System.Drawing.Point(13,207)
$username.Font                   = 'Microsoft Sans Serif,10'

$Usernametxt                     = New-Object system.Windows.Forms.TextBox
$Usernametxt.multiline           = $false
$Usernametxt.width               = 235
$Usernametxt.height              = 20
$Usernametxt.location            = New-Object System.Drawing.Point(111,200)
$Usernametxt.Font                = 'Microsoft Sans Serif,10'

$password                        = New-Object system.Windows.Forms.Label
$password.text                   = "Password"
$password.AutoSize               = $true
$password.width                  = 25
$password.height                 = 10
$password.location               = New-Object System.Drawing.Point(15,233)
$password.Font                   = 'Microsoft Sans Serif,10'

$Passwordtxt                     = New-Object system.Windows.Forms.TextBox
$Passwordtxt.multiline           = $false
$Passwordtxt.width               = 235
$Passwordtxt.height              = 20
$Passwordtxt.location            = New-Object System.Drawing.Point(111,226)
$Passwordtxt.Font                = 'Microsoft Sans Serif,10'

$Form.controls.AddRange(@($Domain,$Domaintxt,$searchBase,$searchBasetxt,$serverIP,$DCiptxt,$genrateList,$Output,$outputLocation,$Email,$emailBox,$hooman,$emailUsers,$username,$Usernametxt,$password,$Passwordtxt))

#region gui events {
$genrateList.Add_Click({ generateList })
$Domaintxt.Add_Leave({ searchBase })
$emailUsers.Add_Click({ notifyUsers })
#endregion events }

#endregion GUI }


#####Constants:
$today = Get-Date
$alertDays = 70
$expireDays = 90
$expireDate = $today.AddDays($expireDays)
$emailList = @()
$userList = @()
$domainName = "Results"
$errors = ""

#####Code
function searchBase () {
    ##############################
    #.SYNOPSIS
    #Populates The SearchBase
    #
    #.DESCRIPTION
    #Calculates basic SearchBase based on the Domain name
    #
    #.EXAMPLE
    #freebieIT.local
    #
    #.NOTES
    #General notes
    ##############################
    try{
        $domain = $Domaintxt.Text.Split('.')
        $searchBasetxt.Text = "DC={0},DC={1}" -f ($domain[0],$domain[1])
        $Usernametxt.Text = "{0}\username" -f ($domain[0])
        $domainName = $domain[0]
    }
    catch {
        $hooman.Text = "An Error Occured Calculating SearchBase, please type it in"
    }

    try{
        $ip = Resolve-DnsName $Domaintxt.Text -Type A
        $DCiptxt.text = $ip[0].IPAddress
    }
    catch{
        $hooman.Text = "An Error Occured Calculating IP, please type it in"
    }
    
}
function generateList () {
    try{
        Import-Module ActiveDirectory

        
        $Usernametxt.Text
        $cred = Get-Credential  $Usernametxt.Text
        
        Write-Host $searchBasetxt.Text, $DCiptxt.Text
        $serverIP = [IPAddress]$DCiptxt.text.Trim()
        $users = Get-ADUser -Server $serverIP -Credential $cred -SearchBase $searchBasetxt.Text -filter {Enabled -eq $true} -Properties * | Select-Object Name, mail, PasswordLastSet
        #write-host  $users
    }
    catch{
        $hooman.Text = "There is an issue communicating with DC"
        $errors += "There is an issue communicating with DC at {0}`n`r" -f $DCiptxt
        Write-Host $_.Exception.GetType().FullName, $_.Exception.Message
        return 
    }
    foreach ($user in $users){
        #write-host $user
        if ($user.PasswordLastSet -ne $null)
        {   
            try{
                $daysSinceChange = [int]((New-TimeSpan -Start $user.PasswordLastSet -End $today).Days)
                Write-Host $daysSinceChange             
                if ($daysSinceChange -ge $alertDays){
                    $passswordExpiryDate = $user.PasswordLastSet.AddDays($expiryDate)
                    $userToAdd = New-Object PSObject 
                    $userToAdd | Add-Member -MemberType NoteProperty -Name "Name" -Value $user.Name
                    $userToAdd | Add-Member -MemberType NoteProperty -Name "Email" -Value $user.mail
                    $userToAdd | Add-Member -MemberType NoteProperty -Name "Expiry Date" -Value $passswordExpiryDate
                    #$userList += $user
                    $userList = $userList + $userToAdd
                    Write-Host "Success 2"
                }
            }
            catch{
                Write-Host $_.Exception.GetType().FullName, $_.Exception.Message
                #Write-Host "There is an Error calculating Password dates for {0} user" -f $user.Name
                $errors += "[1]There is an Error calculating Password dates for {0} user`n`r" -f $user.Name
            }
        }
        else{
            #Write-Host "There is an Error calculating Password dates for {0} user" -f $user.Name
            $errors += "[2]There is an Error calculating Password dates for {0} user`n`r" -f $user.Name
        }
    }
        write-host $userList
        $filename = "{0}\{1}.csv" -f ($outputLocation.text, $domainName )
        write-host $filename
        $userList | Export-Csv $filename
        $hooman.text = "List is Generated and save at {0}" -f $filename
        $fileerror = "{0}\{1}.txt" -f ($outputLocation.text, "Errors")
        $errors | Out-File $fileerror
}

    


[void]$Form.ShowDialog()