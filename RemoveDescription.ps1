Import-Module ActiveDirectory
$users = $null
$users = & Get-ADUser -Filter {Enabled -eq $true} -Properties Name,SamAccountName,pwdlastSet, Description `
    -SearchBase "OU= Frontline, DC=Domain, dc=local" | `
    Sort-Object Name | `
    Select-Object Name,SamAccountName, @{n="Lasst PassChange"; e={[dateTime]::FromFileTime($_.pwdlastSet)}}, Description

foreach ($user in $users){

    set-aduser -Identity $user.SamAccountName -server acc-caldc01 -Verbose -Description ""
}
