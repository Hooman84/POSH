Import-Module ActiveDirectory
$computers = Get-ADComputer -searchBase "ou=PCs, ou=Computers, dc=domain, dc=local" -server Acc-caldc01 -filter {Enabled -eq $True} -Properties Name 
$computers
foreach ($computer in $computers.Name){
    $Des = ""
    $computer
    $OS = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $computer
    if (-not $?){
        continue
    }
    $computerSystem = get-wmiobject Win32_ComputerSystem -Computer $Computer | Select-Object  Model, Username
    $user = ($computerSystem.Username).Split("\")[1]
    $username = Get-ADUser -Server Acc-caldc01 -Identity $user -Properties Name, title, city
    $Des += ($username.Name + " - " + $username.title + " - " + $username.city)
    $Des

}
