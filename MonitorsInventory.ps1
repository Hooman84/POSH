Import-Module activedirectory
$ArrComputers =  Get-ADComputer -server 'DC2' -filter * -Properties * -SearchBase 'OU=WorkStations, OU=AllComputers, dc=domain,dc=lan' | select Name, operatingSystem

write-host $ArrComputers
$results = @()
foreach ($Computer in $ArrComputers.Name) 
{
    Get-WmiObject WmiMonitorID -ComputerName $Computer -Namespace root\wmi
    
}