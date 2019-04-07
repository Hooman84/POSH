Import-Module ActiveDirectory
$computers = Get-ADComputer -SearchBase "OU=Test, OU= Calgary PCs, OU= Computers, DC= Domain , DC= Local" -Server DC01
foreach ($computer in $computers){
    Checkpoint-Computer -Description ("Power Shutdown on {0}" -f (get-date)) -
}

