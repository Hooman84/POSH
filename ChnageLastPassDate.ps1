Import-Module ActiveDirectory
$users = $null
$users = & Get-ADUser -Filter {Enabled -eq $true} -Properties Name,SamAccountName,pwdlastSet, Description `
    -SearchBase "OU= All Offices, OU=Users, DC=Domain, dc=local" | `
    Sort-Object Name | `
    Select-Object Name,SamAccountName, @{n="Last PassChange"; e={[dateTime]::FromFileTime($_.pwdlastSet)}}, Description
Write-Host "Password dates before changing"
$users
foreach ($user in $users){
        Set-ADUser -Identity $user.samAccountName -Replace @{pwdLastSet = 0}
        Set-ADUser -Identity $user.samAccountName -Replace @{pwdLastSet = -1}
}
$users = & Get-ADUser -Filter {Enabled -eq $true} -Properties Name,SamAccountName,pwdlastSet, Description `
    -SearchBase "OU= All Offices, OU=Users, DC=domain, dc=local" | `
    Sort-Object Name | `
    Select-Object Name,SamAccountName, @{n="Last PassChange"; e={[dateTime]::FromFileTime($_.pwdlastSet)}}, Description
Write-Host "New Password dates after changes"
$users

$users | Export-Csv "C:\Domain-PassChangeDate.csv"

