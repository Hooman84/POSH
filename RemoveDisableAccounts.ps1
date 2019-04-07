Import-Module ActiveDirectory
$users = get-aduser -searchBase "ou=Disabled Accounts, ou=users, dc=Domain, dc=local" -server 10.10.1.7 -filter {Enabled -eq $False} | select samAccountname

$groups = get-ADGroup -searchBase "ou=security groups, ou=users, dc=Domain, dc= local" -server 10.10.1.7 -filter * |select samaccountname

foreach ($g in $groups){
    foreach ($u in $users){
        Remove-ADGroupMember -Identity $g.samaccountname -members $u.samaccountname -confirm:$false 
        }
    }

