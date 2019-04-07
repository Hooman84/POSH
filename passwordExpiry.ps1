$today = Get-Date
$alertDays = 70
$expireDays = 90
$expireDate = $today.AddDays($expireDays)
$emailList = @()
Import-Module ActiveDirectory
$users = Get-ADUser -SearchBase "OU=All Offices,OU=users,DC=Domain,DC=Local" -filter * -Properties * | Select-Object Name, mail, PasswordLastSet

foreach ($user in $users){
    $daysSinceChange = (New-TimeSpan -Start $user.PasswordLastSet -End $today).Days 
    if ($daysSinceChange -ge $alertDays){
        $user.PasswordLastSet = $daysSinceChange
        $emailList += $user
    }

}
foreach ($u in $emailList){
 Write-Host $u
}
